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
  }
  
}
