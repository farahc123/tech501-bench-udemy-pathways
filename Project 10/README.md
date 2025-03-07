# **Project 10: Kubernetes**

- [**Project 10: Kubernetes**](#project-10-kubernetes)
  - [Goal of this project](#goal-of-this-project)
  - [Prerequisites](#prerequisites)
- [**Research**](#research)
  - [Kubernetes](#kubernetes)
    - [Lifecycle](#lifecycle)
    - [Benefits of Kubernetes](#benefits-of-kubernetes)
- [Day 1 Tasks](#day-1-tasks)
  - [Get Kubernetes running using Docker Desktop](#get-kubernetes-running-using-docker-desktop)
  - [Create Nginx deployment only](#create-nginx-deployment-only)
  - [Get a NodePort service running](#get-a-nodeport-service-running)
  - [See what happens when we delete a pod](#see-what-happens-when-we-delete-a-pod)
  - [Increase replicas with no downtime](#increase-replicas-with-no-downtime)
    - [Method 1: editing the deployment file in real-time](#method-1-editing-the-deployment-file-in-real-time)
    - [Method 2: Apply a modified deployment file](#method-2-apply-a-modified-deployment-file)
    - [Method 3: Use the scale command](#method-3-use-the-scale-command)
  - [Delete K8s deployments and services](#delete-k8s-deployments-and-services)
  - [K8s deployment of NodeJS Sparta test app](#k8s-deployment-of-nodejs-sparta-test-app)
  - [**Blockers**](#blockers)
- [Day 2 Tasks](#day-2-tasks)
  - [Create 2-tier deployment with a PersistentVolume (PV) for the database](#create-2-tier-deployment-with-a-persistentvolume-pv-for-the-database)
  - [Use Horizontal Pod Autoscaler (HPA) to scale the app](#use-horizontal-pod-autoscaler-hpa-to-scale-the-app)
  - [Extension task: Remove PVC and retain data in Persistent Volume](#extension-task-remove-pvc-and-retain-data-in-persistent-volume)
  - [**Blockers**](#blockers-1)
- [Day 3 Tasks](#day-3-tasks)
  - [Setup minikube on a cloud instance running Ubuntu 22.04 LTS](#setup-minikube-on-a-cloud-instance-running-ubuntu-2204-lts)
  - [Deploy on three apps on one cloud instance running minikube](#deploy-on-three-apps-on-one-cloud-instance-running-minikube)
  - [Use Kubernetes to deploy the Sparta test app in the cloud](#use-kubernetes-to-deploy-the-sparta-test-app-in-the-cloud)
  - [**Blockers**](#blockers-2)
- [What I learnt](#what-i-learnt)
- [Benefits I personally saw from the project](#benefits-i-personally-saw-from-the-project)

## Goal of this project

This goal of this project is to containerise the deployment of the Sparta test app (which uses Node JS v20) and database using Kubernetes.

## Prerequisites

1. Docker Desktop
2. Docker Hub container image for Sparta test app

# **Research**

## Kubernetes

- **Kubernetes (or K8s)**: an open-source container orchestration system that automates the deployment, scaling, and management of apps running in containers
- It can automate:
  - starting new apps when needed
  - restarting apps if they crash
  - spreading out work so that no one part of the system is overloaded
  - scaling up or down based on demand
- **Pod**: one or more containers that share resources and work together to run an app; usually represents a single instance of a runnign app; smallest deployable unit in K8s
- **Service**: an entity representing a logical set of Pods running an app; defines a policy for how to access these  by routing external & iinternal traffic to the correct Pods; it abstracts away IP changes so apps can be consistently accessed 
- **Node**: a worker node; a physical or virtual machine that will host and run your Pods; offer the computational and storage resources needed to run these Pods
- **Namespaces**: logical partitions within a cluster that help organise and manage resources; allow you to apply policies, access controls, & resource quotas on a granular level
  - Benefits of namespaces:
    - helpful when you need to **group related workloads** (e.g. by team or environment)
    - **enhance security** and access control by restrictiing which users can view/modify resources in a namespace
    - **simplify resource management** by effectively applying limits, network policies & other cluster-wide configs
- **`kube-system`**: the namespace where Kubernetes components live; holds system-level components like CoreDNS and `kube-dns`
- **`default` or custom namespaces e.g. `dev`**: namespaces where our apps live
- **Replica**: identical Pods running within a cluster at the same time for high availability and scaling; they are managed by a **ReplicaSet**, which creates new replicated pods if one fails
- **Cluster**: a Kubernetes environment, which includes one or more nodes; has two elements:
  - **Control Plane or master/control node**: master node; the centralised brain of a cluster; governs and coordinates the cluster's operations, schedules new containers onto nodes, monitors the cluster's health, and provides an API that we interact with
  - **Data plane**: made up of worker nodes and their pods; carries out the policies set on the Control Plane
**- Parts of the Control Plane (non-exhaustive):**
  - **kube-apiserver:** essentially the cluster's front door; the part of the Control Plane that allows us to interact with a running K8s cluster; all administrative commands & resource requests pass thru this
  - **etcd**: stores all config data and the current state of the cluster
  - **kube-controller-manager:** starts and runs K8s's built-in controllers; continually adjusts the cluster's state to ensure it matches the desired state; creates, scales, & deletes objects in response to API requests or load changes
  - **kube-scheduler:** assigns new Pods (i.e. containers) onto the nodes in a cluster based on resource requirements, constraints, & policies
**- Parts of the data plane (i.e. worker nodes):**
  - **kubelet:** the administrative agent that runs on each node; it communicates with the Control Plane to receive instructions; ensures Pods are running and reports their statuses to Control Plane responsible for pulling container images and starting them in response to scheduling requests
  - **kube-proxy:** configures host's networking system on each node in a cluster so that traffic can reach the cluster's services 
  - **container runtime**: software that runs & manages containers (e.g. Docker or containerd); creates and manages containerised apps within Pods
- **Deployment:**
- **kubectl**: the CLI used to interact with clusters
- **Minikube**: a tool that creates a local K8s environment so you can learn and test K8s deployments 

![alt text](image-2.png)
![namespaces diagram](image-3.png)

### Lifecycle

1. When a new app is deployed, the Control Plane places the Pods on appropriate Nodes
2. the kubelet on each Node ensures the Pods are healthy and running as instructed
3. Services route traffic to the correct Pods, allowing clients to access apps

### Benefits of Kubernetes

- 

- Why is Kubernetes needed

· Benefits of Kubernetes

· Success stories

· Kubernetes architecture (include a diagram)

· The cluster setup

o What is a cluster

o Master vs worker nodes

o Pros and cons of using managed service vs launching your own

o Control plane vs data plane

· Kubernetes objects

o Research the most common ones, e.g. Deployments, ReplicaSets, Pods

o What does it mean a pod is "ephemeral"

· How to mitigate security concerns with containers

· Maintained images

o What are they

o Pros and cons of using maintained images for your base container images

· Research and document the types of autoscaling available with K8s

# Day 1 Tasks

## Get Kubernetes running using Docker Desktop

1. I ran `kubectl get service` and got this expected error ![alt text](image-1.png)
2. To solve this, I enabled Kubernetes in Docker Desktop ![alt text](image-4.png)
3. Successfully re-ran `kubectl get service` ![alt text](image-5.png)

## Create Nginx deployment only

1. Created YAML file (link)
2. Ran `kubectl apply -f nginx-deploy.yml` to create the deployment ![alt text](image-6.png)
3. Ran `kubectl get deployment nginx-deployment` to get details on the deployment ![alt text](image-10.png)
4. Ran `kubectl get replicaset` to get details on the replicasets ![alt text](image-11.png)
5. Ran `kubectl get pods` to get details on the pods ![alt text](image-12.png)
6. Ran `kubectl get all -l app=nginx` to see details on all three with one command ![alt text](image-13.png)
7. Tried to access my deployment via my web browser at localhost and ClusterIP but this didn't work (as expected), because the ClusterIP is a private IP address only accessible within the cluster

## Get a NodePort service running

1. Created yaml file
2. Created the service with `kubectl apply -f nginx-service.yml` ![alt text](image-14.png)
3. Ran `kubectl get svc nginx-svc` to get details on the service ![alt text](image-15.png)
4. On my web browser, navigated to localhost:30001 to verify the NodePort service was running ![alt text](image-16.png) 

## See what happens when we delete a pod

1. Ran `kubectl get pods` to list the pods ![alt text](image-17.png)
2. Ran `kubectl delete pod nginx-deployment-68d98fd8fc-2j8ht` to delete one of the pods (in this case, the first pod) in the above list ![alt text](image-18.png)
3. Re-ran `kubectl get pods` and saw that Kubernetes had automatically recreated a pod to satisfy the requirements in my deployment file ![alt text](image-19.png)
4. Ran `kubectl get pods --sort-by=.metadata.creationTimestamp` to get a list of pods by their time of creation ![alt text](image-20.png)
5. Ran `kubectl describe pod nginx-deployment-68d98fd8fc-4pbt2` to get detailed information on the newest pod
6. Automated this process with:
   1. Running `kubectl get pods --sort-by=.metadata.creationTimestamp -o jsonpath='{.items[-1].metadata.name}'` to get the name of the latest pod only (this is done by limiting the list via `items[-]` and extracting the name via `metadata.name`) ![alt text](image-21.png)
   2. Running `kubectl describe pod $(kubectl get pods --sort-by=.metadata.creationTimestamp -o jsonpath='{.items[-1].metadata.name}')` to get details on the newest pod -- this command uses the output of the above command as a variable) ![alt text](image-22.png)

## Increase replicas with no downtime

- We want to be able to increase the number of replicas (pods) in our deployment in real-time, without needing to destroy and re-create our deployment

### Method 1: editing the deployment file in real-time

1. Ran `kubectl edit deployment nginx-deployment` -- this opened up an editable version of the in-use deployment file in Notepad, so I changed th e number of replicas to 4, saved (*Ctrl-S*), and exited the file ![alt text](image-23.png) 
2. I then ran `kubectl get pods` again and verified that there were now 4 pods running ![alt text](image-24.png)

### Method 2: Apply a modified deployment file

1. Edited the *nginx-deploy.yml* file to change the number of replicas to 5
2. Applied the updated file by running `kubectl apply -f nginx-deploy.yml` again
3. Ran `kubectl get pods` again to verify that there were now 5 pods running ![alt text](image-25.png)

### Method 3: Use the scale command

1. I ran `kubectl scale deployment nginx-deployment --replicas=6` to scale this deployment by 1 more replica ![alt text](image-26.png)
2. Ran `kubectl get pods` again to verify that there were now 6 pods running ![alt text](image-27.png)

## Delete K8s deployments and services

1. Ran `kubectl delete -f nginx-deployment.yml` and `kubectl delete -f nginx-service.yml` to delete the Nginx deployment and service ![alt text](image-28.png)
2. Ran `kubectl get all` to verify that they (and the ReplicaSets and pods) were deleted ![alt text](image-29.png)

## K8s deployment of NodeJS Sparta test app

**ADD DIAGRAM HERE**

1. Created [*app-deploy.yml*](k8s-yaml-definitions/local-nodesj20-app-deploy/app-deploy.yml) and [*app-service.yml*](k8s-yaml-definitions/local-nodesj20-app-deploy/app-service.yml) files
2. Ran`kubectl apply -f app-deploy.yml` and `kubectl apply -f app-service.yml` to create these resources based on the above files
3. Navigated to *localhost:30002* (the port specified in my *app-service.yml* file) to verify that this was successful ![alt text](image-30.png)
4. Created [*mongodb-service.yml*](k8s-yaml-definitions/local-nodejs20-app-deploy/local-mongodb-deploy/mongodb-service.yml) and [*mongodb-deploy.yml*](k8s-yaml-definitions/local-nodejs20-app-deploy/local-mongodb-deploy/mongodb-deploy.yml) files 
5. Ran `kubectl apply -f mongodb-deploy.yml` and `kubectl apply -f mongodb-service.yml` to create these resources based on the above files ![alt text](image-31.png)
6. Navigated to *localhost:30002/posts* to verify the deployment and database connection was successful ![alt text](image-32.png)

## **Blockers**

1. I had issues enabling Kubernetes with Docker Desktop as it hung on "Starting Kubernetes" for a long time; this seemed to be solved by manually installing Kubernetes via Chocolatey and then enabling Kubernetes again via Docker Desktop
2. After having to restart my laptop, I created the deployments again, but my posts page wasn't seeded (though I didn't receive any errors) -- I thought this might have been because either of my pods or services hadn't been fully initialised before the connection was made, so I resolved this by running `kubectl rollout restart deployment sparta-app-deployment` to restart the app deployment -- this worked (note the new record, indicating a re-seeding has taken place) ![alt text](image-33.png)

# Day 2 Tasks

## Create 2-tier deployment with a PersistentVolume (PV) for the database

- using a PersistentVolume ensures the data will be retained even if the MongoDB pod restarts
- a PersistentVolumeClaim (PVC) requests a certain amount storage form the PV for a Pod

1. Created a mongo-pv.yml and a mongo-pvc.yml file (link)
2. Created the PV with `kubectl apply -f mongo-pv.yml`
3. Created the PVC with `kubectl apply -f mongo-pv.yml` 
4. Verified they were both created successfully ![alt text](image-35.png)
- For reference, this is what my *localhost:30002/posts* page looked like at this point ![alt text](image-39.png)
5. Deleted my database deployment with `kubectl delete deployment mongo-deployment` ![alt text](image-37.png)
6. Verified that my *posts* page no longer worked ![alt text](image-41.png)
7. Recreated it with `kubectl apply -f mongo-deploy.yml` and visited *localhost:30002/posts* again to verify that the records were still the same ![alt text](image-40.png)




**Diagram your Kubernetes architecture with the PV and PVC**
**a. Have logical notes/dot points on your diagram, labels**




## Use Horizontal Pod Autoscaler (HPA) to scale the app

1. 
  
## Extension task: Remove PVC and retain data in Persistent Volume

1. 

## **Blockers**

1. 

# Day 3 Tasks 

## Setup minikube on a cloud instance running Ubuntu 22.04 LTS

1. 
  
- for reverse proxy here(?), use minikube's IP address

## Deploy on three apps on one cloud instance running minikube

1. 
  
## Use Kubernetes to deploy the Sparta test app in the cloud

1. 
  
## **Blockers**

1. 

# What I learnt

- 

# Benefits I personally saw from the project

- 