# Commands

- [Commands](#commands)
  - [Cluster commands](#cluster-commands)
  - [HPA-related commands](#hpa-related-commands)
  - [Minikube-related commands](#minikube-related-commands)

## Cluster commands

- `kubectl version` -- prints the version of kubectl currently installed
- `kubectl cluster-info` -- verifies the control plane is running
- `kubectl get nodes` -- lists the nodes in a cluster
- `kubectl get nodes -o wide` -- checks if nodes are ready/not ready
- `kubectl describe node minikube` --  
- `kubectl get pods -A` -- lists pods across all namespaces
- `kubectl get pods` -- lists the pods in the current namespace
- `kubectl describe replicaset <replicaset name>` -- lists information on the given replicaset
- `kubectl get deployment <deployment name>` -- lists details about the given deployment
- `kubectl get deployments -A` -- lists all deployments across all namespaces
- `kubectl get all -A` -- lists all resources across all namespaces (e.g. pods, services, & deployments)
- `kubectl get all -l <label selector key=label selector value as defined in yaml file>` -- lists details on the resources matching the key=value set in the command
- `kubectl apply -f <yaml filename>` -- creates deployment/service/etc based on the specifications defined in the given YAML file (`-f` standing for file)
- `kubectl get replicaset`
- `kubectl scale deployment <deployment name> --replicas=<number of desired replicas>`
- `kubectl rollout restart deployment <deployment name>`
- `kubectl delete deployment <deployment name>`

## HPA-related commands

- `kubectl get hpa`

## Minikube-related commands

- `minikube start --driver=docker`
- `minikube delete`