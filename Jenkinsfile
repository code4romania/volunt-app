#!groovy

String GIT_VERSION

node {

  // def buildEnv
  // def devAddress

  stage ('Checkout') {
    deleteDir()
    checkout scm
    GIT_VERSION = sh (
      script: 'git describe --tags',
      returnStdout: true
    ).trim()
  }

  stage ('Build Custom Environment') {
    // buildEnv = docker.build("build_env:${GIT_VERSION}", 'custom-build-env')
    sh 'echo hello there?'
  }

  // buildEnv.inside {

  //   stage ('Build') {
  //   }
  // }

  stage ('Build and Push Docker Image') {}

  stage ('Restart Service on ECS') {}
}

// vim: set syntax=groovy :