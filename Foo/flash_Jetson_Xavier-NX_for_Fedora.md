# Install Microshift on Nvidia Jetson Xavier NX using Fedora

## Purpose

## Requirements

* Nvidia Jetson Xavier NX system 
* Ubuntu Laptop running 18.04 LTS (I'll explain this more in a different post)
* USB-A to USB-micro-B cable

## Prerequisites and Setup
```
sudo apt update
sudo apt upgrade
sudo apt install minicom
ln -s /usr/bin/python3 /usr/bin/python
```

```
mkdir -p ~/Downloads/Nvidia_Jetson/Xavier_NX; cd $_
```
### Download Linux for Tegra (L4T) R32.6.1 release:
```
wget "https://developer.nvidia.com/embedded/l4t/r32_release_v6.1/t186/jetson_linux_r32.6.1_aarch64.tbz2"
```

### Download UEFI firmware (1.1.2 ATM) (Readme):
```
wget "https://developer.nvidia.com/assets/embedded/downloads/nvidia_uefiacpi_experimental_firmware/nvidia-l4t-jetson-uefi-r32.6.1-20211119125725.tbz2"
```

### Download Sample Root Filesystem (probably no value in this though)
```
wget https://developer.nvidia.com/embedded/l4t/r32_release_v6.1/t186/tegra_linux_sample-root-filesystem_r32.6.1_aarch64.tbz2
````

### Uncompress both tarballs
NOTE:  Please notice the different tar options being passed in  
Also, I believe I will be updating this to create specific directories based on use or intent.  i.e. this UEFI creation should/will not be used for a non-UEFI deployment and therefore I'll need a non-modified source for L4T
``
tar xvjf jetson_linux_r32.6.1_aarch64.tbz2  
tar xvpf nvidia-l4t-jetson-uefi-r32.6.1-20211119125725.tbz2
mv Linux_for_Tegra/ Linux_for_Tegra-UEFI/
```

### Summary
You have pulled down the R32.6.1 standard L4T (Linux for Tegra) bits and then applied the UEFI bits over the directory from the tarball.  I then rename the Linux_for_Tegra directory to indicate that it is non-standard.

## Create the rootfs (Fedora and UEFI)

Status: Work In Progress
I download my Raw Image to ~/Downloads/Images/ 
```
IMG_DIR=~jradtke/Downloads/Images/
BASE_NAME=Fedora-Server-35-1.2.aarch64
IMG_NAME=${BASE_NAME}.raw

mkdir /mnt/${BASE_NAME}-{1,2,3}
xz -d ${IMG_DIR}/${IMG_NAME}.xz

fdisk -l   ${IMG_DIR}/${IMG_NAME}

alternate_disk_method() {
# TODO: Provide Foo for figuring out offsets for 

# I believe this partition is actually /boot/efi
mount -o loop,offset=1048576   ${IMG_DIR}/${IMG_NAME}  /mnt/${BASE_NAME}-1
rsync -tugrpolvv /mnt/1/ /home/jradtke/Downloads/Nvidia_Jetson/rootfs-Fedora-Server-35/boot/
umount /mnt/1

# I believe this partition is actually /boot
mount -o loop,offset=630194176 ${IMG_DIR}/${IMG_NAME}  /mnt/${BASE_NAME}-2 
rsync -tugrpolvv /mnt/2/ /home/jradtke/Downloads/Nvidia_Jetson/rootfs-Fedora-Server-35/boot/EFI/
umount /mnt/2
}

# You need to open a terminal to see what loopback device is instantiated 
# You will see the following output after running the next commands
dmesg --follow
# [105533.419629] XFS (loop7): Mounting V5 Filesystem

# Or.. you can run
ls -lart /dev/loop*

losetup -f -P ${IMG_DIR}/${IMG_NAME}           
DALOOP=$(losetup | grep ${IMG_NAME} | awk '{ print $1 }')
lsblk | grep $DALOOP 
mount ${DALOOP}p1 /mnt/${BASE_NAME}-1  # EFI  (probably /boot/efi)
mount ${DALOOP}p2 /mnt/${BASE_NAME}-2  # ext4 (probably /boot
file -sL  ${DALOOP}p1
file -sL  ${DALOOP}p2

pvscan --cache
vgchange -ay
mount /dev/mapper/fedora_fedora-root /mnt/${BASE_NAME}-3 # 

rsync -tugrpolvv /mnt/${BASE_NAME}-2/  /home/jradtke/Downloads/Nvidia_Jetson/Linux_for_Tegra-UEFI/rootfs/boot/
rsync -tugrpolvv /mnt/${BASE_NAME}-1/  /home/jradtke/Downloads/Nvidia_Jetson/Linux_for_Tegra-UEFI/rootfs/boot/efi
rsync -tugrpolvv  /mnt/${BASE_NAME}-3/ /home/jradtke/Downloads/Nvidia_Jetson/Linux_for_Tegra-UEFI/rootfs/

umount /mnt/${BASE_NAME}-{1,2,3}
vgchange -an fedora_fedora 

#rsync -tugrpolvv /home/jradtke/Downloads/Nvidia_Jetson/rootfs-Fedora-Server-35/ /home/jradtke/Downloads/Nvidia_Jetson/Linux_for_Tegra-UEFI/rootfs/
```

## Flash the Nvidia Xavier NX
* Place Xavier NX module in Force Reset Mode and power it on
** For my specific system (Seeed Studio carrier board and NX Developer Kit module), I will place a jumper on pins 9 and 10 (see photo)
* Connect the USB cable between your laptop and the micro-USB socket on the carrier board

### NOTE
I run this as root (for now, anyhow)

You should see the device and will see "7e19" which indicates you are in FRC
```
# lsusb | grep -i nvidia
Bus 001 Device 006: ID 0955:7e19 Nvidia Corp.
```

```
# cd ~jradtke/Downloads/Nvidia_Jetson/Xavier_NX/Linux_for_Tegra
# sudo ./flash.sh jetson-xavier-nx-uefi-acpi internal
*** The target t186ref has been flashed successfully. ***
Reset the board to boot from internal eMMC.
# watch "lsusb | grep -i nvi"

```
## Serial Output
I picked up a

Connect the USB Serial cable to the following pins on J50 (The same connector as the Force Recovery)
| Pin | Purpose | Cable Color 
|:--:|:-----|:-----|
| 3 | Receive | Green |
| 4 | Transmit | White |
| 8 | Ground | Black |

UART RXD (Pin 3) - Receive (Green Wire (TX) -> RXD)
UART TXD (Pin 4) - Transmit (White Wire (RX) -> TXD)
GND (Pin 7) - Ground (Black Wire (GND) -> GND)

## References
[NVIDIA Jetson UEFI/ACPI Experimental Firmware Version 1.1.0](https://developer.download.nvidia.com/embedded/L4T/UEFI_Readme_side_car.html)
