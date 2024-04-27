#!/bin/bash -e

install -m 666 files/firstboot.sh ${ROOTFS_DIR}/boot/
install -m 666 files/display-pistomp-logo ${ROOTFS_DIR}/etc/update-motd.d/
