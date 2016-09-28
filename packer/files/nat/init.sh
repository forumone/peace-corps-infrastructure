#!/bin/bash

paygov_domain="%PAYGOV_DOMAIN%"
paygov_elb="%PAYGOV_ELB%"
environment="%ENVIRONMENT%"
decryption_key="%DECRYPTION_KEY%"

if [ $environment = "production" ]; then
    aws_secret_bucket_name="donate-peacecorps-secrets"
else
    aws_secret_bucket_name="stage-donate-peacecorps-secrets"
fi

sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sysctl -p
iptables -t nat -A POSTROUTING -o eth0 -s 10.19.61.0/24 -j MASQUERADE
sed -i '/exit 0/i iptables -t nat -A POSTROUTING -o eth0 -s 10.19.61.0/24 -j MASQUERADE' /etc/rc.local

sed -i "s@{{domain}}@$paygov_domain@" /etc/nginx/sites-enabled/peacecorps
sed -i "s@{{paygov_elb}}@$paygov_elb@" /etc/nginx/sites-enabled/peacecorps

aws s3 cp s3://${aws_secret_bucket_name}/${environment}/paygov/${paygov_domain}.key.enc /tmp/${paygov_domain}.key.enc
openssl aes-256-cbc -d -a -salt -pass pass:${decryption_key} -in /tmp/${paygov_domain}.key.enc -out /etc/nginx/ssl/keys/${paygov_domain}.key

aws s3 cp s3://${aws_secret_bucket_name}/${environment}/paygov/${paygov_domain}.chained.crt.enc /tmp/${paygov_domain}.chained.crt.enc
openssl aes-256-cbc -d -a -salt -pass pass:${decryption_key} -in /tmp/${paygov_domain}.chained.crt.enc -out /etc/nginx/ssl/keys/${paygov_domain}.chained.crt

service nginx restart
