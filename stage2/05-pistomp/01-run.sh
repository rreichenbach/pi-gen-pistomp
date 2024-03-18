#!/bin/bash

install -m 666 files/services/*.service ${ROOTFS_DIR}/usr/lib/systemd/system/
install -m 666 files/jackdrc ${ROOTFS_DIR}/etc/
install -m 666 files/80 ${ROOTFS_DIR}/etc/authbind/byport/

echo "Creating folders and services"
on_chroot << EOF

mkdir -p /home/${FIRST_USER_NAME}/tmp
cd /home/${FIRST_USER_NAME}/tmp

wget https://www.treefallsound.com/downloads/lv2plugins.tar.gz
tar -zxf lv2plugins.tar.gz -C /home/${FIRST_USER_NAME}/
cd ..

git clone https://github.com/treefallsound/pi-stomp.git /home/${FIRST_USER_NAME}/pi-stomp

mkdir -p /home/${FIRST_USER_NAME}/data/.pedalboards
mkdir -p /home/${FIRST_USER_NAME}/data/user-files
mkdir -p /home/${FIRST_USER_NAME}/data/config
mkdir -p /usr/mod/scripts
mkdir -p "/home/${FIRST_USER_NAME}/data/user-files/Speaker Cabinets IRs"
mkdir -p "/home/${FIRST_USER_NAME}/data/user-files/Reverb IRs"
mkdir -p "/home/${FIRST_USER_NAME}/data/user-files/Audio Loops"
mkdir -p "/home/${FIRST_USER_NAME}/data/user-files/Audio Recordings"
mkdir -p "/home/${FIRST_USER_NAME}/data/user-files/Audio Samples"
mkdir -p "/home/${FIRST_USER_NAME}/data/user-files/Audio Tracks"
mkdir -p "/home/${FIRST_USER_NAME}/data/user-files/MIDI Clips"
mkdir -p "/home/${FIRST_USER_NAME}/data/user-files/MIDI Songs"
mkdir -p "/home/${FIRST_USER_NAME}/data/user-files/Hydrogen Drumkits"
mkdir -p "/home/${FIRST_USER_NAME}/data/user-files/SF2 Instruments"
mkdir -p "/home/${FIRST_USER_NAME}/data/user-files/SFZ Instruments"
mkdir -p "/home/${FIRST_USER_NAME}/data/user-files/Amplifier Profiles"
mkdir -p "/home/${FIRST_USER_NAME}/data/user-files/Aida DSP Models"
mkdir -p "/home/${FIRST_USER_NAME}/data/user-files/NAM Models"


ln -sf /usr/lib/systemd/system/browsepy.service /etc/systemd/system/multi-user.target.wants
ln -sf /usr/lib/systemd/system/jack.service /etc/systemd/system/multi-user.target.wants
ln -sf /usr/lib/systemd/system/mod-host.service /etc/systemd/system/multi-user.target.wants
ln -sf /usr/lib/systemd/system/mod-ui.service /etc/systemd/system/multi-user.target.wants
ln -sf /usr/lib/systemd/system/mod-amidithru.service /etc/systemd/system/multi-user.target.wants
ln -sf /usr/lib/systemd/system/mod-touchosc2midi.service /etc/systemd/system/multi-user.target.wants
ln -sf /usr/lib/systemd/system/mod-midi-merger.service /etc/systemd/system/multi-user.target.wants
ln -sf /usr/lib/systemd/system/mod-midi-merger-broadcaster.service /etc/systemd/system/multi-user.target.wants
ln -sf /usr/lib/systemd/system/mod-ala-pi-stomp.service /etc/systemd/system/multi-user.target.wants

adduser --no-create-home --system --group jack
adduser ${FIRST_USER_NAME} jack --quiet
adduser root jack --quiet
adduser jack audio --quiet

git clone https://github.com/TreeFallSound/pi-stomp-pedalboards.git /home/${FIRST_USER_NAME}/data/.pedalboards

ln -s /home/${FIRST_USER_NAME}/data/.pedalboards /home/${FIRST_USER_NAME}/.pedalboards
ln -s /home/${FIRST_USER_NAME}/.lv2 /home/${FIRST_USER_NAME}/data/.lv2

EOF

