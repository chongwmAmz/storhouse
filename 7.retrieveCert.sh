DOMAIN_NAME=$1
aws acm list-certificates --query \
"CertificateSummaryList[?DomainName == '$DOMAIN_NAME']" \
| jq -r '.[].CertificateArn'
