#!/bin/sh

kctl() {
    kubectl --namespace "$NAMESPACE" "$@"
}

setup(){
    printf "\n Building Jenkins Docker Image... \n"
    eval $(minikube docker-env)
    docker build -t jenkins-docker:1.0

    printf "\n Creating Jenkins namespace... \n"
    kubectl create ns jenkins

    printf "\n Deploying Jenkins... \n"
    kubectl apply -k ./Jenkins

    printf "\n Waiting for Jenkins to get ready (May take several minutes depending on the resources) ...\n "
    until [[ $(kubectl describe pod -n jenkins | awk '/^ *Ready / {print $2}') == "True" ]] 2>&1; do sleep 1; printf "."; done
    printf "\n Jenkins is ready! You can login at http://<YOUR MINIKUBE IP>:30001 - http://$(minikube ip):30001 \n"

    printf "\n Kubernetes API Server Credentials - SAVE THEM SOMEWHERE !!! ... \n"
    saToken = `kubectl get secrets -n jenkins | awk '/jenkins/ {print $1}'`

    printf "\n\n ######################## \n"
    printf "\n base64 encoded credential ... \n"
    printf "\n ######################## \n"
    `kubectl get secrets -n jenkins ${saToken} -o yaml | awk '/token:/ {print $2}' | awk 'NR==1 {print $0}'`

    printf "\n\n ######################## \n"
    printf "\n decoded credential: \n"
    printf "\n ######################## \n"
    `kubectl get secrets -n jenkins ${saToken} -o yaml | awk '/token:/ {print $2}' | awk 'NR==1 {print $0}' | base64 -d`
}
setup