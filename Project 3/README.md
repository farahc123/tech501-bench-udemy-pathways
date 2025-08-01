# Project 1: Jenkins CICD pipeline

- [Project 1: Jenkins CICD pipeline](#project-1-jenkins-cicd-pipeline)
  - [Goal of the project](#goal-of-the-project)
  - [Prerequisites](#prerequisites)
    - [Setting up the Sonarqube server](#setting-up-the-sonarqube-server)
    - [Setting up Jenkins server](#setting-up-jenkins-server)
  - [Diagram of pipeline](#diagram-of-pipeline)
  - [Pipeline steps overview](#pipeline-steps-overview)
  - [Demonstration](#demonstration)

## Goal of the project

The goal of this project is to implement a CI/CD pipeline for efficient software delivery. The pipeline will run on Jenkins and use SonarQube, Docker, and Kubernetes for the automated integration, code-scanning, deployment, and management of a containerised application already running in a 2-node cluster via Kops on GCP Compute Engines. When the pipeline is started, a notification will be sent to a Slack channel to inform the DevOps team, and upon its completion, another notification will be sent to update them on the build's result.

## Prerequisites

- [A GitHub repo containing the app code with a *dev* and a *main* branch](https://github.com/farahc123/tech501-sparta-app-CICD)
- A Jenkins server with Docker installed
- A target VM from where the Kops cluster is launched, with an app deployment referencing [an image stored on Docker Hub](https://hub.docker.com/repository/docker/farahc123/sparta-app/)
- A SonarQube server with a project for the app and a webhook set up to communicate with Jenkins
- A Slack account & channel where notifications will be sent, with a token generated for Jenkins via the Slack's Jenkins integration
- **Jenkins plugins**:
  - SSH Agent
  - SonarQube
  - NodeJS (with version 20 installed under *Manage Jenkins>Tools*)
  - Slack Notifications (with workspace and default channel set under *Manage Jenkins>Tools*)
- **Credentials loaded into Jenkins**:
  - Docker Hub username & password
  - SonarQube token
  - GitHub SSH key
  - SSH key for the target VMs
  - Slack 

### Setting up the Sonarqube server

1. Run this Terraform file to create the VM with this idempotent script running as the startup script 
2. Run [this script](scripts/sonarqube-setup.sh)
3. Navigate to the public IP of the 

### Setting up Jenkins server

1. Run this script
2. Add these plugins:
3. Add these credentials:

## Diagram of pipeline

![Jenkins CICD pipeline](<jenkins-cicd-pipeline-project1.jpg>)

## Pipeline steps overview

[**Full pipeline available to view here**](<Project files/Jenkinsfile>)

1. Outside of the pipeline, a colour map function is first defined that will be used in the post-build Slack notification step 
2. The pipeline starts, with credentials for Docker Hub, GitHub, and the SSH key for the target VM stored as variables that can be referenced throughout the entire pipeline in the `environment` block
3. NodeJS version 20 is specified in the `tools` block
4. **Stages**:
   1. A notification is sent to the *#devopscicd* Slack channel informing the DevOps team that the pipeline has been started ![`Pipeline started Slack notification`](images/image-3.png)
   2. The code is checked out from the *dev* branch of the GitHub repo using the credentials stored as an environment variable
   3. The *app* folder is set as the working directory, and tests are run on the code
   4. The code is scanned by the SonarQube server, where it is stored as a project called *sparta-app* ![`SonarQube project`](images/image-4.png)
   5. The results of the scan are compared to the quality gate conditions (in this case, SonarQube's default quality gate is used)
   6. Provided the above stages run successfully, the tested code is merged to the *main* branch of the GitHub repo
   7. The Docker image is built, with the build number of the Jenkins pipeline being passed as the image tag
   8. Jenkins logs into Docker using the provided credentials
   9. The Docker image is pushed to Docker Hub ![`Docker Hub`](images/image-5.png)
   10. The Docker image used in the existing Kubernetes deployment (running in a K8s cluster on GCP VMs) is updated
5.  Post-build, a notification is sent to the *#devopscicd* Slack channel informing the DevOps team of the build's result ![`Build result Slack notification`](images/image-6.png)

http://10.128.0.7:8080/sonarqube-webhook

## Demonstration

[Watch the pipeline in action here](https://drive.google.com/file/d/1gbhnTFWePJzPanzyI-klSS1Bl8XEf1q_/view?usp=sharing)
