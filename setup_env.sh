#!/bin/bash

KERNEL_VERSION=5.15.56

sudo apt-get update
sudo apt-get install git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc flex libelf-dev bison qemu-system-x86 debootstrap

if [ ! -e linux-$KERNEL_VERSION/arch/x86/boot/bzImage ]; then
    wget https://cdn.kernel.org/pub/linux/kernel/v$(echo $KERNEL_VERSION | awk -F '.' '{ print $1; }').x/linux-$KERNEL_VERSION.tar.xz
    tar xvf linux-$KERNEL_VERSION.tar.xz
    cd linux-$KERNEL_VERSION
    make defconfig
    make kvm_guest.config || make kvmconfig
cat <<EOF >> .config
CONFIG_KCOV=y
CONFIG_DEBUG_INFO=y
CONFIG_KASAN=y
CONFIG_KASAN_INLINE=y
CONFIG_CONFIGFS_FS=y
CONFIG_SECURITYFS=y
EOF
    make olddefconfig
    make -j $(nproc) &
    make_pid=$!
    cd ..
fi

if [ ! -e fs/stretch.img ]; then
    cd fs
    wget https://raw.githubusercontent.com/google/syzkaller/master/tools/create-image.sh -O create-image.sh
    chmod u+x create-image.sh
    sed s+/mnt/$DIR+mnt/$DIR+g -i create-image.sh
    ./create-image.sh
fi

while kill -0 $make_pid > /dev/null 2>&1; do
    sleep 1
done

