#!/bin/bash

install -m 666 files/firstboot.sh ${ROOTFS_DIR}/boot/firmware/
install -m 666 files/reboot.sh ${ROOTFS_DIR}/boot/firmware/
install -m 666 files/display-pistomp-logo ${ROOTFS_DIR}/etc/update-motd.d/

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
/home/${FIRST_USER_NAME}/pi-stomp/util/change-audio-card.sh iqaudio-codec
/home/${FIRST_USER_NAME}/pi-stomp/setup/pi-stomp-tweaks/modify_version.sh 3.0

EOF
