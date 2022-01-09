# Installing Fedora on Jetson Nano 2Gig 

## Status
Almost ZERO progress on this.  Not sure it's worth the squeeze.  We shall see.
Update:  New Status - Deflated :-(  Seriously, I can't believe I am one of only a few people on EARTH to have attempted this.  Seems like the folks who are knowledgeable about the platform are dismissive of folks who want to run an OS other than Ubuntu on the Jetson - and I don't get it.

## Goal
I am installing Fedora on my Jetson Nano(s) in order to run [Microshift](https://github.com/redhat-et/microshift) to test out some Edge Kubernetes (then possibly some edge ML).


## Steps
Once you have Fedora installed and running, install the following packages

```
sudo dnf -y install qemu-user-static usbutils uboot-images-armv8 arm-image-installer screen minicom
```

Pull down and unpack the Nvidia bits
```
mkdir ~/Downloads/Nvidia_Jetson; cd $_
wget https://developer.nvidia.com/embedded/l4t/r32_release_v6.1/t210/jetson-210_linux_r32.6.1_aarch64.tbz2
wget https://developer.nvidia.com/embedded/l4t/r32_release_v6.1/t210/tegra_linux_sample-root-filesystem_r32.6.1_aarch64.tbz2
wget https://developer.nvidia.com/embedded/l4t/r32_release_v6.1/t210/webrtc_r32.6.1_aarch64.tbz2
```

I *wished* that there was a way (or an *easy* way) to pull down all the docs locally.  I spend a bit of time with no connectivity and it would be nice to have the docs available
#wget -r https://developer.nvidia.com/embedded/learn/jetson-nano-2gb-devkit-user-guide

```
BOARD=jetson-nano-devkit
L4T_RELEASE_PACKAGE=$(find * -type f -name "jetson-210_linux_r*tbz2")
SAMPLE_FS_PACKAGE=$(find * -type f -name "tegra_linux_sample-root-filesystem_r*tbz2")
echo "BOARD: $BOARD"
echo "L4T_RELEASE_PACKAGE: $L4T_RELEASE_PACKAGE"
echo "SAMPLE_FS_PACKAGE: $SAMPLE_FS_PACKAGE"
```

```
tar -xvf ${L4T_RELEASE_PACKAGE}
```

## flash the Nano 
```
cd ~/Downloads/Nvidia_Jetson/Linux_for_Tegra
sudo ./flash.sh p3448-0000-max-spi external
```

## Install Fedora (ARM) on an SD card
I copy all of my Raw Images to ~/Downloads/Images  
Run this command and then plug in your SD card (should see something like (sda or sdb, etc..)
```
dmesg --follow
```

```
sudo arm-image-installer --media=/dev/sda --resizefs --target=none --image=/home/jradtke/Downloads/Images/Fedora-Workstation-35-1.2.aarch64.raw.xz
```
