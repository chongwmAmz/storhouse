#!/bin/bash
eksctl create cluster -f eksctl-createcluster-nonode-apse1fg.yaml
eksctl utils associate-iam-oidc-provider \
    --region $1 \
    --cluster $2 \
    --approve
