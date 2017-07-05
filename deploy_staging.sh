#!/bin/bash

echo "Install certbot role"
ansible-galaxy install git+https://github.com/LucianU/ansible-certbot.git

echo "Make sure roles in external.yml are installed"
ansible-galaxy install -r ansible/roles/external.yml

echo "Run deploy command"
ansible-playbook ansible/staging.yml --key-file=~/.ssh/code4_comunitate_staging.pem
