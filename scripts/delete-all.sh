#!/bin/bash
# Delete all containers
docker rm demo-jenkins
docker rm demo-jenkins-app
# Delete all images
docker rmi demo-jenkins
docker rmi demo-jenkins-app
# Delete jenkins home volume
docker volume rm jenkins_home