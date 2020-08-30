# kubernetes-cluster
Kubernetes cluster with 2 environments running NGINX application

## Pre installation
1. Install Minikube according to your SO - Follow the instructions here
2. Start Minikube with `minikube start --drive=<YOUR DRIVE>`
3. Install Kubectl according to your SO - Follow the instructions here
4. Clone this repository

## Jenkins Setup
The "Hello World" application is built and deployed through Jenkins. It is only necessary to deploy and run Jenkins, everything (besides Kubernetes API Server credentials) is configured as code.

### Build & Deploy
Run `Jenkins/jenkins-setup.sh` script and wait it to complete. It is recommended to run it on a Linux terminal.
Kubernetes API Server Credentials will be printed at the end.

#### Jenkins access
You can access Jenkins at `http://<MINIKUBE URL>:30001`.
To discover your minikube ip you can run `minikube ip`
```
user: admin
password: admin
```

#### Configuring Kubernetes API Server Credentials
This credentials allows Jenkins to comunicate with the Kubernetes cluster and deploy artifacts.

The `jenkins-setup.sh` script will print the same credentials in two versions: `base 64 encoded` and `decoded`. 
> You will only need the encoded version of the credentials to manually decode in case you have problems printing and copying the decoded version.

1. Log in to Jenkins
2. Go to *Manage Jenkins > Manage Credentials > Credentials > Jenkins > Global credentials (unrestricted) > k8sCredentials*. The URL should look like this: `http://<MINIKUBE URL>:30001/credentials/store/system/domain/_/credential/k8sCredentials/update`
3. Click at the *Update* icon at the right
4. Click in Change Password 
5. Paste the **decoded** credentials provided before and save

## Application
The application is a nginx image running a Hello World page.

### Build & Deploy
In the Jenkins page, select the **hello-world** pipeline job.

1. Click *Build with Parameters*
2. Everything is already configured, you should only **chose the environment**

Development application is deployed at `http://<MINIKUBE URL>:30003`
Production application is deployed at `http://<MINIKUBE URL>:31003`


##Technical Debts
This project was developed in 2 days due to deadline limitations. Given this, some features and configurations were not included.

- Jenkins was not configured to change the deployment yaml file. If a new image version is released, the yaml file must be changed manually.
- In order to allow Jenkins to communicate with Kubernetes API, a generic CluterRoleBinding with admin powers was created. This is not recommended to use in production and the permissions must be exactly what Jenkins need.
- All images that are built locally are not being pushed to any repository.
- No resource request or limitation was calculated for any of the kubernetes deployments. This configuration is not set.
- In order to start Jenkins with the pipeline and variables already configured, the original docker image entrypoint was overwritten in the jenkins deployment. This does not affect anything, but it is understood this is not best practice.
- All application are being exposed through nodePort. An ingress (e.g. traefik) should be used to expose the application.
- No further configuration was made to Minikube or Kubernetes Cluster.


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