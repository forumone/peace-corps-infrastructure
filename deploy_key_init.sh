#!/bin/bash
openssl aes-256-cbc -d -a -salt -in ~/deploy.enc -out ~/deploy
chmod 600 ~/deploy