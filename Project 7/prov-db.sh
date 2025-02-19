#!/bin/bash

# get updates of packages with no user input

sudo apt update -y

# downloads and installs the latest updates for packages based on above command with no user input

sudo DEBIAN_FRONTEND=noninteractive apt upgrade -yq

#installs gnupg and curl with no user input
sudo DEBIAN_FRONTEND=noninteractive apt install gnupg curl -y

#downloads gpg key with no user input
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg --batch --yes -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor

#creates file list
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

#updates packages again
sudo apt update -y

# installs mongo db 7.0.6 components
sudo apt install -y mongodb-org=7.0.6 mongodb-org-database=7.0.6 mongodb-org-server=7.0.6 mongodb-mongosh mongodb-org-mongos=7.0.6 mongodb-org-tools=7.0.6

# changes the bindIP default setting to listen to all sources
sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf

# enabling mongod to start on boot, starts it
sudo systemctl enable mongod
sudo systemctl is-enabled mongod # checking it's enabled

# restarts mongodb to save new enabled setting 
sudo systemctl restart mongod