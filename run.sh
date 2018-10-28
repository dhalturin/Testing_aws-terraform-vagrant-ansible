#!/bin/bash

cleanup() {
    echo -e "Cleaning up"
    rm -rf "${temp}"
}

status() {
    test ${?} -eq 0 && echo "Success" || (echo "Failure" && exit 1)
}

trap '{ exit_code="$?"; cleanup; exit $exit_code; }' EXIT

clear

TYPE=${1}

if [ "${TYPE}" == "vagrant" ]; then
    echo "Using vagrant"
    (cd vagrant; bash ./main.sh)
    status || exit
elif [ "${TYPE}" == "terraform" ]; then
    echo "Using terraform"
    (cd terraform; bash ./main.sh)
    status || exit
else
    cat - <<EOF
Choose type to run

Use:
    ${0} [type] - vgrant, terraform
EOF
    exit
fi

(cd ansible; bash ./main.sh ${TYPE})
status || exit

(cd inspec; bash ./main.sh ${TYPE})
status || exit
