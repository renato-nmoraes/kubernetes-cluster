pipeline {
    agent any
    stages {
        stage('Building image') {
            steps {
                git branch: '${GIT_BRANCH}', url: '${GIT_URL}'
                dir('app'){
                    sh "ls -lar"
                    script{
                        fullDockerImageName = "${IMAGE_NAME}" + ":" + "${IMAGE_TAG}"
                        dockerImage = docker.build fullDockerImageName
                    }
                }
            }
        } 
        stage('List pods') {
            steps{
                dir('app/overlay/${DEPLOY_ENV}'){
                    withKubeConfig([credentialsId: '${CREDENTIALS}',
                            serverUrl: '${K8S_APISERVER}'
                            ]) {
                        sh 'ls -lar'
                        sh 'kubectl apply -k .'
                    }
                }
            }
        }    
    }
}