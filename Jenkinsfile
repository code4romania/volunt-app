pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        echo 'Building..'
        sh '''#!/bin/bash
DOCKER_LOGIN=`aws ecr get-login --region eu-west-1`
${DOCKER_LOGIN}'''
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
}