#!/bin/bash

########
TERRAFORM_VERSION=0.11.10
TERRAFORM_URL=https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_darwin_amd64.zip

temp=$(mktemp -d "temp.XXXXXXXXX") || exit "Temporary directory create failed"
########

cleanup() {
    echo -e "Cleaning up"
    rm -rf "${temp}"
}

status() {
    test ${?} -eq 0 && echo "Success" || (echo "Failure" && exit 1)
}

trap '{ exit_code="$?"; cleanup; exit $exit_code; }' EXIT

clear

#### terraform check installation
command -v terraform > /dev/null
if [ "${?}" -gt 0 ]; then
    read -p "Terraform is absent. Download? [y/n] " answer

    if [[ ! "${answer}" =~ ^[Yy] ]]; then
        echo "Bye :("
        exit
    fi

    echo -n "Downloading... "
    (cd ${temp} && curl -sO ${TERRAFORM_URL} -o /dev/null)
    status || exit
 
    echo -n "Unpacking... "
    (cd ${temp} && unzip -d /usr/local/sbin terraform_${TERRAFORM_VERSION}* > /dev/null 2>&1)
    status || exit
fi

if [ ! -f private_key ]; then
    echo -n "Generate private key... "
    ssh-keygen -q -t rsa -f private_key -N '' > /dev/null 2>&1
    status || exit
fi

terraform init
terraform apply -auto-approve