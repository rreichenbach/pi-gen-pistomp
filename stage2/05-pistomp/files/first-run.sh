#!/bin/sh

if [ ! -e ~/.config/pistomp-first-run ]; then
	mkdir ~/.config
	touch ~/.config/pistomp-first-run
	sudo chmod -x /etc/update-motd.d/display-pistomp-logo
    sudo chown -R pistomp:pistomp ${HOME}/
	sudo chmod +x /etc/jackdrc
	sudo chown jack:jack /etc/jackdrc
	sudo chmod 500 /etc/authbind/byport/80
	sudo chown pistomp:pistomp /etc/authbind/byport/80
	${HOME}/pi-stomp/setup/pi-stomp-tweaks/modify_version.sh 2.0
	${HOME}/pi-stomp/util/change-audio-card.sh iqaudio-codec
	${HOME}/pi-stomp/setup/pedalboards/get_pedalboards.sh
	clear && cat /run/motd.dynamic
fi