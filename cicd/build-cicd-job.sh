#!/bin/bash
#  ./build-cicd-job.sh <localImageName> 

if [ $# -ne 1 ]; then
    echo "build-cicd-job.sh: wrong number of arguments"
    exit $#
fi

localImageName=$1

#### BUILD

echo
echo "Building $localImageName ..."
echo

whoami
pwd
echo

export VERSIONID=$(cat versionid)
echo "Building version $VERSIONID ..."
echo

CONTAINERID=$(docker ps | grep $localImageName | head -1 | awk '{print $1}')
while [ ! -z "$CONTAINERID" ]
do
   echo "Old version of container running; removing ..."
   docker rm $CONTAINERID --force
   CONTAINERID=$(docker ps | grep $localImageName | head -1 | awk '{print $1}')
done
echo

IMAGEID=$(docker images | grep $localImageName | head -1 | awk '{print $3}')
while [ ! -z "$IMAGEID" ]
do
   echo "Image present; removing ..."
   docker rmi $IMAGEID --force
    IMAGEID=$(docker images | grep $localImageName | head -1 | awk '{print $3}')
done
echo


BUILDDATE=$(date)
docker build --build-arg version_id=$VERSIONID --build-arg build_date="$BUILDDATE" -t $localImageName ./

echo
docker images

echo
IMAGEID=$(docker images | grep $localImageName | awk '{print $3}')
if [ -z "$IMAGEID" ]
then
   echo "Image did NOT build ... exiting."
   exit 2
else
   echo "Image built successfully."
fi

# If success, then next job 
# ./cicd/test-cicd-job.sh

exit 0
