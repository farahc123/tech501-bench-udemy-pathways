#!/bin/bash

LOG_FILE="/farah_running_app_only.log"

# Redirect output & errors to the log file
exec > >(sudo tee -a "$LOG_FILE") 2>&1

echo "Changing directory to application folder..."
cd /repo/nodejs20-sparta-test-app/app

echo "Installing npm dependencies..."
sudo npm install

# Changed from export DB_HOST=mongodb://172.31.48.148:27017/posts to export DB_HOST=mongodb://10.0.3.4:27017/posts when I switched to Azure
echo "Setting up database connection..."
export DB_HOST=mongodb://10.0.3.4:27017/posts

echo "Seeding the database..."
node seeds/seed.js

echo "Stopping the application using PM2..."
pm2 delete app.js

echo "Starting the application using PM2..."
pm2 start app.js

echo "Script execution completed. Logs stored in $LOG_FILE"
