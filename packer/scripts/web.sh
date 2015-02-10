#/bin/bash

# Set some variables we'll use throughout this
$domain = `cat /tmp/domain`

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

# Werite the nginx config for the site
sudo cp /tmp/files/web/nginx /etc/nginx/sites-enabled/peacecorps
sudo sed -i 's/{{domain}}/${domain}/g' /etc/nginx/sites-enabled/peacecorps

# Download the appropriate SSL key
aws s3 cp s3://peacecorps-secrets/${cat /tmp/pc_environment}/{$domain}.key.enc /tmp/${domain}.key.enc
openssl aes-256-cbc -d -a -salt -pass file:~/decryption_key -in /tmp/${domain}.key.enc -out /etc/nginx/ssl/keys/${domain}.key

# Download the appropriate SSL chain certificate
aws s3 cp s3://peacecorps-secrets/${cat /tmp/pc_environment}/{$domain}.chained.crt.enc /tmp/${domain}.chained.crt.enc
openssl aes-256-cbc -d -a -salt -pass file:~/decryption_key -in /tmp/${domain}.chained.crt.enc -out /etc/nginx/ssl/keys/${domain}.chained.crt

sudo service nginx restart