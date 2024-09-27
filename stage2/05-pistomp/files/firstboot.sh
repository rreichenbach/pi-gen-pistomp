#!/bin/sh

logger --priority info --tag firstboot.sh "Started..."

#/home/pistomp/pi-stomp/setup/pi-stomp-tweaks/modify_version.sh 3.0
sudo chown -R pistomp:pistomp /home/pistomp/

sudo cp /boot/firmware/config.txt /boot/firmware/config_orig.txt
sudo cp /boot/firmware/config_pistomp.txt /boot/firmware/config.txt

#/home/pistomp/pi-stomp/util/change-audio-card.sh iqaudio-codec
sudo cp /home/pistomp/pi-stomp/setup/audio/iqaudiocodec.state /var/lib/alsa/asound.state

sudo mv "$0" /boot/firmware/firstboot.done
sudo reboot
