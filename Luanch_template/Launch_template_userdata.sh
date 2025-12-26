#!/bin/bash
set -e

# Log everything
exec > >(tee /var/log/user-data.log) 2>&1

# Ensure system is ready
sleep 30

cd /myrepo

# Run ansible locally
sudo ansible-playbook playbook.yaml
