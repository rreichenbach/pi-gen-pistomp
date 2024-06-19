#!/bin/sh

/home/pistomp/pi-stomp/util/change-audio-card.sh iqaudio-codec
/home/pistomp/pi-stomp/setup/pi-stomp-tweaks/modify_version.sh 3.0
sudo chown -R pistomp:pistomp /home/pistomp/data
cd /home/pistomp/pi-stomp
git pull
sudo mv "$0" firstboot.done
sudo reboot
