# kubernetes-cluster
Kubernetes cluster with 2 environments running NGINX application

Instalar Minikube
Instalar Kubectl
SSH minikube

Jenkins Setup
	Build Jenkins locally - 
	eval $(minikube docker-env)
	cd jenkinsDir
	docker build
	Deploy jenkins
	#######  CONFIG???  #######

Instalar kubernetes cli jenkins

Instalar Docker Pipeline Plugin

kubectl create clusterrolebinding permissive-binding --clusterrole=cluster-admin --user=admin --user=kubelet -n jenkins --user=system:serviceaccount:jenkins --group=system:serviceaccounts:jenkins --serviceaccount=jenkins:jenkins

eval $(minikube docker-env)

Para acessar:
minikube ip

Dev:
3000x

PRD:
4000x

Debitos:
Yaml de deploy nao é dinamico
rolebinding generico