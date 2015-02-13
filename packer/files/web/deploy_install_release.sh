#!/bin/bash

su peacecorps <<'EOF'
cd /home/peacecorps/peacecorps
git fetch --tags
git checkout {{ReleaseTag}}

source /home/peacecorps/pyenv/versions/peacecorps/bin/activate
pip install -r requirements.txt
EOF