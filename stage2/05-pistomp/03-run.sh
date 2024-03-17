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

mkdir -p /home/${FIRST_USER_NAME}/tmp
cd /home/${FIRST_USER_NAME}/tmp

wget https://github.com/kdoren/linux/releases/download/rpi_5.15.65-rt49/linux-image-5.15.65-rt49-v8+_5.15.65-1_arm64.deb
wget https://github.com/kdoren/linux/releases/download/rpi_6.1.54-rt15/linux-headers-6.1.54-rt15-v8+_6.1.54-1_arm64.deb
wget https://github.com/kdoren/linux/releases/download/rpi_6.1.54-rt15/linux-image-6.1.54-rt15-v8+_6.1.54-1_arm64.deb
wget https://github.com/kdoren/linux/releases/download/rpi_6.1.54-rt15/linux-libc-dev_6.1.54-1_arm64.deb

dpkg -i linux-image-5.15.65-rt49-v8+_5.15.65-1_arm64.deb
dpkg -i linux-image-6.1.54-rt15-v8+_6.1.54-1_arm64.deb
dpkg -i linux-libc-dev_6.1.54-1_arm64.deb
dpkg -i linux-headers-6.1.54-rt15-v8+_6.1.54-1_arm64.deb

KERN1=5.15.65-rt49-v8+
mkdir -p /boot/5.15.65-rt49-v8+/o/
cp -d /usr/lib/linux-image-5.15.65-rt49-v8+/overlays/* /boot/5.15.65-rt49-v8+/o/
cp -dr /usr/lib/linux-image-5.15.65-rt49-v8+/* /boot/5.15.65-rt49-v8+/
cp -d /usr/lib/linux-image-5.15.65-rt49-v8+/broadcom/* /boot/5.15.65-rt49-v8+/
touch /boot/5.15.65-rt49-v8+/o/README
mv /boot/vmlinuz-5.15.65-rt49-v8+ /boot/5.15.65-rt49-v8+/
mv /boot/initrd.img-5.15.65-rt49-v8+ /boot/5.15.65-rt49-v8+/
mv /boot/System.map-5.15.65-rt49-v8+ /boot/5.15.65-rt49-v8+/
cp /boot/config-5.15.65-rt49-v8+ /boot/5.15.65-rt49-v8+/

KERN2=6.1.54-rt15-v8+
mkdir -p /boot/6.1.54-rt15-v8+/o/
cp -d /usr/lib/linux-image-6.1.54-rt15-v8+/overlays/* /boot/6.1.54-rt15-v8+/o/
cp -dr /usr/lib/linux-image-6.1.54-rt15-v8+/* /boot/6.1.54-rt15-v8+/
cp -d /usr/lib/linux-image-6.1.54-rt15-v8+/broadcom/* /boot/6.1.54-rt15-v8+/
touch /boot/6.1.54-rt15-v8+/o/README
mv /boot/vmlinuz-6.1.54-rt15-v8+ /boot/6.1.54-rt15-v8+/
mv /boot/initrd.img-6.1.54-rt15-v8+ /boot/6.1.54-rt15-v8+/
mv /boot/System.map-6.1.54-rt15-v8+ /boot/6.1.54-rt15-v8+/
cp /boot/config-6.1.54-rt15-v8+ /boot/6.1.54-rt15-v8+/

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
kernel=vmlinuz-5.15.65-rt49-v8+
# initramfs initrd.img-5.15.65-rt49-v8+
os_prefix=5.15.65-rt49-v8+/
overlay_prefix=o/
arm_64bit=1
[pi3]
EOF

cat >> ${ROOTFS_DIR}/boot/config.txt << EOF
[pi4]
kernel=vmlinuz-6.1.54-rt15-v8+
# initramfs initrd.img-6.1.54-rt15-v8+
os_prefix=6.1.54-rt15-v8+/
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
