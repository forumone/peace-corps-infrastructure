#/bin/bash

# Set some variables we'll use throughout this
domain=$(cat /home/ubuntu/domain)
environment=$(cat /home/ubuntu/pc_environment)

# Additional packages that need to be installed on webservers
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

#
### nginx Configuration ###
#

# Werite the nginx config for the site
sudo cp /tmp/files/web/nginx_site_conf /etc/nginx/sites-enabled/peacecorps
sudo sed -i "s@{{domain}}@$domain@" /etc/nginx/sites-enabled/peacecorps

# Download the appropriate SSL key
aws s3 cp s3://peacecorps-secrets/${environment}/${domain}.key.enc /home/ubuntu/${domain}.key.enc
sudo openssl aes-256-cbc -d -a -salt -pass file:/home/ubuntu/decryption_key.txt -in /home/ubuntu/${domain}.key.enc -out /etc/nginx/ssl/keys/${domain}.key

# Download the appropriate SSL chain certificate
aws s3 cp s3://peacecorps-secrets/${environment}/${domain}.chained.crt.enc /home/ubuntu/${domain}.chained.crt.enc
sudo openssl aes-256-cbc -d -a -salt -pass file:/home/ubuntu/decryption_key.txt -in /home/ubuntu/${domain}.chained.crt.enc -out /etc/nginx/ssl/keys/${domain}.chained.crt

# Ensure the appropriate static directories exist
sudo mkdir -p /var/www/static
sudo chown -R peacecorps:peacecorps /var/www/static

sudo mkdir -p /var/log/gunicorn
sudo chown -R peacecorps:peacecorps /var/log/gunicorn

sudo touch /var/log/webapp.log
sudo chown peacecorps:peacecorps /var/log/webapp.log

sudo mkdir -p /gpg
sudo chown -R peacecorps:peacecorps /gpg

aws s3 cp s3://peacecorps-secrets/${environment}/pubring.gpg.enc /tmp/pubring.gpg.enc
sudo openssl aes-256-cbc -d -a -salt -pass file:/home/ubuntu/decryption_key.txt -in /tmp/pubring.gpg.enc -out /gpg/pubring.gpg
sudo chown peacecorps:peacecorps /gpg/pubring.gpg

aws s3 cp s3://peacecorps-secrets/${environment}/trustdb.gpg.enc /tmp/trustdb.gpg.enc
sudo openssl aes-256-cbc -d -a -salt -pass file:/home/ubuntu/decryption_key.txt -in /tmp/trustdb.gpg.enc -out /gpg/trustdb.gpg
sudo chown peacecorps:peacecorps /gpg/trustdb.gpg

sudo service nginx restart

#
### Management Scripts Configuration ###
#

# We place a very important file which allows to easily init into the virtual environment
sudo cp /tmp/files/web/webserver-init.sh /home/peacecorps/webserver-init.sh
sudo chown peacecorps:peacecorps /home/peacecorps/webserver-init.sh

# We place the django management script
sudo cp /tmp/files/web/manage.sh /home/peacecorps/manage.sh
sudo chmod 700 /home/peacecorps/manage.sh
sudo chown peacecorps:peacecorps /home/peacecorps/webserver-init.sh

#
### Upstart Configuration ###
#
sudo cp /tmp/files/web/upstart_peacecorps.conf /etc/init/peacecorps.conf

# Now we change users to install pyenv
su peacecorps
git clone https://github.com/yyuu/pyenv.git /home/peacecorps/pyenv
git clone https://github.com/yyuu/pyenv-virtualenv.git /home/peacecorps/pyenv/plugins/pyenv-virtualenv
cp /tmp/files/web/.pyenvrc /home/peacecorps/pyenv/.pyenvrc
chmod 644 /home/peacecorps/pyenv/.pyenvrc
echo "source /home/peacecorps/pyenv/.pyenvrc" >> /home/peacecorps/.bashrc

# Install Python
. /home/peacecorps/pyenv/.pyenvrc && pyenv install 3.4.1

# Create virtual environment
. /home/peacecorps/pyenv/.pyenvrc && pyenv virtualenv 3.4.1 peacecorps

if [ ! -d /home/peacecorps/peacecorps ]; then
   git clone https://github.com/18F/peacecorps-site.git /home/peacecorps/peacecorps
else
    cd /home/peacecorps/peacecorps && git pull origin master
fi

cd /home/peacecorps/peacecorps
pip install -r requirements.txt
pip install gunicorn