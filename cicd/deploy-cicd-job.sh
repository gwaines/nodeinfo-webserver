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

kubectl get nodes

exit 0
