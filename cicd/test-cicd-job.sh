#!/bin/bash
#  ./test-cicd-job.sh <localImageName> 

if [ $# -ne 1 ]; then
    echo "test-cicd-job.sh: wrong number of arguments"
    exit $#
fi

localImageName=$1


##### Test

echo
echo
echo "Testing Node Info WEB SERVER ..."
echo

VERSIONID=$(cat versionid)

CONTAINERID=$(docker ps | grep $localImageName | head -1 | awk '{print $1}')
while [ ! -z "$CONTAINERID" ]
do
   echo "Old version of container running; removing ..."
   docker rm $CONTAINERID --force
   CONTAINERID=$(docker ps | grep $localImageName | head -1 | awk '{print $1}')
done
echo

docker run -d -p 31115:80 $localImageName
retVal=$?
if [ $retVal -ne 0 ]; then
    echo "Could not start docker container ... exiting."
    exit $retVal
fi

echo
echo "Pausing for container to start up ..."
sleep 3

echo
echo "curl http://localhost:31115"
curl http://localhost:31115
retVal=$?
if [ $retVal -ne 0 ]; then
    echo "Container testing failed ... exiting."
    exit $retVal
fi

echo
echo "Container testing passed."
echo

CONTAINERID=$(docker ps | grep $localImageName | awk '{print $1}')
docker rm $CONTAINERID --force

# If success, then next job
# ./cicd/post-cicd-job.sh

exit 0
