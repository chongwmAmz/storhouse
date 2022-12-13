#!/bin/bash
kubectl -n alfresco delete ingress acs-alfresco-sync-service-ingress
kubectl -n alfresco delete ingress acs-alfresco-cs-repository
kubectl -n alfresco delete ingress acs-alfresco-cs-share
kubectl -n alfresco delete ingress acs-alfresco-dw
kubectl -n alfresco delete ingress acs-alfresco-sync-service-ingress
