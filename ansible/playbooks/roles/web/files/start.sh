#!/bin/bash

cd /home/peacecorps/peacecorps/peacecorps
source ~/pyenv/versions/peacecorps-3.4.1/bin/activate

if [ -f ~/webserver-dev.sh ]; then
    source ~/webserver-dev.sh
fi

if [ -f ~/pay-dev.sh ]; then
    source ~/pay-dev.sh
fi


exec gunicorn peacecorps.wsgi:application