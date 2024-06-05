#!/bin/bash -e

echo "Installing Python PIP packages"
on_chroot << EOF

pip3 install pyserial==3.0 pystache==0.5.4 aggdraw==1.3.11 scandir backports.shutil-get-terminal-size --break-system-packages
pip3 install pycryptodomex --break-system-packages
pip3 install tornado==4.3 --break-system-packages
pip3 install Pillow==9.4.0 --break-system-packages
pip3 install cython --break-system-packages
pip3 install pyyaml --break-system-packages
pip3 install pyalsaaudio --break-system-packages
pip3 install python-rtmidi --break-system-packages
pip3 install requests --break-system-packages
pip3 install gfxhat --break-system-packages
pip3 install adafruit-circuitpython-rgb-display --break-system-packages
pip3 install python-config --break-system-packages
pip3 install adafruit-circuitpython-mcp3xxx --break-system-packages
pip3 install matplotlib --break-system-packages
pip3 install rpi_ws281x --break-system-packages
pip3 install adafruit-circuitpython-neopixel --break-system-packages
pip3 install jsonschema --break-system-packages
pip3 install flask --break-system-packages
pip3 install unicategories --break-system-packages
pip3 install scandir --break-system-packages
pip3 install pep8 --break-system-packages
pip3 install flake8 --break-system-packages
pip3 install coverage --break-system-packages
pip3 install pyaml --break-system-packages
pip3 install sphinx --break-system-packages
pip3 install netifaces==0.10.5 --break-system-packages
pip3 install mido==1.1.24 --break-system-packages
pip3 install docopt==0.6.2 --break-system-packages

EOF
echo "Done installing PIP packages"
