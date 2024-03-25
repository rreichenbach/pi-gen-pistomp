#!/bin/sh

set -x
set -e

if [ ! -e ~/.config/pistomp-first-run ]; then
	mkdir ~/.config
	touch ~/.config/pistomp-first-run
	sudo chmod +x /etc/update-motd.d/display-pistomp-logo
        sudo chown -R pistomp:pistomp /home/pistomp
	sudo chmod +x /etc/jackdrc
	sudo chown jack:jack /etc/jackdrc
	sudo chmod 500 /etc/authbind/byport/80
	sudo chown pistomp:pistomp /etc/authbind/byport/80
	sudo chown -R pistomp:pistomp /usr/lib/pistomp-wifi
	sudo chmod +x -R /usr/lib/pistomp-wifi
	/home/pistomp/pi-stomp/setup/pi-stomp-tweaks/modify_version.sh 2.0
	/home/pistomp/pi-stomp/util/change-audio-card.sh iqaudio-codec
	sudo ln -sf /usr/lib/systemd/system/browsepy.service /etc/systemd/system/multi-user.target.wants
	sudo ln -sf /usr/lib/systemd/system/jack.service /etc/systemd/system/multi-user.target.wants
	sudo ln -sf /usr/lib/systemd/system/mod-host.service /etc/systemd/system/multi-user.target.wants
	sudo ln -sf /usr/lib/systemd/system/mod-ui.service /etc/systemd/system/multi-user.target.wants
	sudo ln -sf /usr/lib/systemd/system/mod-amidithru.service /etc/systemd/system/multi-user.target.wants
	sudo ln -sf /usr/lib/systemd/system/mod-touchosc2midi.service /etc/systemd/system/multi-user.target.wants
	sudo ln -sf /usr/lib/systemd/system/mod-midi-merger.service /etc/systemd/system/multi-user.target.wants
	sudo ln -sf /usr/lib/systemd/system/mod-midi-merger-broadcaster.service /etc/systemd/system/multi-user.target.wants
	sudo ln -sf /usr/lib/systemd/system/mod-ala-pi-stomp.service /etc/systemd/system/multi-user.target.wants
	sudo raspi-config nonint do_boot_wait 1
	sudo echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
	clear && cat /run/motd.dynamic
	sudo rm /etc/profile.d/bash_completion.sh
fi
