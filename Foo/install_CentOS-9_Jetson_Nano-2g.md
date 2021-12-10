# install CentOS-9 Jetson Nano-2g.md

## Goal/Purpose
*hopefully* this doc will detail how to install CentOS 9 Stream on to an Nvidia Jetson Nano 2g.

-- Disclaimer:  I work at Red Hat.  That said, I am *not* an engineer, or part of a business unit that does engineering/development - but.. I *do* have access to those folks.  My point?  I probably will not figure this out on my own and I have some advantages while figuring this out that other folks may not have.

I had wanted to use CentOS Stream on my laptop to do the prep work.  I discovered that both 8 and 9 do not have some supporting packages necessary to quickly/easily go through the steps.  Now, while I *could* figure out how to get all the dependencies lined up, I don't feel it's a good use of my time (nor anyone else that might follow this guide).  Therefore, I am going with Fedora 35 Workstation.

## What you need (physical)
* laptop  
* SD Card
* SD Card reader
* cable between laptop and Jetson Nano (USB-A to microUSB, in my case)
* Power supply for Nano 

## What you need (software)
* [Fedora Workstation](https://getfedora.org/en/workstation/download/)


## The steps
Create installation media on USB stick using the Fedora Media Writer (it really IS simple).  Go to https://getfedora.org/en/workstation/download/ - grab the Writer and start it up (it will pull down the current Fedora ISO for you) 

```
sudo dnf -y install qemu-user-static usbutils uboot-images-armv8 arm-image-installer
```
```
mkdir ~/Downloads/Nvidia_Jetson; cd $_
# wget -r https://developer.nvidia.com/embedded/learn/jetson-nano-2gb-devkit-user-guide
wget https://developer.nvidia.com/embedded/l4t/r32_release_v6.1/t210/jetson-210_linux_r32.6.1_aarch64.tbz2
wget https://developer.nvidia.com/embedded/l4t/r32_release_v6.1/t210/tegra_linux_sample-root-filesystem_r32.6.1_aarch64.tbz2
wget https://developer.nvidia.com/embedded/l4t/r32_release_v6.1/t210/webrtc_r32.6.1_aarch64.tbz2

BOARD=jetson-nano-devkit
L4T_RELEASE_PACKAGE=$(find * -type f -name "Jetson*Linux_R*tbz2")
SAMPLE_FS_PACKAGE=$(find * -type f -name "Tegra_Linux_Sample-Root-Filesystem_R*tbz2")
echo "BOARD: $BOARD"
echo "L4T_RELEASE_PACKAGE: $L4T_RELEASE_PACKAGE"
echo "SAMPLE_FS_PACKAGE: $SAMPLE_FS_PACKAGE"



 
## References
https://nullr0ute.com/2020/11/installing-fedora-on-the-nvidia-jetson-nano/  
[Nvidia Linux for Tegra](https://developer.nvidia.com/embedded/linux-tegra) L4T  
[NVIDIA JETSON LINUX DRIVER PACKAGE QUICK START GUIDE](https://developer.download.nvidia.com/embedded/L4T/r32_Release_v4.4/r32_Release_v4.4-GMC3/T210/l4t_quick_start_guide.txt)
https://www.jetsonhacks.com/

* [CentOS 9 Stream](https://centos.org/)
* [CentOS 8 Stream](https://centos.org/) - for my laptop
