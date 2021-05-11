#!/bin/bash


pre() {
sudo -i

}

[ `id -u` -ne 0 ] && { echo "ERROR: you should run this as root yo"; exit 9; }

# "Fix" sudo
cat << EOF >> /etc/sudoers

# Allow members of group wheel to execute any command 
%wheel ALL=(ALL:ALL) NOPASSWD: ALL
EOF

# Setup the "mansible" user
addgroup --system wheel
id -u mansible &>/dev/null || useradd -Gwheel -u1001 -c "My Ansible" -d /home/mansible -s /bin/bash -p '$6$MIxbq9WNh2oCmaqT$10PxCiJVStBELFM.AKTV3RqRUmqGryrpIStH5wl6YNpAtaQw.Nc/lkk0FT9RdnKlEJEuB81af6GWoBnPFKqIh.' mansible
su - mansible -c "echo | ssh-keygen -trsa -b2048 -N ''"
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCvG26KjNmcBJ8LSgAL6cpJTj2k3dlTwvbByUGcv5pVn3SJTQpOCOFDU1BOcXWUqiBmuYiDcn6ekdVB9rPR5VduBuGmxWbOUk17IF4zeFZ1DZdaqFWA5XhPTIqBWG/hiXfaScbhMOrjIC0v+S0tZAF2ekpKyKOv0lUtG+qxuC7WL9TyHC5ye1RvZf2jPtzCQn/iDskNzPrL7ajczniVa2xWf9LXUOTEpGG3W/GxVBM8D+2k62u11fPULnpijp7ylOIryqbdcYSP8TARj1tU5fod/uwfSiG2sPqrIvXVwRJ8bJJwTyL3qPfFkznwcAHqxC7IQ2dfgcPK4jTX9usqhcXJ mansible@rh8-util-srv02.matrix.lab" > /home/mansible/.ssh/authorized_keys && chmod 0600 /home/mansible/.ssh/authorized_keys && chown mansible:mansible /home/mansible/.ssh/*


# I guess systemd was the gateway drug to all kinds of nonsense.  I am sure there is a
#  reason for this change, but holy crap this is annoying.  Seriously.
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

# Update the systems and reboot
sudo sudo apt-get -y update && sudo apt-get -y upgrade && sudo apt -y autoremove
# Staggered reboot - can't have ALL the systems drawing power at the same time
sleep $(( ( RANDOM % 10 )  + 1 )); sudo shutdown now -r 
