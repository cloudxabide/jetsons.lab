# Install K3s


```
sudo apt -y update && sudo apt -y upgrade
sudo apt -y install curl
sleep $(( ( RANDOM % 10 )  + 1 )); sudo shutdown now -r
```

```
sudo -i
curl -sfL https://get.k3s.io | sh -
```

```
cat << EOF > /etc/rancher/k3s/config.yaml
node-ip: `ip addr show dev eth0 | grep inet | awk '{ print $2 }' | sed 's/\/24//g'`
server: https://10.10.10.51:6443
token: 1234gityourbootieonthefloor 
EOF
```

## References
https://k3s.io/

https://www.suse.com/c/running-edge-artificial-intelligence-k3s-cluster-with-nvidia-jetson-nano-boards-src/
https://github.com/xiftai/jetson_nano_k3s_cluster_gpu/
