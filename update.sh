#!/bin/bash
git pull origin %InfrastructureBranchName%
aws s3 cp s3://%SecretsBucket% playbooks/secrets/ --recursive

for filename in playbooks/secrets/*.enc
do
    openssl aes-256-cbc -d -a -salt -pass file:/home/ubuntu/decrypt.txt -in $filename -out ${filename%.*}
done;

cp playbooks/secrets/deploy.enc deploy.pem
chmod 600 deploy.pem

ansible-playbook -i ec2.py --private-key deploy.pem --sudo playbooks/peacecorps.yml

#rm -rf secrets/*