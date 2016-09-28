#/bin/bash -x

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

sleep 10
sudo apt-get update
sudo apt-get update –fix-missing
sudo apt-get upgrade -y

# Basic package installation
sudo apt-get install fail2ban -y
sudo apt-get install git -y
sudo apt-get install build-essential -y
sudo apt-get install python-pip -y

sudo pip install boto
sudo pip install awscli

###
# 18F Defaults
###

###
# /etc/modprobe.d Safe Defaults
# See https://github.com/18F/ubuntu/blob/master/hardening.md
###
sudo curl -o /etc/modprobe.d/18Fhardened.conf https://raw.githubusercontent.com/fisma-ready/ubuntu-lts/master/files/ubuntu/etc/modprobe.d/18Fhardened.conf
sudo chown root:root /etc/modprobe.d/18Fhardened.conf
sudo chmod 0644 /etc/modprobe.d/18Fhardened.conf

###
# Audit Strategy!
# See https://github.com/18F/ubuntu/blob/master/hardening.md#audit-strategy
###

# Time and Space
sudo mkdir -p /etc/audit
sudo curl -o /etc/audit/audit.rules https://raw.githubusercontent.com/fisma-ready/ubuntu-lts/master/files/ubuntu/etc/audit/audit.rules
sudo chown -R root:root /etc/audit
sudo chmod 0640 /etc/audit
sudo chmod 0640 /etc/audit/audit.rules

###
# System Access, Authentication and Authorization
# See https://github.com/18F/ubuntu/blob/master/hardening.md#system-access-authentication-and-authorization
###
sudo chown root:root /etc/crontab
sudo chmod og-rwx /etc/crontab

sudo chown root:root /etc/cron.hourly
sudo chmod og-rwx /etc/cron.hourly

sudo chown root:root /etc/cron.daily
sudo chmod og-rwx /etc/cron.daily

sudo chown root:root /etc/cron.weekly
sudo chmod og-rwx /etc/cron.weekly

sudo chown root:root /etc/cron.monthly
sudo chmod og-rwx /etc/cron.monthly

sudo chown root:root /etc/cron.d
sudo chmod og-rwx /etc/cron.d

sudo rm /etc/at.deny
sudo touch /etc/cron.allow
sudo touch /etc/at.allow

sudo chmod og-rwx /etc/cron.allow
sudo chmod og-rwx /etc/at.allow
sudo chown root:root /etc/cron.allow
sudo chown root:root /etc/at.allow

###
# Get some banners up and running!
# See https://github.com/18F/ubuntu/blob/master/hardening.md#ssh-settings
###
sudo curl -o /etc/update-motd.d/00-header https://raw.githubusercontent.com/fisma-ready/ubuntu-lts/master/files/ubuntu/etc/update-motd.d/00-header
sudo chown root:root /etc/update-motd.d/00-header
sudo chmod 0755 /etc/update-motd.d/00-header


