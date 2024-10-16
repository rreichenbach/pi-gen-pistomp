# aliass for common pi-stomp operations (only intended to aid the memory of humans)
alias ps-restart='sudo systemctl restart mod-ala-pi-stomp'
alias ps-stop='sudo systemctl stop mod-ala-pi-stomp'
alias ps-run='sudo $HOME/pi-stomp/modalapistomp.py'
alias ps-journal='sudo journalctl -f -u mod-ala-pi-stomp'
alias ttymidi-enable='sudo ln -sf /usr/lib/systemd/system/ttymidi.service /etc/systemd/system/multi-user.target.wants; sudo systemctl restart ttymidi'
alias ttymidi-disable='sudo systemctl stop ttymidi; sudo rm /etc/systemd/system/multi-user.target.wants/ttymidi.service'
alias mod-restart='sudo systemctl restart mod-host mod-ui'
