#!/bin/bash
while true; do
	clear
	echo "============================="
	echo "=   U P D A T E   M E N U   ="
	echo "============================="
	echo "1. Full System Update/Upgrade"
	echo "2. Clean and Fix APT Packages"
	echo "3. Install balenaEtcher"
	echo "4. Install Favorite Software"
	echo "5. Exit/Quit"
	echo "============================="
	read -p "Enter Selection: " nmbr
	if [ $nmbr -eq 1 ]; then
		sudo apt update
		sudo apt full-upgrade
		clear
		echo "Full system update completed"
	elif [ $nmbr -eq 2 ]; then
		sudo apt install -f
		sudo apt autoclean
		sudo apt autoremove
		clear
		echo "APT packages fixed and cleaned"
	elif [ $nmbr -eq 3 ]; then
		curl -1sLf \
		'https://dl.cloudsmith.io/public/balena/etcher/setup.deb.sh' \
		| sudo -E bash
		sudo apt-get update
		sudo apt-get install balena-etcher-electron
		clear
		echo "Etcher installed"
	elif [ $nmbr -eq 4 ]; then
		sudo apt install -yy stacer calibre kdenlive \
		krita libreoffice scribus virtualbox inkscape gimp \
		gparted gufw vlc simplescreenrecorder handbrake \
		audacity git bleachbit ttf-mscorefonts-installer
		clear
		echo "Favorite packages installed"
	elif [ $nmbr -eq 5 ]; then
		clear
		break
	else
		clear
		echo "Please select a number from the menu"
	fi
    sleep 3s
done
