#!/bin/bash
#  ./deploy-cicd-job.sh <ipAddress> <token>

if [ $# -ne 2 ]; then
    echo "deploy-cicd-job.sh: wrong number of arguments"
    exit $#
fi

serverIp=$1
token=$2

rm -rf ~/.kube/config
kubectl config set-cluster mycluster --server=https://${serverIp}:6443 --insecure-skip-tls-verify
kubectl config set-credentials admin-user --token=${token}
kubectl config set-context mycluster-context --cluster=mycluster --user admin-user --namespace=default
kubectl config use-context mycluster-context

rm -rf deploy.yaml
cp ./cicd/nodeinfo-webserver.yaml deploy.yaml
VERSIONID=$(cat versionid)
sed -i "s/VERSIONID/${VERSIONID}/g" deploy.yaml

kubectl apply -f ./deploy.yaml

echo "Pausing for deployment update to start ..."
sleep 2

numPods=`kubectl get pods | fgrep nodeinfo | wc -l`
numRunning=`kubectl get pods | fgrep nodeinfo | fgrep Running | wc -l`
numTries=0

while [[ $numPods -ne 3 || $numRunning -ne 3 ]] 
do
  if [[ $numTries -gt 20 ]]
  then
    echo "Deployment taking too long ..."
    exit 1
  fi
  numTries=$((numTries + 1))

  kubectl get pods | fgrep nodeinfo
  echo
  echo "Waiting for deployment update to finish (" $numTries ") ..."
  sleep 5
  numPods=`kubectl get pods | fgrep nodeinfo | wc -l`
  numRunning=`kubectl get pods | fgrep nodeinfo | fgrep Running | wc -l`
done

exit 0
