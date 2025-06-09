# These are the configurations for the Jenkins freestyle jobs (without the SonarQube scanning step)

#---------------------------------------------------------------------------

# Project 1: Test

"""
- webhook enabled
- branch specifier: */dev
- nodejs enabled
- ssh agent for github
- shell commands:
"""

cd app
npm install
npm test

#---------------------------------------------------------------------------

# Project 2: Merge

"""
- branch specifier: */dev
- additional behavior: merge before build
    - name of repository: origin
    - branch to merge to: main
- ssh agent for github
- post-build actions:
    - git publisher
        - push only if build succeeds
        - branch to push: main
        - target remote name: origin
"""

#---------------------------------------------------------------------------

# Project 3: Deploy

"""
- branch specifier: */main
- use secret text (username and password (separated)):
    - username: DOCKER_USERNAME
    - password: DOCKER_PASSWORD
    - credentials ID: farahc123/***
- SSH agent: ubuntu (for target vms)
- build steps:
    - execute shell commands:
"""
IMAGE_TAG=farahc123/devops-app:${BUILD_NUMBER}

echo "Building Docker image: $IMAGE_TAG"
docker build -t $IMAGE_TAG .

echo "Logging into Docker Hub"
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

echo "Pushing Docker image"
docker push $IMAGE_TAG

echo "Deploying to Kubernetes..."
ssh -o StrictHostKeyChecking=no ubuntu@16.16.121.124 << EOF
  export KUBECONFIG=/home/ubuntu/.kube/config
  
  echo "Setting image in deployment..."
  kubectl set image deployment/devops-app-deployment devops-app=$IMAGE_TAG --record
  
  echo "Deployment updated"
EOF
