#!/bin/bash

REQUIRED_UBUNTU_VERSION_MIN="10.04"


# force sudo
if [ $(id -u) != "0" ]; then
    sudo "$0" "$@"
    exit $?
fi

CURRENT_UBUNTU_VERSION=`lsb_release -rs`

# Ubuntu 12.10: software-properties-common is needed for apt-add-repository
ADDREPO_SAFE_UBUNTU_VERSION="13.04"

command -v npm > /dev/null 2>&1 || {
    if ! echo "$CURRENT_UBUNTU_VERSION $REQUIRED_UBUNTU_VERSION_MIN -p" | dc | grep > /dev/null ^-; then
        if [[ `lsb_release -rs` > "10" ]]; then
            echo "NPM is yet to be installed. Installing/upgrading to latest node.js/npm versions."
            echo "This may take a minute or two ..."
            echo "   5/1 updating apt source info"
            apt-get update > /dev/null 2>&1
            if ! echo "$CURRENT_UBUNTU_VERSION ADDREPO_SAFE_UBUNTU_VERSION -p" | dc | grep > /dev/null ^-; then
                echo "   5/2 installing prerequisits: python-software-properties python g++ make"
                apt-get install -y python-software-properties python g++ make > /dev/null 2>&1
            else
                echo "   5/2 installing prerequisits: software-properties-common python-software-properties python g++ make"
                apt-get install -y software-properties-common python-software-properties python g++ make > /dev/null 2>&1
            fi
            echo "   5/3 adding official ubuntu node.js repo"
            add-apt-repository -y ppa:chris-lea/node.js > /dev/null 2>&1
            echo "   5/4 updating apt source info"
            apt-get update > /dev/null 2>&1
            echo "   5/5 installing up-to-date node.js and npm"
            apt-get install nodejs > /dev/null 2>&1
            echo "DONE"
        else
            echo "Ubuntu 12.10 is required"
        fi
    else
    fi
}

npm install -g hgrpull
