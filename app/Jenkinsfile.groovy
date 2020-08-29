podTemplate(containers: [
    containerTemplate(name: 'kubectl', image: 'bitnami/kubectl', ttyEnabled: true, command: 'cat'),
  ]) {

    node(POD_LABEL) {
        stage('Building image') {
            steps{
                dir("app"){
                    script {
                        fullDockerImageName = "hello-world" + ":" + "1.0"
                        dockerImage = docker.build fullDockerImageName
                    }
                }
            }
        }
        stage('Deploy') {
            git url: 'https://github.com/renato-nmoraes/kubernetes-cluster.git'
            dir("app"){
                container('kubectl') {
                    stage('Build a Go project') {
                        sh """
                        mkdir -p /go/src/github.com/hashicorp
                        ln -s `pwd` /go/src/github.com/hashicorp/terraform
                        cd /go/src/github.com/hashicorp/terraform && make core-dev
                        """
                    }
                }
            }
        }
    }
}