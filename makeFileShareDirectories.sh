#!/bin/bash
sudo mkdir -p /mnt/sharedfilestore/alfresco-content-services/filestore-data \
 /mnt/sharedfilestore/alfresco-content-services/repository-data
sudo chown -R 33000:1000 /mnt/sharedfilestore/alfresco-content-services
sudo chmod -R g+w /mnt/sharedfilestore/alfresco-content-services/
