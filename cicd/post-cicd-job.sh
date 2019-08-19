#!/bin/bash
#  ./post-cicd-job.sh <repository> <image> <username> <password>

if [ $# -ne 4 ]; then
    echo "post-cicd-job.sh: wrong number of arguments"
    exit $#
fi

repository=$1
image=$2
username=$3
password=$4


#####  Post new image to DOCKER HUB


echo
echo "Post new image to Docker Registry ..."
echo

VERSIONID=$(cat versionid)

docker tag nodeinfo ${repository}/${image}:$VERSIONID
docker images

echo docker login -u ${username} -p REDACTED
docker login -u ${username} -p ${password}
echo docker push ${repository}/${image}:$VERSIONID
docker push ${repository}/${image}:$VERSIONID

# If success, then next job
# ./cicd/deploy-cicd-job.sh

exit 0
