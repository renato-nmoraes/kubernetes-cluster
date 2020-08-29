pipeline {
    agent any
    stages {
        stage('Building image') {
            steps {
                git branch: 'work1', url: 'https://github.com/renato-nmoraes/kubernetes-cluster.git'
                dir('app'){
                    sh "ls -lar"
                    script{
                        fullDockerImageName = "hello-world" + ":" + "1.0"
                        dockerImage = docker.build fullDockerImageName
                    }
                }
            }
        } 
        stage('List pods') {
            steps{
                dir('app/base'){
                    withKubeConfig([credentialsId: '${CREDENTIALS}',
                            serverUrl: 'http://localhost:8090/'
                            ]) {
                        sh 'ls -lar'
                        sh 'kubectl apply -k .'
                    }
                }
            }
        }    
    }
}