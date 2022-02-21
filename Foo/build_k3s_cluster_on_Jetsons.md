# Build k3s cluster on NVIDIA Jetsons

## Goal 
I would like to run some sort of container environment on my Jetson Nano devices.  Currently NVIDIA seems to have an affinity towards Ubuntu, which is a bummer for me as I don't really know Ubuntu all that well.  So, all of this will be done using the "stock bits" until I figure out how to get Fedora/RHEL/CentOS deployed on the device with GPU support.

## Overview

1 x NVIDIA Jetson Xavier NX (SeeedStudio Carrier Board) and barrel type power  
2 x NVIDIA Jetson Nano and barrel type power  
1 x "computer" running Ubuntu 18.04 (currnetly using my old Mac Mini)  
1 x [ADAfruit USB to TTL Serial Cable](https://www.adafruit.com/product/954) Product ID: 954  
1 x USB-A to micro-USB cable  

## Steps

* Flash Xavier using sdkmanager to NVMe device  
* Boot device and accept the prompts and create a user (nvidia/nvidia)  
* (I use DHCP with static assignments)  
* [ansible host] 
  * Clone repo and cd to repo directory
  * run the playbook Ansible/Playbooks/01-jetsons-initial-OS-setup.yaml


Clone repo and run first playbook (update Jetson and add swap device) - device will reboot
```
git clone https://github.com/cloudxabide/jetsons.lab.git
cd jetsons.lab/Ansible
ansible-playbook --limit xavier.jetsons.lab -i Inventory/hosts-jetsons.lab  Playbooks/01-jetsons-initial-OS-setup.yaml  -K 
```


