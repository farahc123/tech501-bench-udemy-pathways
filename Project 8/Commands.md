# Docker commands

- [Docker commands](#docker-commands)
  - [docker run options](#docker-run-options)
  - [General commands](#general-commands)
  - [Dockerfile commands](#dockerfile-commands)
  - [Network-related commands](#network-related-commands)
  - [Logs](#logs)


## docker run options

- `docker run <image name>` — tells Docker to create and run a new container from the given image:
  1. Docker first checks if the *hello-world* image is available locally
  2. If not, it automatically downloads (or "pulls") the image from Docker Hub (it now stays on the system so doesn't need to be pulled from Docker Hub again)
  3. Docker creates a new container based on this image
  4. The container runs, displays a message, and then exits
- example`docker run -d -p 80:80 docker/getting-started` or `docker run -dp 80:80 docker/getting-started`
      - `-d` — runs the container in detached mode (i.e. **in the background**); commonly done
      - `-p 80:80` — maps port 80 of the local host to port 80 in the container
 - you can  run a command inside a container like `docker run <options> <image-name> <command> <arguments>`
![`alt text`](images/image-1.png)
- `docker run -d --restart <restart policy> <image>` -- sets the restart policy to 'unless stopped' which is when it has been explicitly stopped by the user
- **Restart policies** include:
   - ***on-failure***: restart only if the container exits with a non-zero status
   - ***always***: always restart the container regardless of the exit status
   - verifying restart policy: `docker inspect -f '{{.HostConfig.RestartPolicy.Name}}' <container name>`
- `docker run --name <optional container name> <image name>` -- runs a new container with the given name; if this option isn't used, the container will be randomly named
- `docker run -e <env var name>="<value>"` -- runs a new container and sets an environment variable
- `docker run --memory=512m --cpus=0.5 <image name>` -- limits the resources a container can use; useful when you need to manage container resources e.g. in multi-container environments
  - `--memory=512m`: limits the container to 512 megabytes of memory
  - `--cpus=0.5`: limits the container to use at most half of a CPU core

## General commands

- `docker images` — shows all images available on local system; includes the name, tag, image ID, when it was created, and size
  - `docker images <name>` — shows all images matching the given name
- `docker pull <image name:optional tag/version>` — pulls given image and tag (i.e. version) from Docker Hub
- `docker push <image name><:optional tag>` — pushes local image to my Docker Hub account (image needs to be tagged first)
- `docker ps` — shows all of the Docker containers currently running
  - `-a` — shows all Docker containers, whether running or not
  - `-q` — shows hidden containers that are running; outputs only the container IDs (`-aq` to show all hidden) 
  - can be combined with `| grep <expression to be searched>` or `docker ps --filter "<variable e.g. name>=<given value>"` to filter running containers by a specific name
- `docker start [container name or ID>` -- starts a pre-existing container that has been stopped 
- `docker stop <container name or ID>` -- gracefully stops given container
-  `docker restart <container name or ID>` -- restarts given container
- `docker rm <container name or ID>` -- removes stopped container, meaning it will be removed even from `docker ps -a`
- `docker rmi <image name>` — removes given image from local system
- `docker search <image name e.g. nginx>` — searches Docker Hub for given image; outputs:
  - **name** of image
  - a brief **description** of the image
  - the number of **stars** the image has on Docker Hub (indicating popularity)
  - whether it is an **official image** maintained by Docker
  - **automated**: whether it is automatically built from a GitHub repository
![`alt text`](images/image-2.png)
- `docker save -o <image name> > <filename to be saved to>` — saves given image as ***.tar* file** to be loaded later; helpful when trasferring images to a system without internet access, sharing images outside of a registry, or for backing up
- `docker load -i < <tar file name e.g. nginx.tar>` — reloads a deleted image back from its *tar* filename
- `docker tag <source image:tag> <optional Docker Hub username>/<image name:tag>` — creates a new tag for an image version, optionally tagged to your Docker Hub account
- `docker exec <container> <command>` — runs given command in given already-running container, e.g.:
  - `docker exec <container name> env` outputs the environment variables from the given container
  - `docker exec -it <container> sh` adds interactive option `-it` to log in to the shell of the given container so that commands can be run as normal
- `docker commit <container> <repo:tag>` — creates an image from an existing container
- `docker create <image>` — creates a new container from the given image
- `docker history <image name>` outputs history of image layers and their sizes
- `docker cp <file name on host machine> <container name>:<path on container to be copied to>` -- copies a file from host machine to docker container
`docker stats <container name>` -- outputs a live stream of resource usage statistics for given container

## Dockerfile commands

- `docker build -t <image name to be tagged> <image path or . if the dockerfile is in the current directory>` — builds an image from a Dockerfile; when making changes to a Dockerfile, you must rebuild the image to put these changes into action
  - e.g. `docker build -t tech501-nginx-auto:v1`

## Network-related commands

- `docker network create <network name>` — creates a bridge network between containers
  - Bridge networks are the most common network type in Docker
  - Containers on the same network can communicate with each other using their container names as hostnames, making it easy to link services together
- `docker run -d --name <custom container name> --network <already created network name> <image>` -- the `--network` parameter in docker run allows you to connect a container to an existing network, which is useful for container-to-container communication and for isolating groups of containers

## Logs
- `docker logs <container name>` -- prints a container's logs
  - `-f` -- allows you to follow logs in real time
- `docker logs --timestamps <container name>` -- prints logs with timestamps
