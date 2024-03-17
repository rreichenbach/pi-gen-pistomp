#!/bin/bash -e

install -m 666 files/first-run.sh ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/
install -m 666 files/display-pistomp-logo ${ROOTFS_DIR}/etc/update-motd.d/
