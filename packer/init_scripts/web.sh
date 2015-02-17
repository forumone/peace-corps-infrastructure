#/bin/bash -x

# Create a user for deployments
sudo useradd -m peacecorps

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
sudo cp /home/ubuntu/files/web/nginx_site_conf /etc/nginx/sites-enabled/peacecorps

# Ensure appropriate directories exist
sudo mkdir -p /var/www/static
sudo chown -R peacecorps:peacecorps /var/www/static
#### END NGINX ####

####
#### REQUIRED WEBSERVER PACKAGES ####
####
sudo apt-get install openssl -y
sudo apt-get install libssl-dev -y
sudo apt-get install python-dev -y
sudo apt-get install libevent-dev -y
sudo apt-get install libpq-dev -y
sudo apt-get install python-virtualenv -y
sudo apt-get install postgresql-client-common -y
sudo apt-get install postgresql-client -y
sudo apt-get install libmemcached-dev -y
sudo apt-get install libbz2-dev -y
sudo apt-get install libsqlite3-dev -y
sudo apt-get install libreadline-dev -y
sudo apt-get install libjpeg-dev -y
sudo apt-get install zlib1g-dev -y
sudo apt-get install libtiff5-dev -y
sudo apt-get install sendmail -y
#### END WEBSERVER PACKAGES ####

####
#### WEBAPP LOGGING ####
####
sudo mkdir -p /var/log/gunicorn
sudo chown -R peacecorps:peacecorps /var/log/gunicorn

sudo touch /var/log/webapp.log
sudo chown peacecorps:peacecorps /var/log/webapp.log
#### END WEBAPP LOGGING ####

####
#### GPG ####
####
sudo mkdir -p /gpg
sudo chown -R peacecorps:peacecorps /gpg
#### END GPG LOGGING ####

####
#### MANAGEMENT SCRIPTS ####
####
# We place a very important file which allows to easily init into the virtual environment
sudo cp /home/ubuntu/files/web/webapp_vars.sh /home/peacecorps/webapp_vars.sh
sudo chown peacecorps:peacecorps /home/peacecorps/webapp_vars.sh

# We place the django management script
sudo cp /home/ubuntu/files/web/manage.sh /home/peacecorps/manage.sh
sudo chmod 700 /home/peacecorps/manage.sh
sudo chown peacecorps:peacecorps /home/peacecorps/manage.sh

# Upstart Configuration
sudo cp /home/ubuntu/files/web/upstart_peacecorps.conf /etc/init/peacecorps.conf
#### END MANAGEMENT SCRIPTS ####

####
#### PYENV INIT ####
####
sudo cp /home/ubuntu/files/web/.pyenvrc /home/peacecorps/.pyenvrc
sudo chown peacecorps:peacecorps /home/peacecorps/.pyenvrc
sudo su peacecorps <<'EOF'
git clone https://github.com/yyuu/pyenv.git /home/peacecorps/pyenv
git clone https://github.com/yyuu/pyenv-virtualenv.git /home/peacecorps/pyenv/plugins/pyenv-virtualenv
cp /home/peacecorps/.pyenvrc /home/peacecorps/pyenv/.pyenvrc
chmod 644 /home/peacecorps/pyenv/.pyenvrc
echo "source /home/peacecorps/pyenv/.pyenvrc" >> /home/peacecorps/.bashrc

# Install Python
source /home/peacecorps/pyenv/.pyenvrc
pyenv install 3.4.1

# Create virtual environment
pyenv virtualenv 3.4.1 peacecorps

pyenv activate peacecorps

git clone https://github.com/18F/peacecorps-site.git /home/peacecorps/peacecorps

cd /home/peacecorps/peacecorps
git fetch --tags
git checkout base

pip install -r requirements.txt
pip install gunicorn
EOF
