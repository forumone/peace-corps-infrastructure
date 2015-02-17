#/bin/bash -x

sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sudo sysctl -p
sudo iptables -t nat -A POSTROUTING -o eth0 -s 10.19.61.0/24 -j MASQUERADE
sudo sed -i '/exit 0/i iptables -t nat -A POSTROUTING -o eth0 -s 10.19.61.0/24 -j MASQUERADE' /etc/rc.local

####
#### NGINX INSTALLATION ####
####
sudo apt-add-repository ppa:nginx/stable -y
sudo apt-get update -y
sudo apt-get install nginx -y

sudo service nginx start
sudo update-rc.d nginx defaults

# Place the nginx configuration
sudo cp /home/ubuntu/files/web/nginx.conf /etc/nginx/nginx.conf

# Create the SSL Keys Directory, download SSL rules
sudo mkdir -p /etc/nginx/ssl/keys

sudo curl -o /etc/nginx/ssl/ssl.rules https://raw.githubusercontent.com/18F/tls-standards/master/configuration/nginx/ssl.rules

sudo curl -o /etc/nginx/ssl/dhparam3072.pem https://raw.githubusercontent.com/18F/tls-standards/master/configuration/nginx/dhparam3072.pem

sudo curl -o /etc/nginx/ssl/dhparam4096.pem https://raw.githubusercontent.com/18F/tls-standards/master/configuration/nginx/dhparam4096.pem

sudo curl -o /etc/nginx/ssl/dhparam2048.pem https://raw.githubusercontent.com/18F/tls-standards/master/configuration/nginx/dhparam2048.pem

# Place the site configuration
sudo cp /home/ubuntu/files/nat/nginx_site_conf /etc/nginx/sites-enabled/peacecorps