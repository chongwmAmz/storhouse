#!/bin/bash
set -x
curl https://raw.githubusercontent.com/chongwmAmz/storhouse/main/alfresco-pv.yaml | kubectl apply -f -
curl https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/master/examples/kubernetes/multiple_pods/specs/storageclass.yaml | kubectl apply -f -
#wget -P aws-efs-csi-driver/examples/kubernetes/multiple_pods/specs/ https://eksworkshop.com/beginner/190_efs/efs.files/efs-reader.yaml
#sed -i "/namespace:/c\  namespace: alfresco" aws-efs-csi-driver/examples/kubernetes/multiple_pods/specs/efs-reader.yaml
kubectl create namespace alfresco
#kubectl apply -f aws-efs-csi-driver/examples/kubernetes/multiple_pods/specs/efs-reader.yaml
curl https://raw.githubusercontent.com/chongwmAmz/storhouse/main/alfresco-claim.yaml | kubectl apply -f -
set +x
