#!/bin/bash
# This script is adapted from instructions provided in https://www.eksworkshop.com/beginner/180_fargate/prerequisites-for-alb/

ACCOUNT_ID=$(aws sts get-caller-identity | jq -r .Account)
CLUSTER_NAME=$2
AWS_REGION=$1

POLICY_NAME=AWSLoadBalancerControllerIAMPolicy
POLICY_FILE=iam_policy.json.json
wget -O $POLICY_FILE  https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.4/docs/install/iam_policy.json
aws iam create-policy \
    --policy-name $POLICY_NAME \
    --policy-document file://$POLICY_FILE
rm $POLICY_FILE

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
POLICY_NAME=AwsEksEfsCsiDriverPolicy
POLICY_FILE=iam-policy-example.json
wget -O $POLICY_FILE https://github.com/kubernetes-sigs/aws-efs-csi-driver/raw/master/docs/iam-policy-example.json
aws iam create-policy \
    --policy-name  $POLICY_NAME \
    --policy-document file://$POLICY_FILE
rm $POLICY_FILE
POLICY_ARN=$(aws iam list-policies --query "Policies[?PolicyName=='$POLICY_NAME']" | jq -r .[].Arn)
eksctl create iamserviceaccount \
    --cluster $CLUSTER_NAME \
    --namespace kube-system \
    --name efs-csi-controller-sa \
    --attach-policy-arn $POLICY_ARN \
    --region $AWS_REGION --approve \
    --override-existing-serviceaccounts
