#!/bin/bash
kubectl -n alfresco annotate svc acs-alfresco-cs-share alb.ingress.kubernetes.io/healthcheck-path=/share alb.ingress.kubernetes.io/success-codes='200,302'
certARN=$1
wget https://raw.githubusercontent.com/chongwmAmz/storhouse/main/acs-alfresco-alb-ingress-https.yaml
sed -i "s#<ARN_Of_Certificate>#$certARN#g" acs-alfresco-alb-ingress-https.yaml
kubectl apply -f acs-alfresco-alb-ingress-https.yaml
