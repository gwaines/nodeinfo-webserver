#!/bin/bash

#### DEPLOY

echo
echo "Deploying Node Info WEB SERVER ..."
echo

export VERSIONID=$(cat versionid)

cp ./cicd/nodeinfo-webserver.yaml /tmp
sed -i "s/VERSIONID/$VERSIONID/" /tmp/nodeinfo-webserver.yaml

./cicd/deployScp.sh 128.224.141.54 wrsroot Li69nux* /tmp/nodeinfo-webserver.yaml /tmp

./cicd/deployCmd.sh 128.224.141.54 wrsroot Li69nux* kubectl apply -f /tmp/nodeinfo-webserver.yaml

exit 0
