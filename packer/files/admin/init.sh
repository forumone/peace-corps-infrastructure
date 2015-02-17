#!/bin/bash

sed -i "s@spdy proxy_protocol@spdy@" /etc/nginx/sites-enabled/peacecorps
sed -i "s@set_real_ip_from@# set_real_ip_from@" /etc/nginx/sites-enabled/peacecorps
sed -i "s@real_ip_header@#real_ip_header@" /etc/nginx/sites-enabled/peacecorps
sed -i "s@ elb_log;@; # elb_log;@" /etc/nginx/sites-enabled/peacecorps
sed -i '/location \/admin {/,/}/d' /etc/nginx/sites-enabled/peacecorps
service nginx restart

cp /home/ubuntu/files/admin/admin_vars.sh /home/peacecorps/admin_vars.sh
chown peacecorps:peacecorps /home/peacecorps/admin_vars.sh