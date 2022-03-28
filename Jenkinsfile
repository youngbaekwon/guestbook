pipeline {
  agent any
  
  tools {
    maven "maven-3.6.3" 
  }
  
  environment {
    dockerHubRegistry = 'kuberneteskyb/k8s-guestbook'
    dockerHubRegistryCredential = 'k8s-cicd-dockerhub-cred'
  }
  stages {

    stage('Checkout Application Git Branch') {
        steps {
            git credentialsId: '{Credential ID}',
                url: 'https://github.com/youngbaekwon/guestbook.git',
                branch: 'main'
        }
        post {
                failure {
                  echo 'Repository clone failure !'
                }
                success {
                  echo 'Repository clone success !'
                }
        }
    }

    stage('Maven Jar Build') {
        steps {
          script {
            try {
              sh """
              mvn --version
              java -version
              """
              sh 'mvn -DskipTests=true clean package'
            } catch (error) {
              print(error)
              echo 'build filed'
        
              env.mavenBuildResult=false
              currentBuild.result = 'FAILURE'
            }
          }
        }
    }

    stage('Docker Image Build') { 
        steps {
            /*sh cp target/guestbook-0.0.1-SNAPSHOT.jar ./"
            sh cp deploy/Dockerfile ./"*/
            sh "docker build . -t ${dockerHubRegistry}:${currentBuild.number}"
            sh "docker build . -t ${dockerHubRegistry}:latest"
        }
        post {
                failure {
                  echo 'Docker image build failure !'
                }
                success {
                  echo 'Docker image build success !'
                }
        }
    }

    stage('Docker Image Push') {
        steps {
            withDockerRegistry([ credentialsId: dockerHubRegistryCredential, url: "" ]) {
                                sh "docker push ${dockerHubRegistry}:${currentBuild.number}"
                                sh "docker push ${dockerHubRegistry}:latest"

                                sleep 10 /* Wait uploading */ 
                            }
        }
        post {
                failure {
                  echo 'Docker Image Push failure !'
                  sh "docker rmi ${dockerHubRegistry}:${currentBuild.number}"
                  sh "docker rmi ${dockerHubRegistry}:latest"
                }
                success {
                  echo 'Docker image push success !'
                  sh "docker rmi ${dockerHubRegistry}:${currentBuild.number}"
                  sh "docker rmi ${dockerHubRegistry}:latest"
                }
        }
    }

  }

  
}
