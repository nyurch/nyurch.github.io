---
layout: post
title: Постустановочне налаштування elementary os.
category: [LINUX]
---
![elementary logo](/media/elementary.png?style=head)  
Невеликий скрипт для післяустановочного налаштування ***elementary os*** майже повністю підходить і для ***ubuntu***. Основні підтримувані функції:<!--more-->
- Задання та очищення налаштувань проксі;
- Оновлення системи та очищення кешу apt;
- Додавання репозиторіїв та установка обраного програмного забезпечення;
- Установка ***dropbox*** для ***elementary os***;
- Установка ***teamviewer***;

Текст скрипта:
  {% highlight shell %}#!/bin/bash
# Шапка-костиль, нічого не використовується.
ROOT_UID=0 #Лише користувач з $UID 0 має права root.
E_XCD=86 #Неможливо змінити директорію?
E_NOTROOT=87 #Вихід з помилкою "не root".

clear
echo "Варіанти запуску:"
echo "==========================================================="
echo -e "*\t[1] Задати проксі                                 *"
echo -e "*\t[2] Очистити проксі                               *"
echo -e "*\t[3] Оновити систему                               *"
echo -e "*\t[4] Очистити кеш apt та видалити застарілі файли  *"
echo -e "*\t[5] Додати репозиторії                            *"
echo -e "*\t[6] Вибір програм для встановлення                *"
echo -e "*\t[7] Установка dropbox для elementary os           *"
echo -e "*\t[8] Установка teamviewer                          *"
echo -e "*\t[9] Вихід                                         *"
echo -e "===========================================================\n"
echo -n "Обрати варіант: "; read doing

case $doing in
1)
clear
cp ~/.bashrc ~/.bashrc.bak
sudo cp /etc/sudoers /etc/sudoers.bak
sudo cp /etc/wgetrc /etc/wgetrc.bak
echo -n "Ввести проксі у форматі http://проксі:порт : "; read PURL
echo "Налаштування проксі-сервера прописані у .bashrc"
echo -e "#########Змінено Я#########\nexport http_proxy=\"$PURL/\"\nexport https_proxy=\"$PURL/\"\nexport ftp_proxy=\"$PURL/\"" >> ~/.bashrc
echo "Налаштування проксі-сервера прописані у /etc/wgetrc"
sudo sh -c "echo '\n#########Змінено Я#########\nhttps_proxy = $PURL/\nhttp_proxy = $PURL/\nftp_proxy = $PURL/\nuse_proxy = on' >> /etc/wgetrc"
echo "Налаштування проксі-сервера прописані у /etc/sudoers"
sudo sh -c "echo '\n#########Змінено Я#########\nDefaults env_keep += \"http_proxy https_proxy ftp_proxy all_proxy no_proxy\"' >> /etc/sudoers"
echo -e "Налаштування проксі-сервера прописані у /etc/apt/apt.conf.d/02proxy\n"
sudo sh -c "echo '\n#########Змінено Я#########\nAcquire::http::Proxy \"$PURL\";' > /etc/apt/apt.conf.d/02proxy"
;;
2)
clear
mv ~/.bashrc.bak ~/.bashrc
sudo mv /etc/sudoers.bak /etc/sudoers
sudo mv /etc/wgetrc.bak /etc/wgetrc
sudo rm -r /etc/apt/apt.conf.d/02proxy
;;
3)
echo -e "\n"
sudo apt update && sudo apt -y dist-upgrade
;;
4)
echo -e "\n"
sudo apt -y clean && sudo apt -y autoremove
;;
5)
echo -e "\n"
sudo apt -y install software-properties-common python3-software-properties python-software-properties
sudo add-apt-repository -y $(zenity --list --text="ВИБРАТИ РЕПОЗИТОРІЙ ДЛЯ ПІДКЛЮЧЕННЯ:" \
    --checklist --multiple --column "Вибір" --column "Репозиторій" --separator=" " --column "Опис"\
    FALSE "ppa:atareao/atareao" "my weather indicator"\
    FALSE "ppa:philip.scott/elementary-tweaks" "elementary-tweaks"\
    FALSE "ppa:otto-kesselgulasch/gimp-edge" "gimp beta"\
    FALSE "ppa:alessandro-strada/ppa" "google drive"\
    --height=750 --width=700)
sudo apt update && sudo apt -y dist-upgrade
;;
6)
echo -e "\n"
sudo apt -y install $(zenity --list --text="ВИБРАТИ ПРОГРАМИ ДЛЯ ВСТАНОВЛЕННЯ:\n * - вимагає підключення додаткового репозиторію" \
    --checklist --multiple --column "Вибір" --column "Програма" --separator=" " --column "Опис"\
    FALSE "aptitude" "High-level interface to the package manager"\
    FALSE "audacity" "Graphical cross-platform audio editor"\
    FALSE "baobab" "GNOME disk usage analyzer"\
    FALSE "clipit" "Lightweight GTK+ Clipboard Manager"\
    FALSE "easytag" "Tag editor for MP3, Ogg Vorbis files and more"\
    FALSE "elementary-tweaks" "* Change hidden desktop settings"\
    FALSE "firefox" "A free and open source web browser from Mozilla"\
    FALSE "gimp" "An image manipulation and paint program"\
    FALSE "glances" "Curses-based monitoring tool"\
    FALSE "gnome-nettool" "Network information tool for GNOME"\
    FALSE "google-drive-ocamlfuse" "FUSE filesystem backed by Google Drive"\
    FALSE "libreoffice" "LibreOffice office suite"\
    FALSE "mc" "Visual shell for Unix-like systems"\
    FALSE "minitube" "Native YouTube client"\
    FALSE "my-weather-indicator" "* Get weather information for your town with My-Weather-Indicator"\
    FALSE "pidgin" "Instant Messaging client"\
    FALSE "remmina" "Remote desktop client for GNOME desktop environment"\
    FALSE "samba" "SMB/CIFS file, print, and login server for Unix"\
    FALSE "ssh" "OpenSSH SSH client (Remote login program)"\
    FALSE "telegram-purple" "Модуль telegram для pidgin"\
    FALSE "qbittorrent" "Bittorrent client based on libtorrent-rasterbar with a Qt4 GUI"\
    FALSE "ubuntu-restricted-extras" "Commonly used media codecs and fonts for Ubuntu"\
    FALSE "virtualbox" "x86 virtualization solution"\
    FALSE "virtualbox-guest-additions-iso" "Guest additions iso image for VirtualBox"\
    FALSE "vlc" "Multimedia player and streamer"\
    --height=750 --width=700)
;;
7)
echo -e "\n"
git clone https://github.com/zant95/elementary-dropbox /tmp/elementary-dropbox
bash /tmp/elementary-dropbox/install.sh -n
;;
8)
sudo dpkg --add-architecture i386
sudo apt update
wget https://download.teamviewer.com/download/teamviewer_i386.deb
sudo dpkg -i teamviewer_i386.deb
sudo apt -y install -f
;;
9)
clear && exit 0
;;
*)
echo -e "\n"
echo "Обрана не правильна дія."

esac

sleep 10 && ./case.sh{% endhighlight %}

Виглядає якось так:

[![screenshot](/media/screen-0.png?style=blog "screenshot")](/media/screen-0.png "screenshot"){:target="_blank"}  
[![screenshot](/media/screen-1.png?style=blog "screenshot")](/media/screen-1.png "screenshot"){:target="_blank"}  
[![screenshot](/media/screen-2.png?style=blog "screenshot")](/media/screen-2.png "screenshot"){:target="_blank"}
