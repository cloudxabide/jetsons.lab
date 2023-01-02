# NVIDIA Xavier NX - Learning to Fly


```
# Configure no-passwd sudo for nvidia user
echo "nvidia ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/nvidia

# Update the system
sudo apt update; sudo apt upgrade -y 

# Install pre-reqs
# https://docs.nvidia.com/deeplearning/frameworks/install-pytorch-jetson-platform/index.html
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

#
sudo -H pip install -U jetson-stats
# you need to run this while logged in to the desktop
# sudo jtop

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
