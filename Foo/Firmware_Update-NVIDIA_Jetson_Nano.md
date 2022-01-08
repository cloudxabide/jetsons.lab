# Firmware Update-NVIDIA Jetson Nano

## Purpose
I had an issue with the mac address reporting as all 0's (zero's)

Download https://developer.nvidia.com/embedded/dlc/jetson-nano-developer-kit-ethernet-firmware-2598410

```
cyberpunk:~ jradtke$ scp ~/Downloads/nano_update_2598410.tbz2 10.10.10.232:
jradtke@10.10.10.232's password:
nano_update_2598410.tbz2                      100%  416KB  42.0MB/s   00:00
```

```
cyberpunk:~ jradtke$ ssh 10.10.10.232

jradtke@judy:~$ sudo su -
[sudo] password for jradtke:

root@judy:~# cd ~jradtke/
root@judy:/home/jradtke# bzip2 -d nano_update_2598410.tbz2 | tar -xvf -
root@judy:/home/jradtke# cd nano_update_2598410/

root@judy:/home/jradtke/nano_update_2598410# ./nano_update_2598410

 This is RTL8168H
 Use EFuse
 Patch OK!!!
```


IMPORTANT!!!  You have to "cold boot" the Nano at this point (simple reboot won't cut it).  So, remove power and let it boot
```
root@judy:/home/jradtke/nano_update_2598410# shutdown now -h
```
Remove and restore power connection.

## References
https://forums.developer.nvidia.com/t/mac-000000-01/156587/20
