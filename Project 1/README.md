# Project 1

- [Project 1](#project-1)
  - [Goal of the project](#goal-of-the-project)
  - [Prerequisites](#prerequisites)
  - [Diagram of pipeline](#diagram-of-pipeline)
  - [Pipeline steps overview](#pipeline-steps-overview)

## Goal of the project

The goal of this project is to implement a CI/CD pipeline for efficient software delivery. The pipeline will run on Jenkins and use SonarQube, Docker, and Kubernetes for the automated integration, code-scanning, deployment, and management of a containerised application already running via Minikube on an EC2.

## Prerequisites

- A GitHub repo containing the app code with a *dev* and a *main* branch
- A Jenkins server
- A target VM with the app already running via Minikube
- A SonarQube server with a project for the app and a webhook set up to communicate with Jenkins
- **Jenkins plugins**:
  - SSH Agent
  - NodeJS
  - SonarQube
  - Docker Pipeline
  - NodeJS (with version 20 installed under *Manage Jenkins>Tools*)
- **Credentials loaded into Jenkins**:
  - Docker Hub username & password
  - SonarQube token
  - GitHub SSH key
  - SSH key for the target VMs

## Diagram of pipeline

![Jenkins CICD pipeline](<jenkins-cicd-pipeline-project1.png>)

## Pipeline steps overview

[**Full pipeline available to view here**](<Project files/Jenkinsfile>)

1. Credentials for Docker Hub, GitHub, and the SSH key for the target VM are stored as variables that can be referenced throughout the entire pipeline in the `environment` block
2. NodeJS version 20 is specified in the `tools` block
3. **Stages**:
   1. The code is checked out from the *dev* branch of the GitHub repo using the credentials stored as an environment variable
   2. The *app* folder is set as the working directory, and tests are run on the code
   3. The code is scanned by the SonarQube server, where it is stored as a project called *sparta-app*
   4. The results of the scan are compared to the quality gate conditions (in this case, SonarQube's default quality gate is used)
   5. Provided the above stages run successfully, the tested code is merged to the *main* branch of the GitHub repo
   6. The Docker image is built, with the build number of the Jenkins pipeline being passed as the image tag
   7. Jenkins logs into Docker using the provided credentials
   8. The Docker image is pushed to Docker Hub
   9. The Docker image used the existing Kubernetes deployment (running on Minikube on the target VM) is updated