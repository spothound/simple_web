# Description

This is a sample nodejs website that attempts to connect with an MQ service and displays its status.

It has the address and port of the MQ service in the `config.js` configuration file.

# Usage

## Run locally
```
npm install
node server.js
```

## Run on Docker instance

You need to forward the 80 port using `-p` flag in order to allow acces to the application using the machine IP.

```
docker build -t simple_web .
docker run -p 80:80 simple_web
```

## Run using KUbernetes

### Requirements
- Active K8s cluster
- Kubectl
- For custom images you will need to push your custom Docker image to a Docker repository and modify the configuration file to apply that change.

You need a K8s cluster active. You can create it using tools like Minikube.

```
kubectl apply -f deployment.yaml
minikube service nodejs-service
```



