pipeline {
  agent any
  
  tools {
    maven 'maven-3.6.3' 
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
              sh 'r/bin/mvn -DskipTests=true clean package'
            } catch (error) {
              print(error)
              echo 'Remove Deploy Files'
              sh "sudo rm -rf /var/lib/jenkins/workspace/${env.JOB_NAME}/*"
              env.mavenBuildResult=false
              currentBuild.result = 'FAILURE'
            }
          }
        }
      """
        post {
                failure {
                  echo 'Maven jar build failure !'
                }
                success {
                  echo 'Maven jar build success !'
                }
        }
        """
    }
  }
  
}
