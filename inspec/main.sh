#!/bin/bash

########
INVENTORY=inventory_aws
########
##### run inspec

status() {
    test ${?} -eq 0 && echo "Success" || (echo "Failure" && exit 1)
}

FILE=$(realpath ${0})
DIR=$(dirname ${FILE})

echo "Run: ${FILE}"

if [ "${1}" == "vagrant" ]; then
    INVENTORY=inventory_vagrant
fi

#### inspec check installation
command -v inspec > /dev/null
if [ "${?}" -gt 0 ]; then
    echo "inspec is absent. Setup this please manually. "
    exit 1
fi

egrep '([a-z0-9]+).paxful.lo' ../ansible/${INVENTORY} | while read line; do
    host=$(echo ${line} | cut -f 1 -d ' ')
    address=$(echo ${line} | egrep -o 'ansible_host=(.*)' | cut -f 2 -d '=' | cut -f 1 -d ' ')
    group=$(echo ${line} | egrep -o '^[a-z]+')
    prinvate_key=../terraform/private_key
    login="admin"

    echo "Test start for ${host}"

    if [ "${1}" == "vagrant" ]; then
        prinvate_key="./vagrant/"$(echo ${line} | egrep -o 'ansible_ssh_private_key_file=(.*)' | cut -f 2 -d '=' | cut -f 1 -d ' ')
        address=$(echo ${line} | egrep -o 'ansible_host=(.*)' | cut -f 2 -d '=' | cut -f 1 -d ' ')
        port=$(echo ${line} | egrep -o 'ansible_ssh_port=(.*)' | cut -f 2 -d '=' | cut -f 1 -d ' ')
        address="127.0.0.1:${port}"
        login="vagrant"
    fi

    inspec exec ${group} -t ssh://${login}@${address} -i ${prinvate_key}
    status || exit
done
