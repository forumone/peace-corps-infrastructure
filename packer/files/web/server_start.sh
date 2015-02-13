#!/bin/bash

su ubuntu <<'EOF'
sudo service nginx restart
sudo service peacecorps restart
EOF