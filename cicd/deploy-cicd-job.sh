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

echo
echo "Pausing for new deployment to start up and take over ..."
sleep 10

exit 0
