# Requirements

- NodeJS 8+
- Docker
- Minikube

# Instructions


## Build docker image

You can build your own Docker image, as an example we will be using my
repository: `spothound/web_app`.

```
docker build -t <your_user>/web_app
docker push <your_user>/web_app
```

## Deploy to K8s with minikube

Notice: to use a custom image you must change the reference in the `deployment.yaml` file

```
cd kubernetes
kubectl apply -f deployment.yaml
minikube service nodejs-service
```
