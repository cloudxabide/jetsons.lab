# install CentOS-9 Jetson Nano-2g.md

## Status
This turned out to be a non-starter (for me).  There are some nuanced things I am not (yet) familiar with.  CentOS is going to be "on hold" for me.

## Goal/Purpose
*hopefully* this doc will detail how to install CentOS 9 Stream on to an NVIDIA Jetson Nano 2g.

-- Disclaimer:  I work at Red Hat.  That said, I am *not* an engineer, or part of a business unit that does engineering/development - but.. I *do* have access to those folks.  My point?  I probably will not figure this out on my own and I have some advantages while figuring this out that other folks may not have.
Also - I think I will be writing some sort of doc to demystify some of the Nano nuances (what is an eMMC.. or SPI?)

I had wanted to use CentOS Stream on my laptop to do the prep work.  I discovered that both 8 and 9 do not have some supporting packages necessary to quickly/easily go through the steps.  Now, while I *could* figure out how to get all the dependencies lined up, I don't feel it's a good use of my time (nor anyone else that might follow this guide).  Therefore, I am going with Fedora 35 Workstation.

## Versions
CentOS: 9 Stream
NVIDIA SDK: r32.6.1

## What you need (physical)
* laptop  
* SD Card
* SD Card reader
* cable between laptop and Jetson Nano (USB-A to microUSB, in my case)
* Power supply for Nano 

## What you need (software)
* [Fedora Workstation](https://getfedora.org/en/workstation/download/)

## The Steps (high-level)

* collect all the requirements (physical and software)  
* Review the entire process prior to starting.  This is NOT my typical approach to problems (if I am being forthcoming).  However, I REALLY think it helps for this procedure - especially if you are as much of a n00b as I am.  
* Flash the (??) on the NVIDIA Jetson Nano   
* Install a CentOS disk image on to an SD card  
* Boot to CentOS 9

## The steps (actual)
Create installation media on USB stick using the Fedora Media Writer (it really IS simple).  Go to https://getfedora.org/en/workstation/download/ - grab the Writer and start it up (it will pull down the current Fedora ISO for you)   
Install Fedora - there is little value in having me detail how to install Fedora here.  There are tons of resources out there.  

Once you have Fedora installed and running, install the following packages
```
sudo dnf -y install qemu-user-static usbutils uboot-images-armv8 arm-image-installer sreen minicom
```

Pull down and unpack the NVIDIA bits
```
mkdir ~/Downloads/NVIDIA_Jetson; cd $_
# wget -r https://developer.nvidia.com/embedded/learn/jetson-nano-2gb-devkit-user-guide
wget https://developer.nvidia.com/embedded/l4t/r32_release_v6.1/t210/jetson-210_linux_r32.6.1_aarch64.tbz2
wget https://developer.nvidia.com/embedded/l4t/r32_release_v6.1/t210/tegra_linux_sample-root-filesystem_r32.6.1_aarch64.tbz2
wget https://developer.nvidia.com/embedded/l4t/r32_release_v6.1/t210/webrtc_r32.6.1_aarch64.tbz2

BOARD=jetson-nano-devkit
L4T_RELEASE_PACKAGE=$(find * -type f -name "jetson-210_linux_r*tbz2")
SAMPLE_FS_PACKAGE=$(find * -type f -name "tegra_linux_sample-root-filesystem_r*tbz2")
echo "BOARD: $BOARD"
echo "L4T_RELEASE_PACKAGE: $L4T_RELEASE_PACKAGE"
echo "SAMPLE_FS_PACKAGE: $SAMPLE_FS_PACKAGE"
```

This process I have gathered from NVIDIA (and applied some minor tweaks)
```
  tar xf ${L4T_RELEASE_PACKAGE}
  cd Linux_for_Tegra/rootfs/
  sudo tar xpf ../../${SAMPLE_FS_PACKAGE}
  cd ..
  sudo ./apply_binaries.sh
```

Apply the jumper to pins 9 and 10 for FRC (FC RED and GND) - if you turn the Nano over you will see the words printed on the circuitboard.  Power on device

Ensure board is ready to be flashed ( you will see "7f21" in the second half of the sixth column
```
$ lsusb | grep -i nvidia | awk '{ print $6 }'
0955:7f21
```
NOTE:  I believe once you can see the device via "lsusb" command you should remove the jumper.

Flash the device
```
sudo ./flash.sh ${BOARD} mmcblk0p1
```
 
## References
https://nullr0ute.com/2020/11/installing-fedora-on-the-nvidia-jetson-nano/   
[NVIDIA Linux for Tegra](https://developer.nvidia.com/embedded/linux-tegra) L4T   
[NVIDIA JETSON LINUX DRIVER PACKAGE QUICK START GUIDE](https://developer.download.nvidia.com/embedded/L4T/r32_Release_v4.4/r32_Release_v4.4-GMC3/T210/l4t_quick_start_guide.txt)  
https://www.jetsonhacks.com/

* [CentOS 9 Stream](https://centos.org/)  
* [CentOS 8 Stream](https://centos.org/) - for my laptop
* https://cloud.centos.org/centos/9-stream/aarch64/images/ (you want the EC2 image, AFAIK)
