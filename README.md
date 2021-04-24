# jetsons.lab
NVidia Jetson Lab Environment - exploring k3s on ARM

## Goal
To deploy a k3s cluster on 4 x NVIDIA Jetson Nano.
I am creating this repo in an opinionated way, demonstrating what *I* was trying to accomplish.  Substitutions are
 likely possible, and probably would not require modifications of my approach.

NOTE:  I am LITERALLY starting at ZERO here (Spring 2021).  I have a project at work focusing on something similar, and I wanted to get some rudimentary exposure to k3s and this seemed like the best and most fun way to achieve t
hat goal.  Side benefit, I'll have some really cool hardware to play with AI later.


## Requirements
Internet Access
PC/Mac with SD card reader

Keyboard/Mouse/Monitor
- NVIDIA Jetson Nano has HDMI and DisplayPort (which blows my mind)
- Keyboard/Mouse are USB
Network Switch (> 5-port)
Network Cables (5+)
PowerStrip (enough capacity for your USB Power Supplies)

NVIDIA Jetson Nano Developer Kit (4GB)
- microSD card (32GB)
- 5v power supply with microUSB cable
- fan cooler (optional)

## Get after it...
There's little (no) point in my explaining how to make your Jetson bootable, as it's all right at the following:  
https://developer.nvidia.com/embedded/learn/get-started-jetson-nano-devkit#intro

Good luck.  I'll revisit this if I decide to run Fedora, etc...  

NOTE:  The Nano has an issue with the Mac Address


## References

### Gear Links
https://www.amazon.com/gp/product/B01BBZJ31Y/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1[Quick Charge 3.0, AUKEY USB Wall Charger (Quick Charge 2.0 Compatible), Fast Charger ]
