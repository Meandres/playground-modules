#!/bin/bash

sudo mount -o loop stretch.img mnt/chroot
sudo rm -rf mnt/chroot/*
sudo cp -a chroot/. mnt/chroot/.
sudo umount mnt/chroot
