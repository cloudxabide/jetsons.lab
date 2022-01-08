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
