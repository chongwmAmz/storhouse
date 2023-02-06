DOMAIN_NAME=$1
aws acm list-certificates --query \
"CertificateSummaryList[?DomainName == '$DOMAIN_NAME']" \
| jq -r '.[].CertificateArn'

aws acm list-certificates --query \
"CertificateSummaryList[?SubjectAlternativeNameSummaries[?contains(@, '$DOMAIN_NAME')]][].CertificateArn" \
| jq -r '.[].CertificateArn'
