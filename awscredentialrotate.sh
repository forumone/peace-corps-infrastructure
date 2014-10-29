#!/bin/bash
instance_profile=`curl http://169.254.169.254/latest/meta-data/iam/security-credentials/`
aws_access_key_id=`curl http://169.254.169.254/latest/meta-data/iam/security-credentials/${instance_profile} | grep AccessKeyId | cut -d':' -f2 | sed 's/[^0-9A-Z]*//g'`
aws_secret_access_key=`curl http://169.254.169.254/latest/meta-data/iam/security-credentials/${instance_profile} | grep SecretAccessKey | cut -d':' -f2 | sed 's/[^0-9A-Za-z/+=]*//g'`
printf 'export AWS_ACCESS_KEY_ID=%s\nexport AWS_SECRET_ACCESS_KEY=%s'  ${aws_access_key_id} ${aws_secret_access_key} > /home/ubuntu/.bashenv
