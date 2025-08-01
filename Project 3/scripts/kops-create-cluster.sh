#!/bin/bash

set -e

echo "Creating the K8s cluster..."
kops create cluster \
  --cloud=gce \
  --name=sparta-app.example.com \
  --zones=us-central1-a \
  --project=sparta-app-462710 \
  --node-size=e2-medium \
  --control-plane-size=e2-medium \
  --node-count=2 \
  --state=gs://kops-sparta-app-state

echo "✅Cluster sparta-app.example.com created. Now updating the cluster..."
kops update cluster --name sparta-app.example.com --yes --admin --state=gs://kops-sparta-app-state

echo "Waiting for the cluster to be ready..."
until kops validate cluster --name=sparta-app.example.com --state=gs://kops-sparta-app-state &> /dev/null; do
  echo "Cluster is still being created. Waiting for 30 seconds..."
  sleep 30
done
echo "✅Cluster sparta-app.example.com is ready."

cd ~/k8s-manifests/app
echo "Applying Kubernetes app manifests..."
kubectl apply -f .

cd ~/k8s-manifests/db
echo "Applying Kubernetes db manifests..."
kubectl apply -f .

echo "✅Done!"