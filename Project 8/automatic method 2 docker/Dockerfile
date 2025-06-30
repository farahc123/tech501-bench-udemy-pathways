# Uses the latest version of the Node.js image
FROM node:latest
 
# Sets working directory
WORKDIR /usr/src/app
 
# Copies the app's dependencies and then the app
COPY package*.json ./
COPY ./app/ /usr/src/app/
 
# Exposes the port
EXPOSE 3000
 
# Installs dependencies & starts app
CMD npm install && npm start