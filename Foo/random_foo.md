# Random Foo

## Purpose
Random tidbits that I need to remember

### Control Fan Speed
```
echo 128 > /sys/devices/pwm-fan/target_pwm             
```

### Configure WLAN
```
SSID=example
PASS=mypass
nmcli d wifi connect $SSID password $PASS
```

### MAC Address issue
NOTE:  Some NVIDIA Jetson Nano have an issue with the Mac Address appearing as "00:00:00:00:00:01".
Review
[Firmware Update Overview](Foo/Firmware_Update-NVIDIA_Jetson_Nano.md)

## Minicom Settings
115200 8N1  
Software Control: yes  
Hardware Control: no  

