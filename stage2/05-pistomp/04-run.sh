#!/bin/bash -e

install -m 666 files/firstboot.sh ${ROOTFS_DIR}/boot/firmware/
install -m 666 files/reboot.sh ${ROOTFS_DIR}/boot/firmware/
install -m 666 files/display-pistomp-logo ${ROOTFS_DIR}/etc/update-motd.d/
