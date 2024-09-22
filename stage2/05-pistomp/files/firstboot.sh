#!/bin/sh

/home/pistomp/pi-stomp/util/change-audio-card.sh iqaudio-codec
#/home/pistomp/pi-stomp/setup/pi-stomp-tweaks/modify_version.sh 3.0
sudo chown -R pistomp:pistomp /home/pistomp/
#cd /home/pistomp/pi-stomp
#git pull

cp /boot/firmware/config.txt /boot/firmware/config_orig.txt
cp /boot/firmware/config_pistomp.txt /boot/firmware/config.txt

sudo mv "$0" firstboot.done
sudo reboot
