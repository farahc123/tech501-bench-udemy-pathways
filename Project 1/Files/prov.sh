# script to provision a new EC2 for use in this Jenkins pipeline

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

echo "Checking Nginx configuration syntax..."
sudo nginx -t
echo "Reloading Nginx..."
sudo systemctl reload nginx

# Install additional packages
echo "Installing additional packages (apt-transport-https, curl, virtualbox, docker.io)..."
sudo DEBIAN_FRONTEND=noninteractive apt install -yq apt-transport-https curl virtualbox docker.io

# Enable and restart Docker
echo "Enabling and restarting Docker..."
sudo systemctl enable docker
sudo systemctl restart docker

# Install Minikube
echo "Downloading and installing Minikube..."
sudo curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo mv minikube-linux-amd64 /usr/local/bin/minikube
sudo chmod +x /usr/local/bin/minikube

# there is an issue with the below command hanging
echo "Adding user to Docker group..."
sudo usermod -aG docker $USER && newgrp docker

# Install kubectl
echo "Downloading and installing kubectl..."
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Apply Metrics Server components
echo "Applying Metrics Server components..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
