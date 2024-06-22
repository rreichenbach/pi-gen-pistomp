#!/bin/bash

install -m 666 files/display-pistomp-logo ${ROOTFS_DIR}/etc/update-motd.d/
install -m 666 files/start_touchosc2midi.sh ${ROOTFS_DIR}/usr/mod/scripts/
install -m 666 files/wifi-check.sh ${ROOTFS_DIR}/usr/lib/pistomp-wifi/
install -m 666 files/firstboot.sh ${ROOTFS_DIR}/boot/firmware/

on_chroot << EOF

chmod +x /etc/update-motd.d/display-pistomp-logo
chown -R ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}
chmod +x /etc/jackdrc
chown jack:jack /etc/jackdrc
chmod 500 /etc/authbind/byport/80
chown ${FIRST_USER_NAME}:${FIRST_USER_NAME} /etc/authbind/byport/80
chown -R ${FIRST_USER_NAME}:${FIRST_USER_NAME} /usr/lib/pistomp-wifi
chmod +x -R /usr/lib/pistomp-wifi
rm /etc/profile.d/bash_completion.sh

EOF
