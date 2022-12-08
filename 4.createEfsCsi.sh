#!/bin/bash
set -x
kubectl apply -f alfresco-pv.yaml
kubectl apply -f aws-efs-csi-driver/examples/kubernetes/multiple_pods/specs/storageclass.yaml
wget -P aws-efs-csi-driver/examples/kubernetes/multiple_pods/specs/ https://eksworkshop.com/beginner/190_efs/efs.files/efs-reader.yaml
sed -i "/namespace:/c\  namespace: alfresco" aws-efs-csi-driver/examples/kubernetes/multiple_pods/specs/efs-reader.yaml
kubectl create namespace alfresco
kubectl apply -f aws-efs-csi-driver/examples/kubernetes/multiple_pods/specs/efs-reader.yaml
kubectl apply -f alfresco-claim.yaml
set +x
