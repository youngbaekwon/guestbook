pipeline {
  agent any
  tools {
      maven 'Maven 3.6.3'
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
            sh 'mvn -DskipTests=true clean package'
        }
        post {
                failure {
                  echo 'Maven jar build failure !'
                }
                success {
                  echo 'Maven jar build success !'
                }
        }
    }
  }
  
}
