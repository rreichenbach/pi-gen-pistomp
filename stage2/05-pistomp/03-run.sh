#!/bin/bash -e

install -m 644 files/sys/.bash_aliases ${ROOTFS_DIR}/home/${FIRST_USER_NAME}
install -m 644 files/hotspot/usr/lib/pistomp-wifi/disable_wifi_hotspot.sh ${ROOTFS_DIR}/usr/lib/pistomp-wifi
install -m 644 files/hotspot/usr/lib/pistomp-wifi/enable_wifi_hotspot.sh ${ROOTFS_DIR}/usr/lib/pistomp-wifi
install -m 644 files/hotspot/etc/default/hostapd.pistomp ${ROOTFS_DIR}/etc/default/
install -m 644 files/hotspot/etc/dnsmasq.d/wifi-hotspot.conf ${ROOTFS_DIR}/etc/dnsmasq.d/
install -m 644 files/hotspot/etc/hostapd/hostapd.conf ${ROOTFS_DIR}/etc/hostapd/
install -m 644 files/config_templates/default_config.yml ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/data/config/
install -m 644 files/config_templates/default-hardware-descriptor.json ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/data/config/
install -m 644 files/sys/linux-image-6.6.32-rt32-v8+_6.6.32-gbe8498ee21aa-3_arm64.deb ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/tmp/
install -m 644 files/sys/linux-headers-6.6.32-rt32-v8+_6.6.32-gbe8498ee21aa-3_arm64.deb ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/tmp/
install -m 644 files/sys/linux-libc-dev_6.6.32-gbe8498ee21aa-3_arm64.deb ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/tmp/

echo "Installing MOD software"
on_chroot << EOF

cd /home/${FIRST_USER_NAME}/tmp

dpkg -i linux-headers-6.6.32-rt32-v8+_6.6.32-gbe8498ee21aa-3_arm64.deb
dpkg -i linux-libc-dev_6.6.32-gbe8498ee21aa-3_arm64.deb
dpkg -i linux-image-6.6.32-rt32-v8+_6.6.32-gbe8498ee21aa-3_arm64.deb

rm -rf /home/${FIRST_USER_NAME}/tmp

KERN2=6.6.32-rt32-v8+
mkdir -p /boot/firmware/6.6.32-rt32-v8+/o/
cp -d /usr/lib/linux-image-6.6.32-rt32-v8+/overlays/* /boot/firmware/6.6.32-rt32-v8+/o/
cp -dr /usr/lib/linux-image-6.6.32-rt32-v8+/* /boot/firmware/6.6.32-rt32-v8+/
cp -d /usr/lib/linux-image-6.6.32-rt32-v8+/broadcom/* /boot/firmware/6.6.32-rt32-v8+/
touch /boot/firmware/6.6.32-rt32-v8+/o/README
mv /boot/vmlinuz-6.6.32-rt32-v8+ /boot/firmware/6.6.32-rt32-v8+/
mv /boot/initrd.img-6.6.32-rt32-v8+ /boot/firmware/6.6.32-rt32-v8+/
mv /boot/System.map-6.6.32-rt32-v8+ /boot/firmware/6.6.32-rt32-v8+/
cp /boot/config-6.6.32-rt32-v8+ /boot/firmware/6.6.32-rt32-v8+/

EOF

bash -c "sed -i 's/exit 0//' ${ROOTFS_DIR}/etc/rc.local"
bash -c "sed -i 's/console=serial0,115200//' ${ROOTFS_DIR}/boot/firmware/cmdline.txt"
bash -c "sed -i \"s/^\s*dtparam=audio/#dtparam=audio/\" ${ROOTFS_DIR}/boot/firmware/config.txt"
bash -c "sed -i \"s/^\s*hdmi_force_hotplug=/#hdmi_force_hotplug=/\" ${ROOTFS_DIR}/boot/firmware/config.txt"
bash -c "sed -i \"s/^\s*camera_auto_detect=/#camera_auto_detect=/\" ${ROOTFS_DIR}/boot/firmware/config.txt"
bash -c "sed -i \"s/^\s*display_auto_detect=/#display_auto_detect=/\" ${ROOTFS_DIR}/boot/firmware/config.txt"
bash -c "sed -i \"s/^\s*dtoverlay=vc4-kms-v3d/#dtoverlay=vc4-kms-v3d/\" ${ROOTFS_DIR}/boot/firmware/config.txt"
bash -c "sed -i \"s/^\s*#dtparam=spi=on/dtparam=spi=on/\" ${ROOTFS_DIR}/boot/firmware/config.txt"
bash -c "sed -i \"s/^\s*#dtparam=i2s=on/dtparam=i2s=on/\" ${ROOTFS_DIR}/boot/firmware/config.txt"
bash -c "sed -i \"s/^\s*#dtparam=i2c_arm=on/dtparam=i2c_arm=on/\" ${ROOTFS_DIR}/boot/firmware/config.txt"

cat >> ${ROOTFS_DIR}/boot/firmware/config.txt <<EOF
# enable the sound card (uncomment only one)
#dtoverlay=audioinjector-wm8731-audio
dtoverlay=iqaudio-codec
#dtoverlay=hifiberry-dacplusadc
EOF

cat >> ${ROOTFS_DIR}/boot/firmware/config.txt <<EOF
# pi-stomp additions to allow DIN Midi, disables bluetooth however
enable_uart=1
dtoverlay=pi3-disable-bt
dtoverlay=pi3-miniuart-bt
dtoverlay=midi-uart0
dtoverlay=dwc2,dr_mode=host
EOF

cat >> ${ROOTFS_DIR}/boot/firmware/config.txt << EOF
[all]
kernel=vmlinuz-6.6.32-rt32-v8+
# initramfs initrd.img-6.6.32-rt32-v8+
os_prefix=6.6.32-rt32-v8+/
overlay_prefix=o/
arm_64bit=1
[all]
EOF

cat >> ${ROOTFS_DIR}/etc/rc.local <<EOF
sudo alsactl restore -f /var/lib/alsa/asound.state
(sleep 10;/etc/wpa_supplicant/wifi_check.sh) &
exit 0
EOF
