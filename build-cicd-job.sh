#!/bin/bash

#### BUILD

echo
echo "Building Node Info WEB SERVER ..."
echo

VERSIONID=$(cat versionid)
echo "Building version $VERSIONID ..."
echo

CONTAINERID=$(docker ps | grep nodeinfo | head -1 | awk '{print $1}')
while [ ! -z "$CONTAINERID" ]
do
   echo "Old version of container running; removing ..."
   docker rm $CONTAINERID --force
   CONTAINERID=$(docker ps | grep nodeinfo | head -1 | awk '{print $1}')
done
echo

IMAGEID=$(docker images | grep nodeinfo | head -1 | awk '{print $3}')
while [ ! -z "$IMAGEID" ]
do
   echo "Image present; removing ..."
   docker rmi $IMAGEID --force
    IMAGEID=$(docker images | grep nodeinfo | head -1 | awk '{print $3}')
done
echo

docker build -t nodeinfo ./

echo
docker images

echo
IMAGEID=$(docker images | grep nodeinfo | awk '{print $3}')
if [ -z "$IMAGEID" ]
then
   echo "Image did NOT build ... exiting."
   exit 2
else
   echo "Image built successfully."
fi

./test-cicd-job.sh

exit 0
