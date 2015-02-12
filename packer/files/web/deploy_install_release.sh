#!/bin/bash

su peacecorps <<'EOF'
cd /home/peacecorps/peacecorps
git fetch --tags
git checkout {{ReleaseTag}}

pyenv activate peacecorps
pip install -r requirements.txt
EOF