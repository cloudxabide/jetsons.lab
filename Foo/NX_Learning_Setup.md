# NVIDIA Xavier NX - Learning to Fly


```
cat << EOF > /tmp/nvidia
nvidia ALL=(ALL:ALL) NOPASSWD: ALL
EOF
sudo cp /tmp/nvidia /etc/sudoers.d/nvidia

# Install python3 and pip3
# NOTE:  this actually doesn't work because of NVIDIA L4T dependency issues.  Yay!
# sudo apt -y install python3-pip

# Install PyTorch
case in `sudo lshw -C systemshw -C system | grep product | awk -F\: '{ print $2 }'`
  NVIDIA Jetson Xavier NX Developer Kit)
    pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113
  ;;
esac

#
sudo -H pip install -U jetson-stats
# sudo jtop

cd
[ ! -d jetbot ] && { git clone https://github.com/NVIDIA-AI-IOT/jetbot.git; } || { cd jetbot; git pull; cd; }
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
