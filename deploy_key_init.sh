#!/bin/bash
openssl aes-256-cbc -d -a -salt -in ~/deploy.enc ~/deploy
chmod 600 deploy