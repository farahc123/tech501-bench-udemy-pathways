#!/bin/bash

exec > >(tee -a /prov-ansible-log.log) 2>&1

echo "Updating package lists and upgrading installed packages..."
sudo apt update
sudo apt upgrade -y

echo "Installing Ansible..."
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y

echo "Ensuring Ansible is updated..."
sudo apt update
sudo apt upgrade -y

echo "Ansible installation complete."