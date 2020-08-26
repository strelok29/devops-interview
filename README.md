# Emoji Search (Container Version)


## Description

This `bash` script is a tool to automatically build a local Kubernetes cluster based on the Docker file and kubernetes `.yaml` template

**NOTE :** Please make sure your docker service and minikube already running

## How to Use


Before running the script, make the script executables by using `chmod +x .\auto_docker.sh`

and then run `.\auto-docker.sh`

**NOTE :** Please make sure your docker hub account is on public, the script won't work 

After you run the script, you will be prompt a few questions and will be used as the docker image and kubernetes settings.

- Container name
- How many pods you want to build
- You Docker ID and Password
- The port of the pods
- Container label

## How to access the application

To access the application first, you must check the minikube IP address using `minikube ip`
command and use the IP in the web browser to access the website


## How the `bash` script works

After you run the script, first the Docker image will be build based on the Dockerfile and will be named based on the user input.

---
#### Dockerfile description
This section will be tried to explain the flow of this project Dockerfile

First step of the Dockerfile is to make the production version of the application:
- Dockerfile will download `node:12.16.3-alpine` as the based image and will be labeled as `builder`
- Dockerfile will create `/app` folder inside of the image as the working directory
- The `package.json` will be copied to the inside of the image
- The image will run `npm install` to install the dependencies
- All of the files will be copied to the inside of the `/app` in the image
- The Dockerfile will run `npm run build` to make the production version of the application and will create `/build` folder

The second step of the Dockerfile is to add `Nginx` and use it as the webserver.

- Dockerfile will download the latest `Nginx` image as the based image
- This image will expose port `3000`, so it can be accessible
- Our version of `default.conf` that already created before will be copied to replace the existing `/etc/nginx/conf.d/default.conf` inside of the image
- And last, the `/build` folder that are created after the Dockerfile run `npm run build` command will be copied to inside of `/usr/share/nginx/html` folder so that it can be accessed later.




---
The docker image that already builds will be uploaded to docker hub using the user credential that inputted before.

The script will create a new `.yaml` files based on the template and added a new setting to it based on the user input.

There is 3 different `.yaml` files in this project:
- `deployment.yaml` will create the basic need to create the pods based on the image.
- `cluster-ip-service.yaml` will create a connector between the pods and the node.
- `ingress.yaml` will publish the node, so it can be accessible from the outside.



Last thing, the new `.yaml` files will be run and create a new Kubernetes cluster






