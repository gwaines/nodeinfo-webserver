pipeline {
  environment {
    DOCKER_REPO                 = "gwaines"
    DOCKER_IMAGE                = "nodeinfo"
    DOCKER_USERNAME             = "gwaines"
    DOCKER_PASSWORD             = "windriver"
    CANARY_DEPLOY_SERVER        = "147.75.92.41"
    CANARY_DEPLOY_ADMIN_TOKEN   = "eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLXBxY2JzIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiJlMzMyZDFkNC1iYTE5LTExZTktOTE3Ni1hYzFmNmIwZWVmMjgiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZS1zeXN0ZW06YWRtaW4tdXNlciJ9.YfgpWrvOCBXSr2CSaYnOTJJAncGe7DjZ915Z0pXmnZzj9d5BLQ0E6PW1OY75UR25LIFX8Ttr4WsLzvAWrkj4BVPjfLtX_nFknGNc6BS1ruhMmiU_M530vX5pIB6bC4QwUKN6g9l2Qcle2hDlJQcP0qQYLkkCkRAaq8Km0rbY5QA_6pEcrg1j74nbiupGFU4AIGMfuT74DFvHlbwfsQUBgX9tbOtlFGlnsBoW8xLpUmoCq-UNw12iWQ0f9i3wjytqCEEJsC1BlFECqvBteLGtQq7oGDn4Qtf6YSKjFMJjOtU-54fS5QMw6J_YROa67xRuV7leOnH_zq1s0OtgPHgjhQ"
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
        sh './cicd/build-cicd-job.sh ${DOCKER_IMAGE}'
      }
    }
    stage('Testing Container Image Locally') {
      steps {
        echo 'Testing Container Image Locally ...'
        sh './cicd/test-cicd-job.sh ${DOCKER_IMAGE}'
      }
    }
    stage('Deploying to Docker Hub') {
      steps {
        echo 'Deploying to Docker Hub ...'
        sh './cicd/post-cicd-job.sh ${DOCKER_REPO} ${DOCKER_IMAGE} ${DOCKER_USERNAME} ${DOCKER_PASSWORD}'
      }
    }
    stage('Deploying to Canary Kubernetes Site') {
      steps {
        echo 'Deploying to Canary Kubernetes Site ...'
        sh './cicd/deploy-cicd-job.sh ${CANARY_DEPLOY_SERVER} ${CANARY_DEPLOY_ADMIN_TOKEN}'
      }
    }
    stage('Testing Container Image at Canary Kubernetes Site') {
      steps {
        echo 'Testing Container Image at Canary Kubernetes Site ...'
	sh 'curl http://${CANARY_DEPLOY_SERVER}:31115'
      }
    }
    stage('Deploying to Production Kubernetes Site') {
      steps {
	input("Confirm deployment to PRODUCTION Kubernetes Site?")
        echo 'Deploying to Production Kubernetes Site ...'
      }
    }
  }
}
