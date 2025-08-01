#!/bin/bash

set -e

echo "Deleting Kubernetes app resources..."
cd ~/k8s-manifests/app
kubectl delete -f .

echo "Deleting Kubernetes db resources..."
cd ~/k8s-manifests/db
kubectl delete -f .

echo "Deleting kops cluster. This may take a while (up to 10 mins)..."
if kops delete cluster --name sparta-app.example.com --state=gs://kops-sparta-app-state --yes; then
    echo "✅Kops cluster deleted successfully!"
else
    echo "⚠️ First attempt to delete kops cluster failed. Retrying once..."
    if kops delete cluster --name sparta-app.example.com --state=gs://kops-sparta-app-state --yes; then
        echo "✅Kops cluster deleted successfully on retry!"
    else
        echo "❌Second attempt to delete kops cluster also failed. Manual intervention required."
        exit 1
    fi
fi

echo "✅Cleanup completed successfully."