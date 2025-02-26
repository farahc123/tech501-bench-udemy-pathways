# Using NodeJS version 20
FROM node:20

# Adding metadata to the image
LABEL description="Farah's image of the Sparta test app"

# Sets the default working directory
WORKDIR /usr/src/app

# Copies the app's dependencies and then the app
COPY package*.json ./
COPY app/ .  

# Exposes port 3000
EXPOSE 3000

# Sets startup command
CMD ["npm", "start"]