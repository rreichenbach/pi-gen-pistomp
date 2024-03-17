#!/bin/bash -e

install -m 644 files/sys/.bash_aliases ${ROOTFS_DIR}/home/${FIRST_USER_NAME}
install -m 644 files/hotspot/usr/lib/pistomp-wifi/disable_wifi_hotspot.sh ${ROOTFS_DIR}/usr/lib/pistomp-wifi
install -m 644 files/hotspot/usr/lib/pistomp-wifi/enable_wifi_hotspot.sh ${ROOTFS_DIR}/usr/lib/pistomp-wifi
install -m 644 files/hotspot/etc/default/hostapd.pistomp ${ROOTFS_DIR}/etc/default/
install -m 644 files/hotspot/etc/dnsmasq.d/wifi-hotspot.conf ${ROOTFS_DIR}/etc/dnsmasq.d/
install -m 644 files/hotspot/etc/hostapd/hostapd.conf ${ROOTFS_DIR}/etc/hostapd/
install -m 644 files/config_templates/default_config.yml ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/data/configs/

echo "Installing MOD software"
on_chroot << EOF

dpkg -i files/sys/linux-image-5.15.65-rt49-v8+_5.15.65-rt49-v8+-2_arm64.deb
dpkg -i files/sys/linux-image-6.1.54-rt15-v8+_6.1.54-rt15-v8+-2_arm64.deb
dpkg -i files/sys/linux-libc-dev_6.1.54-rt15-v8+-2_arm64.deb
dpkg -i files/sys/linux-headers-6.1.54-rt15-v8+_6.1.54-rt15-v8+-2_arm64.deb

KERN1=5.15.65-rt49-v8+
mkdir -p /boot/$KERN1/o/
cp -d /usr/lib/linux-image-$KERN1/overlays/* /boot/$KERN1/o/
cp -dr /usr/lib/linux-image-$KERN1/* /boot/$KERN1/
cp -d /usr/lib/linux-image-$KERN1/broadcom/* /boot/$KERN1/
touch /boot/$KERN1/o/README
mv /boot/vmlinuz-$KERN1 /boot/$KERN1/
mv /boot/initrd.img-$KERN1 /boot/$KERN1/
mv /boot/System.map-$KERN1 /boot/$KERN1/
cp /boot/config-$KERN1 /boot/$KERN1/

KERN2=6.1.54-rt15-v8+
mkdir -p /boot/$KERN2/o/
cp -d /usr/lib/linux-image-$KERN2/overlays/* /boot/$KERN2/o/
cp -dr /usr/lib/linux-image-$KERN2/* /boot/$KERN2/
cp -d /usr/lib/linux-image-$KERN2/broadcom/* /boot/$KERN2/
touch /boot/$KERN2/o/README
mv /boot/vmlinuz-$KERN2 /boot/$KERN2/
mv /boot/initrd.img-$KERN2 /boot/$KERN2/
mv /boot/System.map-$KERN2 /boot/$KERN2/
cp /boot/config-$KERN2 /boot/$KERN2/

echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

EOF

sed -i 's/exit 0//' ${ROOTFS_DIR}/etc/rc.local
sed -i 's/console=serial0,115200//' ${ROOTFS_DIR}/boot/cmdline.txt
sed -i \"s/^\s*dtparam=audio/#dtparam=audio/\" ${ROOTFS_DIR}/boot/config.txt
sed -i \"s/^\s*hdmi_force_hotplug=/#hdmi_force_hotplug=/\" ${ROOTFS_DIR}/boot/config.txt
sed -i \"s/^\s*camera_auto_detect=/#camera_auto_detect=/\" ${ROOTFS_DIR}/boot/config.txt
sed -i \"s/^\s*display_auto_detect=/#display_auto_detect=/\" ${ROOTFS_DIR}/boot/config.txt
sed -i \"s/^\s*dtoverlay=vc4-kms-v3d/#dtoverlay=vc4-kms-v3d/\" ${ROOTFS_DIR}/boot/config.txt
sed -i \"s/^\s*#dtparam=spi=on/dtparam=spi=on/\" ${ROOTFS_DIR}/boot/config.txt
sed -i \"s/^\s*#dtparam=i2s=on/dtparam=i2s=on/\" ${ROOTFS_DIR}/boot/config.txt
sed -i \"s/^\s*#dtparam=i2c_arm=on/dtparam=i2c_arm=on/\" ${ROOTFS_DIR}/boot/config.txt

cat >> ${ROOTFS_DIR}/boot/config.txt <<EOF

# pi-stomp additions to allow DIN Midi, disables bluetooth however
enable_uart=1
dtoverlay=pi3-disable-bt
dtoverlay=pi3-miniuart-bt
dtoverlay=midi-uart0
dtoverlay=dwc2,dr_mode=host
EOF

cat >> ${ROOTFS_DIR}/boot/config.txt << EOF
[pi3]
kernel=vmlinuz-$KERN1
# initramfs initrd.img-$KERN1
os_prefix=$KERN1/
overlay_prefix=o/
arm_64bit=1
[pi3]
EOF

cat >> ${ROOTFS_DIR}/boot/config.txt << EOF
[pi4]
kernel=vmlinuz-$KERN2
# initramfs initrd.img-$KERN
os_prefix=$KERN2/
overlay_prefix=o/
arm_64bit=1
[pi4]
EOF

cat >> ${ROOTFS_DIR}/boot/config.txt <<EOF

# enable the sound card (uncomment only one)
#dtoverlay=audioinjector-wm8731-audio
dtoverlay=iqaudio-codec
#dtoverlay=hifiberry-dacplusadc
EOF

cat >> ${ROOTFS_DIR}/etc/rc.local <<EOF

sudo alsactl restore -f /var/lib/alsa/asound.state
(sleep 10;/etc/wpa_supplicant/wifi_check.sh) &
exit 0
EOF
