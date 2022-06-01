# NVIDIA Xavier NX - Learning to Fly


```
cat << EOF > /tmp/nvidia
nvidia ALL=(ALL:ALL) NOPASSWD: ALL
EOF
sudo cp /tmp/nvidia /etc/sudoers.d/nvidia

sudo apt-get update -y

# Install python3 and pip3
# NOTE:  this actually doesn't work because of NVIDIA L4T dependency issues.  Yay!
# sudo apt -y install python3-pip 

# This won't work on ARM64
#curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
# sh ./Miniconda3-latest-Linux-x86_64.sh

# Install PyTorch
case `sudo lshw -C systemshw -C system | grep product | awk -F\:\  '{ print $2 }' ` in
  'NVIDIA Jetson Xavier NX Developer Kit')
    case `lsb_release -s -d` in
      'Ubuntu 18.04.6 LTS')
        pip3 install torch torchvision torchaudio
      ;;
      'Ubuntu 20.04.4 LTS')
        pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113
      ;;
    esac
  ;;
  *)
    echo "Not Supported"
  ;;
esac

#
sudo -H pip install -U jetson-stats
# you need to run this while logged in to the desktop
# sudo jtop

cd
[ ! -d jetbot ] && { git clone https://github.com/NVIDIA-AI-IOT/jetbot.git; } || { cd jetbot; git pull; cd; }

# I do not recall what this next block of code was necessary for
#cd jetbot     
#sudo python3 setup.py install
#cd 

mkdir $HOME/Notebooks
rsync -tugrpolvv jetbot/notebooks/* ~/Notebooks/

sudo nvpmodel -m1

sudo docker pull nvcr.io/nvidia/l4t-ml:r34.1.0-py3
#sudo docker run -it --rm --runtime nvidia --network host nvcr.io/nvidia/l4t-ml:r34.1.0-py3
sudo docker run -it --rm --runtime nvidia --network host -v /home/nvidia/Notebooks:/Notebooks nvcr.io/nvidia/l4t-ml:r34.1.0-py3
```
