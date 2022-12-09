#!/bin/bash
eksctl create cluster -f eksctl-createcluster-fgnonode.yaml 
eksctl utils associate-iam-oidc-provider \
    --region $1 \
    --cluster $2 \
    --approve
