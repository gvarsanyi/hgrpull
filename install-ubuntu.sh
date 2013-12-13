#!/bin/bash

# force sudo
if [ $(id -u) != "0" ]; then
    sudo "$0" "$@"
    exit $?
fi

command -v npm > /dev/null 2>&1 || {
    echo "NPM is yet to be installed. Installing/upgrading to latest node.js/npm versions."
    echo "This may take a minute or two ..."
    apt-get update > /dev/null 2>&1
    apt-get install -y python-software-properties python g++ make > /dev/null 2>&1
    add-apt-repository -y ppa:chris-lea/node.js > /dev/null 2>&1
    apt-get update > /dev/null 2>&1
    apt-get install nodejs > /dev/null 2>&1
    echo "DONE"
}

npm install -g hgrpull
