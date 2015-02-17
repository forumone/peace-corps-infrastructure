#/bin/bash -x

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

sudo apt-get update
sudo apt-get upgrade -y

# Basic package installation
sudo apt-get install fail2ban -y
sudo apt-get install git -y
sudo apt-get install build-essential -y
sudo apt-get install python-pip -y

sudo pip install boto
sudo pip install awscli