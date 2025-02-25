# Using NodeJS version 20
FROM node:20


# Custom label adding metadata to the image
LABEL description="Farah's image of the Sparta test app"


# Set the default working directory
WORKDIR /usr/src/app

# Copy the application first (including seeds directory)
COPY app/ .  

ENV DB_HOST=mongodb://10.0.3.4:27017/posts
# note i should try the container like this, then if it doesn't work, run it in this format docker run -d -p 9000:9000 -e NGINX_PORT=9000 --name env-container my-nginx-env to ensure they have specific values when starting a container; if you're confident that you always want Nginx to listen on port 9000 and don't need to change it later, you could technically omit the -e NGINX_PORT=9000 part when running your container since it's already defined in your Dockerfile. However, including it provides clarity and flexibility for future changes.

# Install dependencies (after copying the full app)
RUN npm install
COPY app/seeds /usr/src/app/seeds


# running seed script
RUN node /usr/src/app/seeds/seed.js


# Expose port 3000
EXPOSE 3000


# setting startup command
CMD ["npm", "start"]