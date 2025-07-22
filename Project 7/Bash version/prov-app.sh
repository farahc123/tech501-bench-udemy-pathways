#!/bin/bash

# Define log file
LOG_FILE="/farah_custom_data.log"

# Redirect stdout and stderr to the log file
exec > >(sudo tee -a "$LOG_FILE") 2>&1

echo "Fetching the latest version of current packages..."
sudo apt update -y

echo "Upgrading installed packages..."
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -yq

echo "Installing Nginx..."
sudo DEBIAN_FRONTEND=noninteractive apt install -yq nginx
sudo systemctl enable nginx
sudo systemctl reload nginx

echo "Configuring Nginx reverse proxy..."
sudo sed -i 's|try_files $uri $uri/ =404;|proxy_pass http://localhost:3000;|' /etc/nginx/sites-available/default
echo "Checking Nginx configuration syntax..."
sudo nginx -t
echo "Reloading Nginx..."
sudo systemctl reload nginx

echo "Downloading and installing Node.js..."
sudo DEBIAN_FRONTEND=noninteractive bash -c "curl -fsSL https://deb.nodesource.com/setup_20.x | bash -" && \
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs

echo "Checking Node.js and npm versions..."
node -v
npm -v

echo "Cloning the application repository..."
sudo git clone https://github.com/farahc123/tech501-sparta-app.git /repo

echo "Starting the app for the first time using PM2..."
cd /repo/nodejs20-sparta-test-app/app
sudo chown -R $(whoami) /repo/nodejs20-sparta-test-app
sudo npm install
sudo npm audit fix
sudo npm install pm2 -g

echo "Setting up database connection..."
export DB_HOST=mongodb://172.31.51.68:27017/posts

echo "Seeding the database..."
node seeds/seed.js

echo "Stopping the application with PM2 in case it's already running..."
pm2 delete app.js

echo "Starting the application with PM2..."
pm2 start app.js

echo "Script execution completed. Logs stored in $LOG_FILE"
