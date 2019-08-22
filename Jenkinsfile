pipeline {
  environment {
    repository           = "gwaines"
    image                = "nodeinfo"
    version              = sh(script: "cat versionid ", returnStdout: true).trim()
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
	  def fullImageName = repository + "/" + image + ":" + version
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
	sh '''#!/bin/bash

	      rm -rf ~/.kube/config
	      kubectl config set-cluster mycluster --server=https://147.75.92.41:6443 --insecure-skip-tls-verify
	      kubectl config set-credentials admin-user --token=eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLXBxY2JzIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiJlMzMyZDFkNC1iYTE5LTExZTktOTE3Ni1hYzFmNmIwZWVmMjgiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZS1zeXN0ZW06YWRtaW4tdXNlciJ9.YfgpWrvOCBXSr2CSaYnOTJJAncGe7DjZ915Z0pXmnZzj9d5BLQ0E6PW1OY75UR25LIFX8Ttr4WsLzvAWrkj4BVPjfLtX_nFknGNc6BS1ruhMmiU_M530vX5pIB6bC4QwUKN6g9l2Qcle2hDlJQcP0qQYLkkCkRAaq8Km0rbY5QA_6pEcrg1j74nbiupGFU4AIGMfuT74DFvHlbwfsQUBgX9tbOtlFGlnsBoW8xLpUmoCq-UNw12iWQ0f9i3wjytqCEEJsC1BlFECqvBteLGtQq7oGDn4Qtf6YSKjFMJjOtU-54fS5QMw6J_YROa67xRuV7leOnH_zq1s0OtgPHgjhQ
	      kubectl config set-context mycluster-context --cluster=mycluster --user admin-user --namespace=default
	      kubectl config use-context mycluster-context

	      rm -rf deploy.yaml
	      cp ./cicd/nodeinfo-webserver.yaml deploy.yaml
	      VERSIONID=$(cat versionid)
	      sed -i "s/VERSIONID/${VERSIONID}/g" deploy.yaml

	      kubectl apply -f ./deploy.yaml
	      rm -rf deploy.yaml
        '''
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
