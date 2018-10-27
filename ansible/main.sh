#!/bin/bash

########
INVENTORY=inventory_aws
########
##### play ansible

status() {
    test ${?} -eq 0 && echo "Success" || (echo "Failure" && exit 1)
}

FILE=$(realpath ${0})
DIR=$(dirname ${FILE})

echo "Run: ${FILE}"

echo -n "Installing requirements: "
ansible-galaxy install -r roles/requirements.yml > /dev/null
status || exit

if [ "${1}" == "vagrant" ]; then
    INVENTORY=inventory_vagrant
fi

ansible-playbook -i ${INVENTORY} main.yml -vv -D
status || exit
