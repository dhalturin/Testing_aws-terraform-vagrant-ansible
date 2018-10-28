#!/bin/bash

status() {
    test ${?} -eq 0 && echo "Success" || (echo "Failure" && exit 1)
}

#### vagrant check installation
command -v vagrant > /dev/null
if [ "${?}" -gt 0 ]; then
    echo "Vagrant is absent. Setup this please manually. "
    exit 1
fi

vagrant up