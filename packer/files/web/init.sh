#!/bin/bash

domain="%DOMAIN%"
paygov_domain="%PAYGOV_DOMAIN%"
admin_domain="%ADMIN_DOMAIN%"
file_transfer_domain="%FILE_TRANSFER_DOMAIN%"
environment="%ENVIRONMENT%"
role="%ROLE%"
decryption_key="%DECRYPTION_KEY%"
secret_key="%SECRET_KEY%"
pg_name="%PG_NAME%"
pg_user="%PG_USER%"
pg_pass="%PG_PASS%"
pg_host="%PG_HOST%"
gpg_encrypt_id="%GPG_ENCRYPT_ID%"
memcached_url="%MEMCACHED_URL%"
release_tag="%RELEASE_TAG%"
aws_media_bucket_name="%AWS_MEDIA_BUCKET_NAME%"
aws_static_bucket_name="%AWS_STATIC_BUCKET_NAME%"
hosted_zone_id="%HOSTED_ZONE_ID%"


sed -i "s@{{SECRET_KEY}}@$domain@" /home/peacecorps/webapp_vars.sh
sed -i "s@{{PG_NAME}}@$pg_name@" /home/peacecorps/webapp_vars.sh
sed -i "s@{{PG_USER}}@$pg_user@" /home/peacecorps/webapp_vars.sh
sed -i "s@{{PG_PASS}}@$pg_pass@" /home/peacecorps/webapp_vars.sh
sed -i "s@{{PG_HOST}}@$pg_host@" /home/peacecorps/webapp_vars.sh
sed -i "s@{{GPG_ENCRYPT_ID}}@$gpg_encrypt_id@" /home/peacecorps/webapp_vars.sh
sed -i "s@{{MEMCACHED_URL}}@$memcached_url@" /home/peacecorps/webapp_vars.sh
sed -i "s@{{AWS_MEDIA_BUCKET_NAME}}@$aws_media_bucket_name@" /home/peacecorps/webapp_vars.sh
sed -i "s@{{AWS_STATIC_BUCKET_NAME}}@$aws_static_bucket_name@" /home/peacecorps/webapp_vars.sh

if [ $environment = "production" ]; then
    sed -i "s@{{PAY_GOV_OCI_URL}}@https://pay.gov/paygov/OCIServlet@" /home/peacecorps/webapp_vars.sh
else
    sed -i "s@{{PAY_GOV_OCI_URL}}@https://qa.pay.gov/paygov/OCIServlet@" /home/peacecorps/webapp_vars.sh
fi

if [ $role = "web" ]; then
    domain_name=$domain
fi
if [ $role = "paygov" ]; then
    domain_name=$paygov_domain
fi
if [ $role = "admin" ]; then
    domain_name=$admin_domain
fi

# Do the needed replacements
sed -i "s@{{domain}}@$domain_name@" /etc/nginx/sites-enabled/peacecorps

# Download the appropriate SSL key
aws s3 cp s3://peacecorps-secrets/${environment}/${role}/${domain_name}.key.enc /tmp/${domain_name}.key.enc
openssl aes-256-cbc -d -a -salt -pass pass:${decryption_key} -in /tmp/${domain_name}.key.enc -out /etc/nginx/ssl/keys/${domain_name}.key

# Download the appropriate SSL chain certificate
aws s3 cp s3://peacecorps-secrets/${environment}/${role}/${domain_name}.chained.crt.enc /tmp/${domain_name}.chained.crt.enc
openssl aes-256-cbc -d -a -salt -pass pass:${decryption_key} -in /tmp/${domain_name}.chained.crt.enc -out /etc/nginx/ssl/keys/${domain_name}.chained.crt

aws s3 cp s3://peacecorps-secrets/${environment}/all/pubring.gpg.enc /tmp/pubring.gpg.enc
openssl aes-256-cbc -d -a -salt -pass pass:${decryption_key} -in /tmp/pubring.gpg.enc -out /gpg/pubring.gpg
chown peacecorps:peacecorps /gpg/pubring.gpg

aws s3 cp s3://peacecorps-secrets/${environment}/all/trustdb.gpg.enc /tmp/trustdb.gpg.enc
openssl aes-256-cbc -d -a -salt -pass pass:${decryption_key} -in /tmp/trustdb.gpg.enc -out /gpg/trustdb.gpg
chown peacecorps:peacecorps /gpg/trustdb.gpg

if [ $role = "paygov" ]; then
    aws s3 cp s3://peacecorps-secrets/${environment}/${role}/secring.gpg.enc /tmp/secring.gpg.enc
    openssl aes-256-cbc -d -a -salt -pass pass:${decryption_key} -in /tmp/secring.gpg.enc -out /gpg/secring.gpg
    chown peacecorps:peacecorps /gpg/secring.gpg

    echo "53 * * * * peacecorps bash /home/peacecorps/manage.sh clear_stale_donors" | tee /etc/cron.d/clean_stale_donors

    cp /home/ubuntu/files/paygov/pay_vars.sh /home/peacecorps/pay_vars.sh
    chown peacecorps:peacecorps /home/peacecorps/pay_vars.sh
fi

if [ $role = "admin" ]; then
    sh /home/ubuntu/files/admin/init.sh
    sh /home/ubuntu/files/filetransfer/init.sh

    aws s3 cp s3://peacecorps-secrets/${environment}/admin/ssh_host_dsa_key.enc /tmp/ssh_host_dsa_key.enc
    openssl aes-256-cbc -d -a -salt -pass pass:${decryption_key} -in /tmp/ssh_host_dsa_key.enc -out /etc/ssh/ssh_host_dsa_key

    aws s3 cp s3://peacecorps-secrets/${environment}/admin/ssh_host_dsa_key.pub.enc /tmp/ssh_host_dsa_key.pub.enc
    openssl aes-256-cbc -d -a -salt -pass pass:${decryption_key} -in /tmp/ssh_host_dsa_key.pub.enc -out /etc/ssh/ssh_host_dsa_key.pub



    aws s3 cp s3://peacecorps-secrets/${environment}/admin/ssh_host_ecdsa_key.enc /tmp/ssh_host_ecdsa_key.enc
    openssl aes-256-cbc -d -a -salt -pass pass:${decryption_key} -in /tmp/ssh_host_ecdsa_key.enc -out /etc/ssh/ssh_host_ecdsa_key

    aws s3 cp s3://peacecorps-secrets/${environment}/admin/ssh_host_ecdsa_key.pub.enc /tmp/ssh_host_ecdsa_key.pub.enc
    openssl aes-256-cbc -d -a -salt -pass pass:${decryption_key} -in /tmp/ssh_host_ecdsa_key.pub.enc -out /etc/ssh/ssh_host_ecdsa_key.pub


    aws s3 cp s3://peacecorps-secrets/${environment}/admin/ssh_host_rsa_key.enc /tmp/ssh_host_rsa_key.enc
    openssl aes-256-cbc -d -a -salt -pass pass:${decryption_key} -in /tmp/ssh_host_rsa_key.enc -out /etc/ssh/ssh_host_rsa_key

    aws s3 cp s3://peacecorps-secrets/${environment}/admin/ssh_host_rsa_key.pub.enc /tmp/ssh_host_rsa_key.pub.enc
    openssl aes-256-cbc -d -a -salt -pass pass:${decryption_key} -in /tmp/ssh_host_rsa_key.pub.enc -out /etc/ssh/ssh_host_rsa_key.pub

    PUBLIC_HOSTNAME=$(ec2metadata | grep 'public-hostname:' | cut -d ' ' -f 2)

    sed -i "s@{{domain}}@$file_transfer_domain@" /home/ubuntu/files/filetransfer/dns.json
    sed -i "s@{{target}}@$PUBLIC_HOSTNAME@" /home/ubuntu/files/filetransfer/dns.json

    aws --region us-east-1 route53 change-resource-record-sets --hosted-zone-id $hosted_zone_id --change-batch file:///home/ubuntu/files/filetransfer/dns.json
fi

su peacecorps <<'EOF'
cd /home/peacecorps/peacecorps
git fetch --tags
git checkout %RELEASE_TAG%

source /home/peacecorps/pyenv/versions/peacecorps/bin/activate
pip install -r requirements.txt
EOF

if [ $role = "admin" ]; then
    sh /home/ubuntu/files/admin/mutexleader.sh
fi

service peacecorps restart
service nginx restart
