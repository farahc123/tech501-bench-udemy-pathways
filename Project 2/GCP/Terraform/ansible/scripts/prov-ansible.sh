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

# Create /etc/ansible directory if it doesn't exist
if [ ! -d /etc/ansible ]; then
  echo "Creating /etc/ansible directory..."
  sudo mkdir -p /etc/ansible
else
  echo "/etc/ansible directory already exists."
fi

# Create /etc/ansible/hosts if it doesn't exist
if [ ! -f /etc/ansible/hosts ]; then
  echo "Creating /etc/ansible/hosts file..."
  sudo touch /etc/ansible/hosts
else
  echo "/etc/ansible/hosts file already exists."
fi

# Create /etc/ansible/ansible.cfg if it doesn't exist with specified contents
if [ ! -f /etc/ansible/ansible.cfg ]; then
  echo "Creating /etc/ansible/ansible.cfg file..."
  sudo bash -c 'cat > /etc/ansible/ansible.cfg <<EOF
[defaults]
#inventory      = /etc/ansible/hosts
inventory      = hosts
EOF'
else
  echo "/etc/ansible/ansible.cfg file already exists."
fi