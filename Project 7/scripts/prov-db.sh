#!/bin/bash

# Define log file
LOG_FILE="/farah_custom_data.log"

# Redirect output & errors to the log file
exec > >(sudo tee -a "$LOG_FILE") 2>&1

# get updates of packages with no user input
echo "Updating package lists..."
sudo apt update -y

# downloads and installs the latest updates for packages
echo "Upgrading installed packages..."
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -yq

# installs gnupg and curl
echo "Installing gnupg and curl..."
sudo DEBIAN_FRONTEND=noninteractive apt install gnupg curl -y

# downloads gpg key
echo "Downloading and adding MongoDB GPG key..."
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
sudo gpg --batch --yes -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor

# creates file list
echo "Adding MongoDB repository..."
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# updates packages again
echo "Updating package lists again..."
sudo apt update -y

# installs MongoDB components
echo "Installing MongoDB 7.0.6 components..."
sudo apt install -y mongodb-org=7.0.6 mongodb-org-database=7.0.6 mongodb-org-server=7.0.6 mongodb-mongosh mongodb-org-mongos=7.0.6 mongodb-org-tools=7.0.6

# changes the bindIP default setting
echo "Updating MongoDB bindIp setting to listen to all sources..."
sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf

# enables MongoDB to start on boot, starts it
echo "Enabling MongoDB service..."
sudo systemctl enable mongod

# checks if MongoDB is enabled
echo "Checking if MongoDB service is enabled..."
sudo systemctl is-enabled mongod

# restarts MongoDB to save new enabled setting
echo "Restarting MongoDB service..."
sudo systemctl restart mongod

echo "Script execution completed. Logs stored in $LOG_FILE"
