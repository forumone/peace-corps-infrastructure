#!/bin/bash
apt-get install -y software-properties-common
apt-add-repository ppa:ansible/ansible -y
apt-get -y update
apt-get install -y ansible
apt-get install -y git
git clone https://github.com/18F/peace-corps-infrastructure.git /home/ubuntu/peace-corps-infrastructure
chown -R ubuntu:ubuntu /home/ubuntu/peace-corps-infrastructure


printf 'if [ -f ~/.bashenv ]; then\n    . ~/.bashenv\nfi' > /home/ubuntu/.bashrc
chown -R ubuntu:ubuntu /home/ubuntu/.bashrc

# Install some simple AWS tooling
apt-get install -y python-pip
pip install boto
pip install awscli