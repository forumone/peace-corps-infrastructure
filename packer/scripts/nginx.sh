#/bin/bash -x

# Install and start up nginx as a service
sudo apt-add-repository ppa:nginx/stable -y
sudo apt-get update -y
sudo apt-get install nginx -y
echo "Nginx Installed"

sudo service nginx start
sudo update-rc.d nginx defaults
echo "Nginx Service Started"

# Place the nginx configuration
sudo cp /tmp/files/web/nginx.conf /etc/nginx/nginx.conf

# Create the SSL Keys Directory, download SSL rules
sudo mkdir -p /etc/nginx/ssl/keys

sudo curl -o /etc/nginx/ssl/ssl.rules https://raw.githubusercontent.com/18F/tls-standards/master/configuration/nginx/ssl.rules

sudo curl -o /etc/nginx/ssl/dhparam3072.pem https://raw.githubusercontent.com/18F/tls-standards/master/configuration/nginx/dhparam3072.pem

sudo curl -o /etc/nginx/ssl/dhparam4096.pem https://raw.githubusercontent.com/18F/tls-standards/master/configuration/nginx/dhparam4096.pem

sudo curl -o /etc/nginx/ssl/dhparam2048.pem https://raw.githubusercontent.com/18F/tls-standards/master/configuration/nginx/dhparam2048.pem
echo "SSL Rules & DH Params Installed"