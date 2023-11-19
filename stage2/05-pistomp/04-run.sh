#!/bin/bash -e

install -m 644 files/first-run.sh ${ROOTFS_DIR}/etc/profile.d/
install -m 644 files/display-pistomp-logo ${ROOTFS_DIR}/etc/update-motd.d/
