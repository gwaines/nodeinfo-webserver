pipeline {
  environment {
    repository           = "gwaines"
    image                = "nodeinfo"
    version              = sh(script: 'cat versionid | xargs', returnStdout: true)
    versionID            = "v1.9"
    dockerImage          = ""
    localContainer       = ""
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
        sh 'set +e; docker rmi ${repository}/${image}:${version};echo "..."'
        sh 'docker images'
	echo "Version: <$version>"
        script {
	  def fullImageName = repository + "/" + image + ":" + versionID
          dockerImage = docker.build fullImageName
        }
        sh 'docker images'
      }
    }
    stage('Testing Container Image Locally') {
      steps {
        echo 'Testing Container Image Locally ...'
        script {
          localContainer = dockerImage.run('-d -p 31115:80')
        }
        sh 'curl http://localhost:31115'
        script {
          localContainer.stop()
        }
      }
    }
    stage('Deploying to Docker Hub') {
      steps {
        echo 'Deploying to Docker Hub ...'
        script {
          docker.withRegistry('', 'gwainesDockerHubCredentials') {
            dockerImage.push()
	  }
        }
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
