# kubernetes-cluster
Minikube Kubernetes cluster with 2 environments running NGINX application deployed by Jenkins.

## Requisites

- A running minikube cluster with kubectl
- Linux shell to run .sh script

## Pre-installation
1. Install Minikube according to your Operational System - Follow the instructions [here](https://kubernetes.io/docs/tasks/tools/install-minikube/)
2. Start Minikube with `minikube start --driver=<DRIVE_NAME>`
3. Run `minikube status` to check if Minikube is running correctly.
4. Install Kubectl according to your Operational System - Follow the instructions [here](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
5. Run `kubectl cluster-info` to check if Kubectl is working and connected to Minikube. More information [here](https://kubernetes.io/docs/tasks/tools/install-kubectl/#verifying-kubectl-configuration)
5. Clone this repository

## Installation
To have a running application, it is necessary:
1. Deploy and Setup Jenkins
2. Deploy "Hello World" application through Jenkins

### Jenkins Setup
The "Hello World" application is built and deployed through Jenkins. Everything in Jenkins (besides Kubernetes API Server credentials) is configured as code.

#### Build & Deploy
Run `Jenkins/jenkins-setup.sh` script and wait for it to complete. It is recommended to run it on a Linux terminal.
Kubernetes API Server Credentials will be printed at the end.

#### Jenkins access
After deploying, you can access Jenkins UI at `http://<MINIKUBE URL>:30001`.

To discover your minikube ip you can run `minikube ip`.

The default Jenkins credentials are:
```
user: admin
password: admin
```

#### Configuring Kubernetes API Server Credentials
This credential allows Jenkins to communicate with the Kubernetes cluster and deploy artifacts.

The `jenkins-setup.sh` script prints the same credentials in two versions: `base 64 encoded` and `decoded`. Only the decoded will be used.
> The encoded version of the credentials is only necessary to manually decode it in case of problems with the decoded version.

To apply the K8s API Server credentials to Jenkins, follow the steps:

1. Log in to Jenkins
2. Go to *Manage Jenkins > Manage Credentials > Credentials > Jenkins > Global credentials (unrestricted)* and edit ***k8sCredentials***. The URL should look like this: ``http://<MINIKUBE URL>:30001/credentials/store/system/domain/_/credential/k8sCredentials/update``
3. Click at the *Update* icon at the right
4. Click in Change Password 
5. Paste the **decoded** credentials provided before and save

### Application
After the credentials configuration, Jenkins is ready to build and deploy the application.
The application is a nginx image running a Hello World page.

#### Build & Deploy
In the Jenkins page, select the **hello-world** pipeline job.

1. Click *Build with Parameters*
2. Everything is already configured, you should only **choose the environment**

Development environment application is deployed at `http://<MINIKUBE URL>:30003`

Production environment application is deployed at `http://<MINIKUBE URL>:31003`


## Technical Debts
This project was developed in 2 days due to deadline limitations. Given this, some features and configurations were not included.

- Jenkins was not configured to change the deployment YAML file. If a new image version is released, the YAML file must be changed manually.
- To allow Jenkins to communicate with Kubernetes API, a generic CluterRoleBinding with admin powers was created. This is not recommended to use in production and the permissions must be exactly what Jenkins needs.
- All images that are built locally are not being pushed to any repository.
- No resource request or limitation was calculated for any of the kubernetes deployments. This configuration is not set.
- To start Jenkins with the pipeline and variables already configured, the original docker image entrypoint was overwritten in the Jenkins deployment file. This does not affect anything, but it is understood this is not best practice.
- All applications are being exposed through nodePort. An ingress (e.g. traefik) should be used to expose the application.
- No further configuration was made to Minikube or Kubernetes Cluster.
- The "multiple environment" solution was simply deploying different pods since it's only 1 VM and 1 cluster.	
