#!/bin/bash
kubectl create secret generic docker-registry-secrets --from-file=.dockerconfigjson=$HOME/.docker/config.json --type=kubernetes.io/dockerconfigjson -n alfresco
