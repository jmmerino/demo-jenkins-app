#!/bin/bash
# Build and run our app docker image
docker build -t nodeapp ../
docker rm demo-jenkins-app
docker run -it -p 8001:8001 --name demo-jenkins-app nodeapp