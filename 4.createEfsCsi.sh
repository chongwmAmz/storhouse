#!/bin/bash
wget https://raw.githubusercontent.com/chongwmAmz/storhouse/main/alfresco-pv.yaml
sed -i "/volumeHandle:/c\    volumeHandle: $1" alfresco-pv.yaml
kubectl apply -f alfresco-pv.yaml
curl https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/master/examples/kubernetes/multiple_pods/specs/storageclass.yaml | kubectl apply -f -
kubectl create namespace alfresco
curl https://raw.githubusercontent.com/chongwmAmz/storhouse/main/alfresco-claim.yaml | kubectl apply -f -
curl https://raw.githubusercontent.com/chongwmAmz/storhouse/main/alfresco-dir-creator.yaml | kubectl apply -f -
