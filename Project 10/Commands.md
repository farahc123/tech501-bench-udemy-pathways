# Commands

- [Commands](#commands)
  - [Kubectl query commands](#kubectl-query-commands)
  - [Kubectl action commands](#kubectl-action-commands)
  - [HPA-related commands](#hpa-related-commands)
  - [Rollout (i.e. updating running resources) commands](#rollout-ie-updating-running-resources-commands)
  - [Minikube-related commands](#minikube-related-commands)

## Kubectl query commands

- `kubectl version` -- prints the version of kubectl currently installed
- `kubectl cluster-info` -- verifies the control plane is running
- `kubectl get namespaces` -- lists all namespaces in the cluster
- `kubectl get nodes` -- lists all nodes in the cluster (e.g. for Minikube, there will only be one)
  - `kubectl get nodes -o wide` -- lists the nodes with more detail (note that this command format can be used for all resource types)
  - `kubectl describe node <node name>` -- outputs full details about the given node (note that this command format can be used for all resource types); the `Events` section is useful when troubleshooting
  - `kubectl describe nodes <cluster name>` -- describes all of the nodes in the given cluster (e.g. `minikube`)
- `kubectl get services` -- lists all services in a cluster
- `kubectl get deployments` -- lists all deployments in a cluster
  - `kubectl get deployment <deployment name>` -- lists details about the given deployment (note that this command format can be used for all resource types)
  - `kubectl get deployments -n <name of namespace>` -- lists the deployments in a given namespace (note that this command format can be used for all resource types)
  - `kubectl get deployments -A` -- lists all deployments across all namespaces (note that this command format can be used for all resource types)
  - `kubectl get deployment <deployment name> -o yaml` -- outputs the configuration defined in the deployment's YAML file as well as other details (note that this command format can be used for all resource types)
  - `kubectl get deployment <deployment name> -o json` -- outputs the above but in machine-readable JSON format
- `kubectl get pods` -- lists the pods in the current namespace
- `kubectl get replicasets` -- lists all replicasets in a cluster
- `kubectl get all` -- lists all resource types (e.g. pods, services, & deployments) in the `default` namespace
  - `kubectl get all -A` -- lists all resources across all namespaces 
  - `kubectl get all -l <label selector key=label selector value as defined in yaml file>` -- lists details on the resources matching the key=value set in the command
- `kubectl config current-context` -- tells you what context you're connected to
- `kubectl logs <resource name>` -- outputs logs for a given resource
  - `kubectl logs -f <resource name>` -- allows you to follow a resource's logs in real-time
  - `kubectl logs <pod name> -c <container name>` -- outputs logs for a given container in a given pod
- `kubectl get events` -- lists all cluster-wide events
  - `kubectl get events -w` -- outputs all cluster-wide events in real-time
  - `kubectl get events --field-selector type=Warning` -- useful for debugging; lists all events matching the type "Warning"
- `kubectl get endpoints` -- lists the pod IP addresses and the ports attached to each running service
- `kubectl get ingress` -- lists details on existing ingresses

## Kubectl action commands

- `kubectl apply -f <YAML filename or URL>` -- idempotent means of creating a Kubernetes object based on the specifications defined in the given YAML file (`-f` standing for file); if using a URL, it will download the file first then apply it; if you run this command multiple times on the same YAML file, it will only make any specified changes 
  - `kubectl apply -f .` -- creates all of the Kubernetes objects defined in all of the YAML files in the current directory
  - `kubectl apply -f <YAML file name> --dry-run=client` -- won't actually create the resources, but lets you see if there are any errors in it as well as what *would* be created
  - `kubectl apply -f <YAML file name> -v=<verbosity level e.g. 7>` -- applies a manifest file and outputs more detail
- ` kubectl create <resource> <options>` -- creates a resource imperatively; running this command to create a resource that already exists will result in an error; different to `kubectl apply` which is based on a declarative manifest file; less flexible for managing updates & changes; e.g. `kubectl create deployment web --image=nginx:latest`
- `kubectl expose deployment <deployment name> --port=<port number e.g. 80> --type=<type e.g. ClusterIP; different types may need more parameters defined> --name=<name of service>` -- creates a service exposing a deployment in a single command (i.e. without a manifest YAML file) e.g. `kubectl expose frontend-deployment --port=80 --type=ClusterIP --name=frontend-service`
- ` kubectl run <pod name> --image=<image name:tag>` -- e.g. creates a pod in a single command from the given image, e.g. `kubectl run nginx --image=nginx`
- `kubectl scale deployment <deployment name> --replicas=<number of desired replicas>` -- a quick, temporary way of scaling an existing deployment up or down (note that scaling to 0 essentially "deletes" all pods without deleting the deployment)
- `kubectl delete <resource type> <resource name>` -- deletes the given resource
  - `kubectl delete <resource type> -l <label key>=<label value>` -- deletes resources matching the given label
- `kubectl delete -f <YAML filename>` -- deletes all the resources defined in a given YAML file
- `kubectl proxy --port=<given port>` -- useful for debugging & development; creates a secure, authenticated connection to the K8s API server that allows you to access your resources/apps from your local machine via a URL without actually needing to expose them externally; the path for all pods in the `default` namespace is *http://localhost:<port>/api/v1/namespaces/default/pods/* (which, when `curl`ed, will provide output in JSON format) and *http://localhost:<port>/api/v1<or other version>/namespaces/<namespace>/pods/<pod_name>/proxy/* to view the app running on a specific pod
- `kubectl exec <pod name> -- <command to be run>` -- runs a given command in a pod
- `kubectl exec -it <pod name> -- /bin/bash` -- runs an interactive shell in the given pod using the above shell type (which can be changed)
- `kubectl label pods <pod name> <label name>=<label value>` -- applies a key-value pair as a label to a given pod 
- `kubectl label pods <pod name> <label name>-` -- removes the given label (note the minus symbol after the label name) from a given pod
- 

## HPA-related commands

- `kubectl get hpa`


## Rollout (i.e. updating running resources) commands

- Rollout commands ensure zero-downtime updates

- `kubectl rollout status deployment <deployment name>` -- -- gives you the status of rollouts (i.e. updates) to a deployment (can also be used on DaemonSets and StatefulSets)
- `kubectl rollout restart deployment <deployment name>` -- stops the current rollout and restarts it (useful if more changes have been made during the original rollout)
- `kubectl rollout undo deployment <deployment name>` -- undoes the last rollout of a deployment, i.e. reverts to the previous revision (this is a form of K8s version control)
  - `kubectl rollout undo deployment <deployment name --to-revision=<revision number>` -- reverts a deployment to the given rollout/revision number
- `kubectl rollout pause deployment <deployment name>` -- pauses a rollout of a deployment
- `kubectl rollout resume deployment <deployment name>` -- resumes the rollout of a deployment
- `kubectl rollout history deployment <deployment name>` -- lists past deployment rollouts and their details



## Minikube-related commands

- `minikube start` -- starts a local K8s cluster by downloading the necessary components and configuring the cluster; after starting this, `kubectl` commands will be referring to this cluster
  - `minikube start --driver=docker`
- `minikube stop`
- `minikube delete`
- `minikube status` -- tells you the status of the host, kubelet, apiserver, and kubeconfig (e.g. Running, Configured, Stopped, or if there are errors)
- `minikube addons enable <addon name>` -- enables a Minikube add-on