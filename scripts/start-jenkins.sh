#!/bin/bash
# Get and run jenkins docker image
#docker build -t demo-jenkins ../jenkins
docker rm demo-jenkins
docker run -p 8080:8080 -p 50000:50000 -v /var/run/docker.sock:/var/run/docker.sock -v jenkins_home:/var/jenkins_home --name demo-jenkins jmmerino/jenkins:latest