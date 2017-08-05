pipeline {
  agent {
    dockerfile {
      filename 'Dockerfile'
    }
    
  }
  stages {
    stage('Build') {
      steps {
        echo 'Building..'
      }
    }
    stage('Test') {
      steps {
        echo 'Testing..'
      }
    }
    stage('Deploy') {
      steps {
        echo 'Deploying....'
      }
    }
  }
  environment {
    POSTGRES_DB = 'voluntari_development'
    POSTGRES_USER = 'voluntapp'
    POSTGRES_PASSWORD = 'voluntapp'
  }
}