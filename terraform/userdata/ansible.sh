#!/bin/bash
apt-get install -y software-properties-common
apt-add-repository ppa:ansible/ansible -y
apt-get -y update
apt-get install -y ansible
apt-get install -y git
git clone https://github.com/18F/peace-corps-infrastructure.git /home/ubuntu/peace-corps-infrastructure

instance_profile=`curl http://169.254.169.254/latest/meta-data/iam/security-credentials/`
aws_access_key_id=`curl http://169.254.169.254/latest/meta-data/iam/security-credentials/${instance_profile} | grep AccessKeyId | cut -d':' -f2 | sed 's/[^0-9A-Z]*//g'`

aws_secret_access_key=`curl http://169.254.169.254/latest/meta-data/iam/security-credentials/${instance_profile} | grep SecretAccessKey | cut -d':' -f2 | sed 's/[^0-9A-Za-z/+=]*//g'`

export AWS_ACCESS_KEY_ID=${aws_access_key_id}
export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}