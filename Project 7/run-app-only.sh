#!/bin/bash

# navigating into app folder
cd /repo/nodejs20-sparta-test-app/app

#installing npm
sudo npm install

#export DB_HOST= correct private IP
export DB_HOST=mongodb://172.31.60.72:27017/posts

#seeding the database
node seeds/seed.js

#starting the app
pm2 start app.js