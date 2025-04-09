#!/bin/bash
terraform init
terraform fmt
terraform validate
terraform plan -out wro.plan
terraform apply wro.plan
sh ./scripts/upload.sh
aws s3api get-bucket-policy --bucket wroclawcup2025
aws s3api get-public-access-block --bucket wroclawcup2025