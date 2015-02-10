#/bin/bash

# Set some simple global environmental variables
export DEPLOY_USER=peacecorps

# Say what environment we are in!
if [ -f ~/environment_staging ];
then
   export PC_ENVIORNMENT=staging
fi

if [ -f ~/environment_production ];
then
   export PC_ENVIORNMENT=production
fi

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

# Create a user for deployments
sudo useradd -m $DEPLOY_USER