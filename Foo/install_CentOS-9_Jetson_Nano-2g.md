# install CentOS-9 Jetson Nano-2g.md

## Goal/Purpose
*hopefully* this doc will detail how to install CentOS 9 Stream on to an Nvidia Jetson Nano 2g.

-- Disclaimer:  I work at Red Hat.  That said, I am *not* an engineer, or part of a business unit that does engineering/development - but.. I *do* have access to those folks.  My point?  I probably will not figure this out on my own and I have some advantages while figuring this out that other folks may not have.

I intend to install CentOS 8 Stream on my laptop (I would like to use a few 3rd-party repos for things, which do not have CentOS 9 yet).  I will then 

## What you need (physical)
* laptop  
* SD Card
* SD Card reader
* cable between laptop and Jetson Nano (USB-A to microUSB, in my case)
* Power supply for Nano 

## What you need (software)
* [CentOS 9 Stream](https://centos.org/)
* [CentOS 8 Stream](https://centos.org/) - for my laptop

## The steps
```
dd if=CentOS-Stream-8-latest-x86_64-dvd1.iso of=/dev/sda bs=4m status=progress
```
 
## References
https://nullr0ute.com/2020/11/installing-fedora-on-the-nvidia-jetson-nano/  
[Nvidia Linux for Tegra](https://developer.nvidia.com/embedded/linux-tegra) L4T  

