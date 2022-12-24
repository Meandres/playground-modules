#!/bin/bash

if [ "$USER" != "root" ]; then
    echo "Run as root"
    exit 1
fi

KERNELDIR="../linux-5.15.56"

add_modules() {
    for mod in $@
    do
        cd $mod && make
        cd .. && sudo cp -r $mod ../fs/chroot/root/
    done
    cd ../fs
    sudo bash reload.sh
    cd ../modules
}

remove_modules() {
    for mod in $@
    do
        if [ -d ../fs/chroot/root/$mod ]; then
            sudo rm -r ../fs/chroot/root/$mod
        fi
    done
    cd ../fs
    sudo bash reload.sh
    cd ../modules
}

add_modules hello_1
