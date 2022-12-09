#!/bin/bash
ACCOUNT_ID=$(aws sts get-caller-identity | jq -r .Account)
CLUSTER_NAME=$2
AWS_REGION=$1
eksctl create iamserviceaccount \
  --cluster $CLUSTER_NAME \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --attach-policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"
export VPC_ID=$(aws eks describe-cluster \
                --name $CLUSTER_NAME \
                --query "cluster.resourcesVpcConfig.vpcId" \
                --output text)
helm repo add eks https://aws.github.io/eks-charts
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
-n kube-system --set clusterName=$CLUSTER_NAME --set serviceAccount.create=false \
--set serviceAccount.name=aws-load-balancer-controller \
--set region=${AWS_REGION} --set vpcId=${VPC_ID}
kubectl -n kube-system rollout status deployment aws-load-balancer-controller
