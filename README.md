# jetsons.lab
NVidia Jetson Lab Environment - exploring k3s or k8s on ARM

## Goal
To deploy a k3s/k8s cluster on 4 x NVIDIA Jetson Nano.
I am creating this repo in an opinionated way, demonstrating what *I* was trying to accomplish.  Substitutions are
 likely possible, and probably would not require modifications of my approach.

NOTE:  I am LITERALLY starting at ZERO here (Spring 2021).  I have a project at work focusing on something similar, 
    and I wanted to get some rudimentary exposure to k3s and this seemed like the best and most fun way to achieve 
    that goal.  Side benefit, I'll have some really cool hardware to play with AI later.

## Requirements
Internet Access
PC/Mac with SD card reader

* Keyboard/Mouse/Monitor
  * NVIDIA Jetson Nano has HDMI and DisplayPort (which blows my mind)
  * Keyboard/Mouse are USB  
* Network Switch (> 5-port)  
* Network Cables (5+)  
* PowerStrip (enough capacity for your USB Power Supplies)  

* NVIDIA Jetson Nano Developer Kit (4GB)
Which also requires
  * microSD card (32GB)
  * 5v power supply with microUSB cable
  * fan cooler (optional)

This is what I consider "essential" and the prices I paid (Spring 2021).  I won't provide links to (all) the retailers as the URLs are literally several lines long.  
I am considering whether the "barrel adapter power supply" is a better option - but, for now, make sure you can provide at *least* 10w per cable.

| Item                              | Qty | Price  | Link | Part Number |
|:---------------------------------:|:---:|:------:|:-----|:------------|
| NVIDIA Jetson Nano SDK            | 4   | 108    |
| SD Card (micro) UHS-1 32GB        | 4   | 9.98   | 
| Netgear 8-port 1GB Network Switch | 1   | 39.99  |
| Cat 5e Network Cables - 3ft       | 5   | 9.99   |
| USB 5v Adapter                    | 2   | 17.99  | 
| USB micro-USB cables - 3ft (4pk)  | 1   | 12.99  |
|                          total    | -   | 610.83 |

| Item                              | Qty | Price  | Link | Part Number |
|:---------------------------------:|:---:|:------:|:-----|:------|
| Nano Rack                         |  1  | $69    | [GeekPi Case w/Fans](https://www.amazon.com/gp/product/B085XSPV7G/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&psc=1) | ZP-0089 |
|                           total   | -   | 69     | | |

## Get after it...
There's little (no) point in my explaining how to make your Jetson bootable, as it's all right at the following:  
https://developer.nvidia.com/embedded/learn/get-started-jetson-nano-devkit#intro

Good luck.  I'll revisit this if I decide to run Fedora, etc...  

NOTE:  Some NVIDIA Jetson Nano have an issue with the Mac Address appearing as "00:00:00:00:00:01".  
Review 
[Firmware Update Overview](Foo/Firmware_Update-NVIDIA_Jetson_Nano.md)

## Optics
This setup is fairly visually appealing, I think  
```
| -------------- |
|     George     |
| -------------- |
|      Jane      |
| -------------- |
|      Elroy     |
| -------------- |
|      Judy      |
| -------------- |
```

![Cluster View - Front](images/da_cluster_front.png)
![Cluster View - Rear](images/da_cluster_rear.png)

## References
[NVIDIA Overview](https://developer.nvidia.com/embedded/learn/get-started-jetson-nano-devkit) | 945-13450-0000-100  
[NVIDIA Dev Kit User Guide](https://developer.download.nvidia.com/assets/embedded/secure/jetson/Nano/docs/NV_Jetson_Nano_Developer_Kit_User_Guide.pdf?lEs1ihOZtCmxEbzRWEIdyueQP9ibiiW4nbX2zubJQdvC2RBPCL8yOTgOKG3jLccgRAAGuPw9zLx0KBdnpxwTLehUA447uIva0N3rylAS4Qe8-2lpgVoyDkw5xOuJMzjIq4HbGSx9PMNgFaFiMpotkHg0EujX4V9Kqn-HQSGBguf_TKtsgn58FdOoP2w_GQpAPZU)  

### Gear Links
#### USB Power
[Quick Charge 3.0, AUKEY USB Wall Charger (Quick Charge 2.0 Compatible), Fast Charger ](https://www.amazon.com/gp/product/B01BBZJ31Y/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1)   
[Anker 24w](https://www.amazon.com/Anker-PowerPort-Ultra-Compact-Technology-Foldable/dp/B071GJ6X7B/ref=sr_1_8?dchild=1&keywords=aukey+wall+charger&qid=1620737931&sr=8-8)  
#### Barrel Power
[Adafruit 5v 4a Power Supply - 5.5 OD / 2.1 ID barrel](https://www.adafruit.com/product/1466) - got mine from Amazon  
#### Rack
[RaspberryPi Rack - GeekPi](https://www.seeedstudio.com/Rack-Tower-Pro-p-4676.html)  
[RaspberryPi Rack Documenation - GeekPi](https://wiki.52pi.com/index.php/Rack_Tower_Pro_SKU:_ZP-0089)  
#### SD Card
[Samsung 32GB EVO UHS-I microSDH](https://www.bhphotovideo.com/c/product/1334896-REG/samsung_mb_mp32ga_am_evo_32gb_micro_sd.html/) | MB-MP32GA/AM  
#### Network Switch
[Netgear GS108](https://www.netgear.com/business/wired/switches/unmanaged/gs108/) | GS108-400NAS 
