# NVIDIA Xavier NX - Learning to Fly

## Install L4T and Supporting Jetson Runtime Components
NOTE:  ONLY install L4T initially.  We will add the Jetson RunTime, etc... post-install.

Since I purchased my NVIDIA Jetson Xavier NX Developer Kit from Seeed, I think it's a bit unique/bespoke.  
I *think* the SOC includes an eMMC and then I have an NVMe SSD on my carrier board.

| Type    | device  |  Size  | Purpose                           | Path          |
|:-------:|:-------:|:------:|-----------------------------------|:--------------|
| eMMC    | mmcblk0 | 16GB   | boot device                       | /             |
| NVMe    | nvme0n1 | 128GB  | Jetson runtime, notebooks, etc... | TBD |

While the eMMC is only 16GB and the default L4T consumes around 6G, finding an alternative to store/run the runtimes and notebooks is paramount.

## Configure Xavier OS
```
#sudo apt install -y openssh-server 
#sudo systemctl enable ssh --now

### NOT SURE THIS IS NEEDED 
#sudo apt install -y ufw
#sudo ufw allow ssh

# Configure no-passwd sudo for nvidia user
echo "nvidia ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/nvidia

# Install Jetson Utilities
sudo -H pip install -U jetson-stats
# you need to run this while logged in to the desktop
# sudo jtop

# Need to remove all the unnecessary stuff - like libreOffice (add commands to do this later)
sudo apt-get remove --purge "libreoffice*"
sudo apt-get clean
sudo apt-get autoremove

# Install Logical Volume Manager (clear out old LVM device)
sudo dd if=/dev/zero of=/dev/nvme0n1 bs=512 count=102400
sudo apt install -y lvm2
# Update the system
sudo apt update; sudo apt upgrade -y && sudo shutdown now -r
```

### Configure the NVMe device for usage
Status:  Still need to figure out what directories need their own volume (for growth and capacity)

| Mount Point | Size | VolumeGroup | VolumeName   |
|:-------------|:----|:------------|:-------------|
| /var/lib/docker | 20G | vg_nvme  | lv_docker |
| /usr/local/  | 6G  | vg_nvme     | lv_usr_local |
| /opt         | 4G  | vg_nvme     | lv_opt       |    

The following are installed:
* Jetson Linux
* Jetson Runtime Components
* Jetson SDK Components

Which consumes the following disk space:  
/dev/mmcblk0p1   14G   12G  1.4G  90% /  
/dev/mapper/vg_nvme-lv_opt        5.9G  1.9G  3.7G  35% /opt  
/dev/mapper/vg_nvme-lv_usr_local  5.9G  1.3G  4.3G  23% /usr/local  

And then after installing nvcr.io/nvidia/l4t-ml:r34.1.0-py3  
/dev/mapper/vg_nvme-lv_docker      20G   16G  3.2G  84% /var/lib/docker

As you can see, the Jetson is woefully unprepared to do anything useful in regards to available disk space.  

```
# Configure no-passwd sudo for nvidia user
echo "nvidia ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/nvidia

sudo su -
wipefs -af /dev/nvme0n1
sudo apt install -y lvm2
[ `vgs | grep vg_nvme` ] && vgremove -f vg_nvme # just a good measure
parted -s /dev/nvme0n1 mklabel gpt mkpart pri ext4 2048s 100% set 1 lvm on
pvcreate /dev/nvme0n1p1
vgcreate vg_nvme /dev/nvme0n1p1
lvcreate -nlv_docker -L40g vg_nvme
lvcreate -nlv_opt -L20g vg_nvme
lvcreate -nlv_usr_local -L10g vg_nvme
mkfs.ext4 /dev/mapper/vg_nvme-lv_docker
mkfs.ext4 /dev/mapper/vg_nvme-lv_opt
mkfs.ext4 /dev/mapper/vg_nvme-lv_usr_local

# Update fstab
cp /etc/fstab /etc/fstab.`date +%F`
echo "# Volumes on NVMe device" >> /etc/fstab
echo "/dev/mapper/vg_nvme-lv_docker /var/lib/docker ext4 defaults 0 0" >> /etc/fstab
echo "/dev/mapper/vg_nvme-lv_opt /opt ext4 defaults 0 0" >> /etc/fstab
echo "/dev/mapper/vg_nvme-lv_usr_local /usr/local ext4 defaults 0 0" >> /etc/fstab

mkdir /usr/local.tmp /opt.tmp 
mount /dev/mapper/vg_nvme-lv_opt /opt.tmp/
mount /dev/mapper/vg_nvme-lv_usr_local /usr/local.tmp/

rsync -avE /opt/ /opt.tmp/
rsync -avE /usr/local/ /usr/local.tmp/

mv /opt /opt.old
mv /usr/local /usr/local.old
#mv /usr/lib /usr/lib.old (this will not work - use the BIND mount approach below)
mkdir /opt /usr/local  /var/lib/docker
shutdown now -r


# I don't know whether migrating /usr/lib from / to another volume is going to work
migrate_usr_lib() {
lvcreate -nlv_usr_lib -L10g vg_nvme
mkfs.ext4 /dev/mapper/vg_nvme-lv_usr_lib
echo "/dev/mapper/vg_nvme-lv_usr_lib /usr/lib ext4 defaults 0 0" >> /etc/fstab
mkdir /usr/lib.tmp
mount /dev/mapper/vg_nvme-lv_usr_lib /usr/lib.tmp/
rsync -avE /usr/lib/ /usr/lib.tmp/
sudo su -
mount --bind / /mnt
rm -rf /mnt/usr/lib
umount /mnt
}

# NOTE:  you can remove /usr/local.tmp /opt.tmp - once the reboot has occurred and system is functional
```

## TODO
-- need to mount nvidia home directory in /opt (or a bigger filesystem).  OR... use a different user to install NVIDIA SDK bits
-- this is because the SDK installer will reach out to the Xavier NX (as the user you define) and run df -h -T . (so, in their home directory)

#  Update Xavier Jetson Runtimes (from CLI)

### Install pre-reqs
https://docs.nvidia.com/deeplearning/frameworks/install-pytorch-jetson-platform/index.html
```
sudo apt-get -y install autoconf bc build-essential g++-8 gcc-8 clang-8 lld-8 gettext-base gfortran-8 iputils-ping libbz2-dev libc++-dev libcgal-dev libffi-dev libfreetype6-dev libhdf5-dev libjpeg-dev liblzma-dev libncurses5-dev libncursesw5-dev libpng-dev libreadline-dev libssl-dev libsqlite3-dev libxml2-dev libxslt-dev locales moreutils openssl python-openssl rsync scons python3-pip libopenblas-dev

# This won't work on ARM64
#curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
# sh ./Miniconda3-latest-Linux-x86_64.sh

# Install PyTorch
case `sudo lshw -C systemshw -C system | grep product | awk -F\:\  '{ print $2 }' ` in
  'NVIDIA Jetson Xavier NX Developer Kit')
    # Common tasks
    sudo apt -y install python3-pip cmake curl
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
      && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
    sudo apt-get -y install nvidia-docker2
    # OS-specific tasks
    case `lsb_release -s -d` in
      'Ubuntu 18.04.6 LTS')
        pip3 install torch torchvision torchaudio
      ;;
      'Ubuntu 20.04.4 LTS')
        pip install networkx==3.1
        pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113
      ;;
    esac
  ;;
  'NVIDIA Jetson Nano Developer Kit')
    sudo apt-get -y install python-pip python3-pip cmake
    echo "        pip3 install torch torchvision torchaudio"
    echo "This doesn't work on the Nano? :-("
    export TORCH_INSTALL="https://docs.nvidia.com/deeplearning/frameworks/install-pytorch-jetson-platform/index.html"
    python3 -m pip install --upgrade pip; python3 -m pip install aiohttp numpy=='1.19.4' scipy=='1.5.3' export "LD_LIBRARY_PATH=/usr/lib/llvm-8/lib:$LD_LIBRARY_PATH"; python3 -m pip install --upgrade protobuf; python3 -m pip install --no-cache $TORCH_INSTALL
  ;;
  *)
    echo "Not Supported"
  ;;
esac
```

## Setup Wifi
```
nmcli radio wifi on
nmcli d wifi show
nmcli -a d wifi connect "REVOLUTIONS"
# nmcli -a d wifi connect "REVOLUTIONS" password <pass>
```


## Jetbot Foo
```
cd
[ ! -d jetbot ] && { git clone https://github.com/NVIDIA-AI-IOT/jetbot.git; } || { cd jetbot; git pull; cd; }

# I do not recall what this next block of code was necessary for
#cd ${HOME}/jetbot     
#sudo python3 setup.py install
#cd 

mkdir $HOME/Notebooks
rsync -tugrpolvv ${HOME}/jetbot/notebooks/* ~/Notebooks/

sudo nvpmodel -m1

sudo docker pull nvcr.io/nvidia/l4t-ml:r34.1.0-py3
#sudo docker run -it --rm --runtime nvidia --network host nvcr.io/nvidia/l4t-ml:r34.1.0-py3
sudo docker run -it --rm --runtime nvidia --network host -v /home/nvidia/Notebooks:/Notebooks nvcr.io/nvidia/l4t-ml:r34.1.0-py3

docker run -p 8888:8888 \
           -e JUPYTER_ENABLE_LAB=yes \
           -e JUPYTER_TOKEN=Will0w \
           --name jupyter \
           -d jupyter/datascience-notebook:latest
```
