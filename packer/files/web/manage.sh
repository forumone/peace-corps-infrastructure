#!/bin/bash

cd /home/peacecorps/peacecorps/peacecorps
source /home/peacecorps/pyenv/versions/peacecorps/bin/activate

if [ -f /home/peacecorps/webapp_vars.sh ]; then
    source /home/peacecorps/webapp_vars.sh
fi

if [ -f /home/peacecorps/pay_vars.sh ]; then
    source /home/peacecorps/pay_vars.sh
fi

if [ -f /home/peacecorps/admin_vars.sh ]; then
    source /home/peacecorps/admin_vars.sh
fi

python manage.py "$@"