#!/bin/bash

cd /home/peacecorps/peacecorps/peacecorps
source /home/peacecorps/pyenv/versions/peacecorps/bin/activate

if [ -f /home/peacecorps/webserver-init.sh ]; then
    source /home/peacecorps/webserver-init.sh
fi

if [ -f /home/peacecorps/pay-init.sh ]; then
    source /home/peacecorps/pay-init.sh
fi

if [ -f /home/peacecorps/admin-init.sh ]; then
    source /home/peacecorps/admin-init.sh
fi

python manage.py "$@"