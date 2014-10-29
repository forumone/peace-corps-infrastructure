#!/bin/bash
apt-get install -y software-properties-common
apt-add-repository ppa:ansible/ansible -y
apt-get -y update
apt-get install -y ansible
apt-get install -y git
git clone https://github.com/18F/peace-corps-infrastructure.git /home/ubuntu/peace-corps-infrastructure
chown -R ubuntu:ubuntu /home/ubuntu/peace-corps-infrastructure


printf 'if [ -f ~/.bashenv ]; then\n    . ~/.bashenv\nfi' > /home/ubuntu/.bashrc
chown -R ubuntu:ubuntu /home/ubuntu/.bashrc

# Download Deploy Key from S3. It will be encrypted, so you'll need to decrypt it manually before this server will work
apt-get install -y python-pip
pip install awscli
aws s3 cp --region us-east-1 s3://peacecorps-secrets/deploy.enc /home/ubuntu/deploy.enc
chown -R ubuntu:ubuntu /home/ubuntu/deploy.enc

instance_profile=`curl http://169.254.169.254/latest/meta-data/iam/security-credentials/`

aws_access_key_id=`curl http://169.254.169.254/latest/meta-data/iam/security-credentials/${instance_profile} | grep AccessKeyId | cut -d':' -f2 | sed 's/[^0-9A-Z]*//g'`

aws_secret_access_key=`curl http://169.254.169.254/latest/meta-data/iam/security-credentials/${instance_profile} | grep SecretAccessKey | cut -d':' -f2 | sed 's/[^0-9A-Za-z/+=]*//g'`

printf 'export AWS_ACCESS_KEY_ID=%s\nexport AWS_SECRET_ACCESS_KEY=%s'  ${aws_access_key_id} ${aws_secret_access_key} > /home/ubuntu/.bashenv
chown -R ubuntu:ubuntu /home/ubuntu/.bashenv


printf "*/05 * * * * ubuntu bash /home/ubuntu/peace-corps-infrastructure/awscredentials.sh" > /etc/cron.d/awscredentials
chown -R ubuntu:ubuntu /etc/cron.d/awscredentials



