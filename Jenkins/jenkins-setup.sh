#!/bin/sh

exit_on_error() {
    exit_code=$1
    last_command=${@:2}
    if [ $exit_code -ne 0 ]; then
        >&2 echo "\"${last_command}\" command failed with exit code ${exit_code}."
        exit $exit_code
    fi
}

setup(){
    printf "\n Building Jenkins Docker Image... \n\n"
    eval $(minikube docker-env)
    docker build -t jenkins-docker:1.0 . 
    exit_on_error $? !!

    echo "#################################################################################"   

    printf "\n Creating Jenkins namespace... \n\n"
    kubectl create ns jenkins
 

    printf "\n Deploying Jenkins... \n\n"
    kubectl apply -k .
    exit_on_error $? !!
    echo "#################################################################################"   

    printf "\n Waiting for Jenkins to get ready (May take several minutes depending on the resources. Seriously, go drink some water) ...\n You can open another Terminal and check it with 'kubectl get pods -n jenkins' \n\n "
    until [[ $(kubectl describe pod -n jenkins | awk '/^ *Ready / {print $2}') == "True" ]] 2>&1; do sleep 1; printf "."; done
    printf "\n Jenkins is ready! You can login at http://<YOUR MINIKUBE IP>:30001 - http://$(minikube ip):30001 \n\n"
    echo "#################################################################################"   

    printf "\n Kubernetes API Server Credentials - SAVE THEM SOMEWHERE !!! ... \n\n"
    saToken=`kubectl get secrets -n jenkins | awk '/jenkins/ {print $1}'`
    exit_on_error $? !!

    printf "\n\n ######################## \n"
    printf "\n base64 encoded credential: \n"
    printf "\n ######################## \n"
    kubectl get secrets -n jenkins ${saToken} -o yaml | awk '/token:/ {print $2}' | awk 'NR==1 {print $0}'
    exit_on_error $? !!
    echo "#################################################################################"  

    printf "\n\n ######################## \n"
    printf "\n decoded credential: \n"
    printf "\n ######################## \n"
    kubectl get secrets -n jenkins ${saToken} -o yaml | awk '/token:/ {print $2}' | awk 'NR==1 {print $0}' | base64 -d
    exit_on_error $? !!
}
setup