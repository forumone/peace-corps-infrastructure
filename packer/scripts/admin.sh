#/bin/bash -x

# Set some variables we'll use throughout this
domain=$(cat /home/ubuntu/domain)
environment=$(cat /home/ubuntu/pc_environment)


# We place a very important file which allows to easily init into the paygov virtual environment
sudo cp /tmp/files/pay/pay-init.sh /home/peacecorps/pay-init.sh
sudo chown peacecorps:peacecorps /home/peacecorps/pay-init.sh