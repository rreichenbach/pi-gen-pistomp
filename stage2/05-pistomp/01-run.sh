#!/bin/bash

install -m 644 files/services/*.service ${ROOTFS_DIR}/usr/lib/systemd/system/
install -m 644 files/jackdrc ${ROOTFS_DIR}/etc/
install -m 500 files/80 ${ROOTFS_DIR}/etc/authbind/byport/

echo "Creating folders and services"
on_chroot << EOF

mkdir -p /home/${FIRST_USER_NAME}/data

ln -sf /usr/lib/systemd/system/browsepy.service /etc/systemd/system/multi-user.target.wants
ln -sf /usr/lib/systemd/system/jack.service /etc/systemd/system/multi-user.target.wants
ln -sf /usr/lib/systemd/system/mod-host.service /etc/systemd/system/multi-user.target.wants
ln -sf /usr/lib/systemd/system/mod-ui.service /etc/systemd/system/multi-user.target.wants
ln -sf /usr/lib/systemd/system/mod-amidithru.service /etc/systemd/system/multi-user.target.wants
ln -sf /usr/lib/systemd/system/mod-touchosc2midi.service /etc/systemd/system/multi-user.target.wants
ln -sf /usr/lib/systemd/system/mod-midi-merger.service /etc/systemd/system/multi-user.target.wants
ln -sf /usr/lib/systemd/system/mod-midi-merger-broadcaster.service /etc/systemd/system/multi-user.target.wants
ln -sf /usr/lib/systemd/system/firstboot.service /etc/systemd/system/multi-user.target.wants

adduser --no-create-home --system --group jack
adduser ${FIRST_USER_NAME} jack --quiet
adduser ${FIRST_USER_NAME} audio --quiet
adduser root jack --quiet
adduser jack audio --quiet

EOF

