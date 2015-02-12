#/bin/bash -x

# Ensure ipv4 forwarding is enabled
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sudo sysctl -p

sudo iptables -t nat -A POSTROUTING -o eth0 -s 10.19.61.0/24 -j MASQUERADE
sudo sed -i '/exit 0/i iptables -t nat -A POSTROUTING -o eth0 -s 10.19.61.0/24 -j MASQUERADE' /etc/rc.local