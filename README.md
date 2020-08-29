# kubernetes-cluster
Kubernetes cluster with 2 environments running NGINX application

Instalar Minikube
Instalar Kubectl
SSH minikube

Run jenkins setup

Instalar kubernetes plugin jenkins

Fill in the Kubernetes plugin configuration. In order to do that, you will open the Jenkins UI and navigate to Manage Jenkins -> Configure System -> Cloud -> Kubernetes and enter in the Kubernetes URL and Jenkins URL appropriately, this is unless Jenkins is running in Kubernetes in which case the defaults work.

Instalar Docker Pipeline Plugin

kubectl create clusterrolebinding permissive-binding --clusterrole=cluster-admin --user=admin --user=kubelet -n jenkins --user=system:serviceaccount:jenkins --group=system:serviceaccounts:jenkins --serviceaccount=jenkins:jenkins