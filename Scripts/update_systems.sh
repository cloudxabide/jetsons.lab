!/bin/bash


pre() {
sudo -i

}

[ `id -u` -ne 0 ] && { echo "ERROR: you should run this as root yo"; exit 9; }

echo "mansible ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/mansible-nopasswd-all

# Setup the "mansible" user
id -u mansible &>/dev/null || useradd -Gsudo -u1001 -c "My Ansible" -d /home/mansible -s /bin/bash -p '$6$MIxbq9WNh2oCmaqT$10PxCiJVStBELFM.AKTV3RqRUmqGryrpIStH5wl6YNpAtaQw.Nc/lkk0FT9RdnKlEJEuB81af6GWoBnPFKqIh.' mansible
mkdir ~mansible; chown mansible:mansible ~mansible
su - mansible -c "echo | ssh-keygen -trsa -b2048 -N ''"
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCvG26KjNmcBJ8LSgAL6cpJTj2k3dlTwvbByUGcv5pVn3SJTQpOCOFDU1BOcXWUqiBmuYiDcn6ekdVB9rPR5VduBuGmxWbOUk17IF4zeFZ1DZdaqFWA5XhPTIqBWG/hiXfaScbhMOrjIC0v+S0tZAF2ekpKyKOv0lUtG+qxuC7WL9TyHC5ye1RvZf2jPtzCQn/iDskNzPrL7ajczniVa2xWf9LXUOTEpGG3W/GxVBM8D+2k62u11fPULnpijp7ylOIryqbdcYSP8TARj1tU5fod/uwfSiG2sPqrIvXVwRJ8bJJwTyL3qPfFkznwcAHqxC7IQ2dfgcPK4jTX9usqhcXJ mansible@rh8-util-srv02.matrix.lab" > /home/mansible/.ssh/authorized_keys && chmod 0600 /home/mansible/.ssh/authorized_keys && chown mansible:mansible /home/mansible/.ssh/*

# I guess systemd was the gateway drug to all kinds of nonsense.  I am sure 
# there is a reason for this change, but holy crap this is annoying.  Seriously.
cat << EOF > /etc/systemd/resolved.conf.d/dns_servers.conf
[Resolve]
DNS=10.10.10.121 10.10.10.122
Domains=jetsons.lab matrix.lab
EOF
systemctl restart systemd-resolved

# Boot to non-graphical runlevel
sudo systemctl set-default multi-user.target
# To restart graphical login
# sudo systemctl isolate graphical.target

# Enable "high-power" mode (10w)
sudo nvpmodel -m 0

# Enable SNMP on the nodes
sudo apt update && sudo apt -y install snmpd
mv /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf-`date +%F`
wget https://raw.githubusercontent.com/cloudxabide/matrix.lab/main/Files/etc_snmp_snmpd.conf -O /etc/snmp/snmpd.conf
restorecon -Fvv /etc/snmp/snmpd.conf
# This customization is only for Ubuntu
echo "agentAddress udp:161" >> /etc/snmp/snmpd.conf
systemctl enable snmpd --now

# update hosts file
cat << EOF >> /etc/hosts
# Jetson Lab Hosts
10.10.10.51 elroy.jetsons.lab
10.10.10.52 judy.jetsons.lab
10.10.10.53 jane.jetsons.lab
10.10.10.54 george.jetsons.lab
EOF

# System Tuning 
cat << EOF > /etc/sysctl.d/99-disable_ipv6.conf
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1
EOF

# Disable swap (need to figure out if this is "universal" or dependent on whether I am doing k3s vs k8s, etc..
#sudo swapoff -a

# Add current user to group:docker
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# Make sure the "nvidia" runtime is default
cat << EOF > /etc/docker/daemon.json
{
  “default-runtime”: “nvidia”,
  “runtimes”: {
    “nvidia”: {
      “path”: “nvidia-container-runtime”,
      “runtimeArgs”: []
     }
   }
}
EOF

# Update the systems and reboot
sudo sudo apt-get -y update && sudo apt-get -y upgrade && sudo apt -y autoremove
# Staggered reboot - can't have ALL the systems drawing power at the same time
sleep $(( ( RANDOM % 10 )  + 1 )); sudo shutdown now -r 
