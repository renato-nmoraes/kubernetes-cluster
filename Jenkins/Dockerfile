from jenkins/jenkins:2.235.5-lts-centos7

USER root

RUN groupadd -g 1500 docker && usermod -aG docker jenkins

RUN yum update -y \
    && yum install -y yum-utils device-mapper-persistent-data lvm2

RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
RUN yum-config-manager --add-repo https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64

RUN printf '[kubernetes] \nname=Kubernetes \nbaseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64 \nenabled=1 \ngpgcheck=1 \nrepo_gpgcheck=1 \ngpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg \n'\ 
> /etc/yum.repos.d/kubernetes.repo

RUN cat /etc/yum.repos.d/kubernetes.repo

RUN yum install -y docker-ce-cli-18.09.1
RUN yum install -y kubectl

USER jenkins