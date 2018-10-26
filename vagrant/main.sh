#!/bin/bash

##### prepare vbox
# - create vm
# - replace current ssh port in inventory file

FILE=$(realpath ${0})
DIR=$(dirname ${FILE})

echo "Run: ${FILE}"

VM=$(grep '\.lo' ../ansible/inventory_vagrant | awk '{print $1}' | sed 's/.lo//')

while read vm; do
    echo "Check ${vm}"

    mkdir -p ${vm}
    cd ${vm}

    test -f Vagrantfile || vagrant init debian/stretch64

    # forward port for app's vm
    grep -q app <<< ${vm}
    if [ "$?" -eq 0 ]; then
        sed -i. '/host: 8080/s/# //g' Vagrantfile
        rm Vagrantfile.
        # egrep -q "forwarded_port(.*?)8080" Vagrantfile
        # if [ "$?" -gt 0 ]; then
        #     sed -i. -e $'s/|config|/|config|\\\n  config.vm.network "forwarded_port", guest: 80, host: 8080/g' Vagrantfile
        # fi
    fi

    vagrant up

    vbox=$(VBoxManage list vms | grep $(sed 's/\.//g' <<< "${vm}") | cut -f 2 -d '"')

    ssh_port=$(VBoxManage showvminfo ${vbox} | grep NIC | grep Rule | grep ssh | egrep -o 'host port = ([0-9]+)' | tr -d ' ' | cut -f 2 -d '=')

    sed -i. "/${vm}/s/ansible_ssh_port=\([0-9]\{4\}\)/ansible_ssh_port=${ssh_port}/" "${DIR}/../ansible/inventory_vagrant"

    rm "${DIR}/../ansible/inventory_vagrant."

    cd -
done <<< "${VM}"
