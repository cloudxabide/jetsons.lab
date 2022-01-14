# jetsons.lab
NVidia Jetson Lab Environment - exploring Microshift (or k3s/k8s) on ARM

## Goal
To deploy a Microshift cluster on 4 x NVIDIA Jetson Nano.  
I am creating this repo in an opinionated way, demonstrating what *I* was trying to accomplish.  Substitutions are likely possible, and probably would not require modifications of my approach.

NOTE:  I am LITERALLY starting at ZERO here (Spring 2021).  I have a project at work focusing on something similar, and I wanted to get some rudimentary exposure to k3s and this seemed like the best and most fun way to achieve that goal.  Side benefit, I'll have some really cool hardware to play with AI later.

## Get after it...
There's little (no) point in my explaining how to make your Jetson bootable, as it's all right at the following:  
https://developer.nvidia.com/embedded/learn/get-started-jetson-nano-devkit#intro

NOTE:  Some NVIDIA Jetson Nano have an issue with the Mac Address appearing as "00:00:00:00:00:01".  
Review 
[Firmware Update Overview](Foo/Firmware_Update-NVIDIA_Jetson_Nano.md)

![Cluster View - Front](images/da_cluster_front.png)
![Cluster View - Rear](images/da_cluster_rear.png)

