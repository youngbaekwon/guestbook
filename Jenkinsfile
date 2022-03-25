pipeline {
  agent any
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
          def mvnHome = tool name: 'Maven3', type: 'maven'
          sh "${mvnHome}/bin/mvn -DskipTests=true clean package"
          
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
