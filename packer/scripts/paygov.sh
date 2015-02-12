#/bin/bash -x

# Set some variables we'll use throughout this
domain=$(cat /home/ubuntu/domain)
environment=$(cat /home/ubuntu/pc_environment)

#
### nginx Configuration ###
#

# Download the secring
aws s3 cp s3://peacecorps-secrets/${environment}/secring.gpg.enc /tmp/secring.gpg.enc
sudo openssl aes-256-cbc -d -a -salt -pass file:/home/ubuntu/decryption_key.txt -in /tmp/secring.gpg.enc -out /gpg/secring.gpg
sudo chown peacecorps:peacecorps /gpg/secring.gpg

# Install a cronjob
echo -e "53 * * * * peacecorps bash /home/peacecorps/manage.sh clear_stale_donors" | sudo tee /etc/cron.d/clean_stale_donors

# We place a very important file which allows to easily init into the paygov virtual environment
sudo cp /tmp/files/pay/pay-init.sh /home/peacecorps/pay-init.sh
sudo chown peacecorps:peacecorps /home/peacecorps/pay-init.sh