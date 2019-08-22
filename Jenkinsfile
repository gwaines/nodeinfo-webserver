pipeline {
  environment {
    repository           = "gwaines/"
    image                = "nodeinfo-webserver"
    version              = "v1.8"
    repositoryCredential = "St8rlingX*"
    dockerImage          = ""
  }
  agent any
  stages {
    stage('Build Application') {
      steps {
        echo 'Nothing to build, its Python ...'
        sh 'cat app.py'
      }
    }
    stage('Building Container Image') {
      steps{
        echo 'Building Container Image...'
        script {
	  def fullImageName = repository + image + ":" + version
          dockerImage = docker.build fullImageName
        }
      }
    }
    stage('Testing Container Image Locally') {
      steps {
        echo 'Testing Container Image Locally ...'
      }
    }
    stage('Deploying to Docker Hub') {
      steps {
        echo 'Deploying to Docker Hub ...'
      }
    }
    stage('Deploying to Canary Kubernetes Site') {
      steps {
        echo 'Deploying to Canary Kubernetes Site ...'
      }
    }
    stage('Testing Container Image at Canary Kubernetes Site') {
      steps {
        echo 'Testing Container Image at Canary Kubernetes Site ...'
      }
    }
    stage('Deploying to Production Kubernetes Site') {
      steps {
        echo 'Deploying to Production Kubernetes Site ...'
      }
    }
  }
}
