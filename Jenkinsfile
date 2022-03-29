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
            git credentialsId: '{git-jenkins-credential}',
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

    stage('K8S Manifest Update') {
        steps {
            git credentialsId: 'git-jenkins-ssh-key',
                url: 'git@github.com:youngbaekwon/guestbook-manifest.git',
                branch: 'main'

            sh "sed -i 's/k8s-guestbook:.*\$/k8s-guestbook:${currentBuild.number}/g' guestbook-deployment-secret-v1.yaml"
            sh "git add guestbook-deployment-secret-v1.yaml"
            sh "git commit -m '[UPDATE] guestbook-manifest ${currentBuild.number} image versioning'"

            sh "git config --global user.email 'yb021.kwon@gmail.com"
            sh "git config --global user.name 'youngbaekwon'"
            sshagent(credentials: ['{git-jenkins-ssh-key}']) {
                sh "git remote set-url origin git@github.com:youngbaekwon/guestbook-manifest.git"
                sh "git push -u origin main"
            }
            /*
            withCredentials([gitUsernamePassword(credentialsId: 'git-jenkins-credential', gitToolName: 'git-tool')]) {
                sh "git remote set-url origin https://github.com/youngbaekwon/guestbook-manifest.git"
                sh "git push -u origin main"
            }*/
        }
        post {
                failure {
                  echo 'K8S Manifest Update failure !'
                }
                success {
                  echo 'K8S Manifest Update success !'
                }
        }
    }

  }

  
}
