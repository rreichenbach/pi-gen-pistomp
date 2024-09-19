#!/bin/bash -e

install -m 644 files/sys/.bash_aliases ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/
install -m 644 files/hotspot/usr/lib/pistomp-wifi/disable_wifi_hotspot.sh ${ROOTFS_DIR}/usr/lib/pistomp-wifi/
install -m 644 files/hotspot/usr/lib/pistomp-wifi/enable_wifi_hotspot.sh ${ROOTFS_DIR}/usr/lib/pistomp-wifi/
install -m 644 files/hotspot/etc/default/hostapd.pistomp ${ROOTFS_DIR}/etc/default/
install -m 644 files/hotspot/etc/dnsmasq.d/wifi-hotspot.conf ${ROOTFS_DIR}/etc/dnsmasq.d/
install -m 644 files/hotspot/etc/hostapd/hostapd.conf ${ROOTFS_DIR}/etc/hostapd/
install -m 644 files/config_templates/default_config.yml ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/data/config/
install -m 644 files/config_templates/default-hardware-descriptor.json ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/data/config/
install -m 644 files/sys/linux-image-6.1.54-rt15-v8+_6.1.54-rt15-v8+-2_arm64.deb ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/tmp/
install -m 644 files/sys/linux-headers-6.1.54-rt15-v8+_6.1.54-rt15-v8+-2_arm64.deb ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/tmp/
install -m 644 files/sys/linux-libc-dev_6.1.54-rt15-v8+-2_arm64.deb ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/tmp/
install -m 644 files/advertise.diff ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/tmp/

echo "Installing MOD software"
on_chroot << EOF

cd /home/${FIRST_USER_NAME}/tmp

patch -b -N -u /usr/local/lib/python3.11/dist-packages/touchosc2midi/advertise.py -i advertise.diff

dpkg -i linux-headers-6.1.54-rt15-v8+_6.1.54-rt15-v8+-2_arm64.deb
dpkg -i linux-libc-dev_6.1.54-rt15-v8+-2_arm64.deb
dpkg -i linux-image-6.1.54-rt15-v8+_6.1.54-rt15-v8+-2_arm64.deb

rm -rf /home/${FIRST_USER_NAME}/tmp

KERN2=6.1.54-rt15-v8+
mkdir -p /boot/firmware/6.1.54-rt15-v8+/o/
cp -d /usr/lib/linux-image-6.1.54-rt15-v8+/overlays/* /boot/firmware/6.1.54-rt15-v8+/o/
cp -dr /usr/lib/linux-image-6.1.54-rt15-v8+/* /boot/firmware/6.1.54-rt15-v8+/
cp -d /usr/lib/linux-image-6.1.54-rt15-v8+/broadcom/* /boot/firmware/6.1.54-rt15-v8+/
touch /boot/firmware/6.1.54-rt15-v8+/o/README
mv /boot/vmlinuz-6.1.54-rt15-v8+ /boot/firmware/6.1.54-rt15-v8+/
mv /boot/initrd.img-6.1.54-rt15-v8+ /boot/firmware/6.1.54-rt15-v8+/
mv /boot/System.map-6.1.54-rt15-v8+ /boot/firmware/6.1.54-rt15-v8+/
cp /boot/config-6.1.54-rt15-v8+ /boot/firmware/6.1.54-rt15-v8+/

EOF

bash -c "sed -i 's/exit 0//' ${ROOTFS_DIR}/etc/rc.local"
bash -c "sed -i 's/console=serial0,115200//' ${ROOTFS_DIR}/boot/firmware/cmdline.txt"

#bash -c "sed -i \"s/^\s*dtparam=audio/#dtparam=audio/\" ${ROOTFS_DIR}/boot/firmware/config.txt"
#bash -c "sed -i \"s/^\s*hdmi_force_hotplug=/#hdmi_force_hotplug=/\" ${ROOTFS_DIR}/boot/firmware/config.txt"
#bash -c "sed -i \"s/^\s*camera_auto_detect=/#camera_auto_detect=/\" ${ROOTFS_DIR}/boot/firmware/config.txt"
#bash -c "sed -i \"s/^\s*display_auto_detect=/#display_auto_detect=/\" ${ROOTFS_DIR}/boot/firmware/config.txt"
#bash -c "sed -i \"s/^\s*dtoverlay=vc4-kms-v3d/#dtoverlay=vc4-kms-v3d/\" ${ROOTFS_DIR}/boot/firmware/config.txt"
#bash -c "sed -i \"s/^\s*#dtparam=spi=on/dtparam=spi=on/\" ${ROOTFS_DIR}/boot/firmware/config.txt"
#bash -c "sed -i \"s/^\s*#dtparam=i2s=on/dtparam=i2s=on/\" ${ROOTFS_DIR}/boot/firmware/config.txt"
#bash -c "sed -i \"s/^\s*#dtparam=i2c_arm=on/dtparam=i2c_arm=on/\" ${ROOTFS_DIR}/boot/firmware/config.txt"

install -m 644 files/config_pistomp.txt ${ROOTFS_DIR}/boot/firmware


#cat >> ${ROOTFS_DIR}/etc/rc.local <<EOF
#sudo alsactl restore -f /var/lib/alsa/asound.state
#(sleep 10;/usr/lib/pistomp-wifi/wifi_check.sh) &
#exit 0
#EOF
