#!/bin/bash

########
INVENTORY=inventory_aws
GROUP_LIST="pgsql app"
TYPE=${1}
########
##### run inspec

status() {
    test ${?} -eq 0 && echo "Success" || (echo "Failure" && exit 1)
}

run_test() {
    group="${1}"

    if [ "${group}" == "" ]; then
        echo "Error: group name is empty"
        exit 1
    fi

    echo "Run test for group: ${group}"

    egrep "${1}([0-9]+).paxful.lo" ../ansible/${INVENTORY} | while read line; do
        host=$(echo ${line} | cut -f 1 -d ' ')
        address=$(echo ${line} | egrep -o 'ansible_host=(.*)' | cut -f 2 -d '=' | cut -f 1 -d ' ')
        prinvate_key=../terraform/private_key
        login="admin"

        echo "Test start for ${host}"

        if [ "${TYPE}" == "vagrant" ]; then
            prinvate_key=$(echo ${line} | egrep -o 'ansible_ssh_private_key_file=(.*)' | cut -f 2 -d '=' | cut -f 1 -d ' ')
            port=$(echo ${line} | egrep -o 'ansible_ssh_port=(.*)' | cut -f 2 -d '=' | cut -f 1 -d ' ')
            address="127.0.0.1:${port}"
            login="vagrant"
        fi

        inspec exec ${group} -t ssh://${login}@${address} -i ${prinvate_key}
        status || exit
    done
}

echo "Run: inspec"

if [ "${TYPE}" == "vagrant" ]; then
    INVENTORY=inventory_vagrant
fi

#### inspec check installation
command -v inspec > /dev/null
if [ "${?}" -gt 0 ]; then
    echo "inspec is absent. Setup this please manually. "
    exit 1
fi

for group in ${GROUP_LIST}; do
    run_test ${group}
    status || exit
done
