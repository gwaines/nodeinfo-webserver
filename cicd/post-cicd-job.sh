#!/bin/bash


#####  Post new image to DOCKER HUB


echo
echo "Post new image to Docker Registry ..."
echo

VERSIONID=$(cat versionid)

docker tag nodeinfo gwaines/nodeinfo:$VERSIONID
docker images

echo docker login -u gwaines -p windriver
docker login -u gwaines -p windriver
echo docker push gwaines/nodeinfo:$VERSIONID
docker push gwaines/nodeinfo:$VERSIONID

##### docker run -d -p 31115:80 gwaines/nodeinfo:$VERSIONID

# If success, then next job
# ./cicd/deploy-cicd-job.sh

exit 0
