  
  ![alt text](image.png)
  nginx:
    image: nginx:latest
    ports:
      - "80:80"  # Forward external traffic to nginx
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro  # Use custom nginx config
    depends_on:
      - app


nginx.conf:
events {}
 
http {
    server {
        listen 80;
 
        location / {
            proxy_pass http://app:3000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}