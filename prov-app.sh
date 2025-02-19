#!/bin/bash

# fetches the latest version of current packages

sudo apt update -y 

# downloads and installs the latest updates for packages based on above command
# changed for test

sudo DEBIAN_FRONTEND=noninteractive apt upgrade -yq

# installs nginx

sudo DEBIAN_FRONTEND=noninteractive apt install -yq nginx
sudo systemctl enable nginx
sudo systemctl reload nginx

# configuring reverse proxy, checking syntax, and reloading nginx
sudo sed -i 's|try_files $uri $uri/ =404;|proxy_pass http://localhost:3000;|' /etc/nginx/sites-available/default
sudo nginx -t
sudo systemctl reload nginx

# downloading node js 

sudo DEBIAN_FRONTEND=noninteractive bash -c "curl -fsSL https://deb.nodesource.com/setup_20.x | bash -" && \
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs

# check if node and npm are installed

node -v
npm -v

# git cloning the repo with the clean app files
sudo git clone https://github.com/farahc123/tech501-sparta-app.git /repo

# starting the app on first run using pm2
cd /repo/nodejs20-sparta-test-app/app
sudo chown -R $(whoami) /repo/nodejs20-sparta-test-app
sudo npm install
sudo npm audit fix
sudo npm install pm2 -g
export DB_HOST=mongodb://172.31.51.68:27017/posts
node seeds/seed.js
pm2 start app.js

# output: table showing app is in fork mode and has online status

# then paste IP address into url bar to test app is running