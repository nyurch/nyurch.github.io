---
layout: post
title: Linux Mint XFCE. Домашній варіант.
category: [LINUX]
---
![linux logo](/assets/media/xfce.svg?style=head)  
Linux Mint XFCE з нуля до домашнього використання на реальному прикладі. Зібрав до купи бо є пара моментів.<!--more-->  
#### Доставляємо очевидний і не дуже софт
{% highlight shell %}sudo apt install clipit conky-all faenza-icon-theme git gnome-games gxneur mc pidgin samba spotify-client steam telegram-desktop tilda tldr thunar-gtkhash virtualbox wine{% endhighlight %}

#### Блог
- Ставлю ***Jekyll***:
{% highlight shell %}sudo apt-get install ruby-full build-essential zlib1g-dev
echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
gem install jekyll bundler{% endhighlight %}
- Клон репозиторія з **github**:
{% highlight shell %}cd ~/Documents
git clone https://github.com/nyurch/nyurch.github.io
cd nyurch.github.io
bundle update{% endhighlight %}
- Глобальні налаштування **git**:
{% highlight shell %}git config --global user.email "nicolas.yurchuk@gmail.com"
git config --global user.name "nyurch"{% endhighlight %}

#### Установка ACE Stream
{% highlight shell %}sudo rm /etc/apt/preferences.d/nosnap.pref
sudo apt update
sudo apt install snapd
sudo snap install acestreamplayer{% endhighlight %}

#### ACE Stream + Firefox
В профілі у файлі handlers.json в розділ schemes додати  
{% highlight json %}"ace":{"action":4,"ask":true}{% endhighlight %}
Перезавантажити.

#### NAS
Треба **cifs**
{% highlight shell %}sudo apt install cifs-utils{% endhighlight %}
_fstab_
{% highlight ini %}//server/share /media/Share cifs username=nnn,password=ppp,uid=1000,vers=1.0,noauto,user 0 0{% endhighlight %}
Перечитати _fstab_
{% highlight shell %}sudo mount -a{% endhighlight %}

#### NVME-диск
{% highlight shell %}sudo apt nvme-cli
chmod u+s nvme
nvme smart-log /dev/nvme0n1{% endhighlight %}
Або можна аналогічно використовувати **smartctl**

#### Steam
_Settings / Steam Play_ галочка **Enable Steam Play for all titles**.

#### Свистєлки і пердєлки
Аліаси і скрипти:
{% highlight ini %}# MY mod
export PS1="\[$(tput setaf 3)\][\D{ %m/%d/%Y } \A] \[$(tput setaf 1)\]\u@\h:\[$(tput setaf 4)\]\w $ \[$(tput sgr0)\]"

alias jkl='jekyll serve -s /home/deimos/Documents/GitHub/nyurch.github.io/ -d /home/deimos/Documents/GitHub/nyurch.github.io/_site/jekyll serve -s /home/deimos/Documents/GitHub/nyurch.github.io/ -d /home/deimos/Documents/GitHub/nyurch.github.io/_site/'
alias startconky1='conky -c ~/.config/conky/informant/inf-orange.conkyrc'
alias startconky2='conky -c ~/.conkycolors/conkyrc'
alias runconky='/home/deimos/run_conky.sh'
alias gitsite='/home/deimos/gitsite.sh'
alias upgrd='sudo apt update && sudo apt dist-upgrade -y'{% endhighlight %}

{% highlight bash %}#!/bin/bash
cd ~/Documents/GitHub/nyurch.github.io
git add --all
git commit -m "$(date +%x)"
git push -u origin master{% endhighlight %}

{% highlight bash %}#!/bin/bash
conky -c ~/.config/conky/informant/inf-orange.conkyrc &{% endhighlight %}

Conky:
[![Conky](/assets/media/conky_my.jpg?style=blog "new-bash")](/assets/media/conky_my.jpg "install tcm"){:target="\_blank"}  
Модифікований inf-orange.conkyrc, оригінал [тут](https://download.wsusoffline.net/ "Conky Informant"){:target="_blank"}
{% highlight ini %}
conky.config = {
own_window_class = 'Conky',
own_window = true,
own_window_type = 'normal',
own_window_transparent = true,
own_window_argb_visual = true,
own_window_argb_value = 255,
own_window_hints = 'undecorated,below,skip_taskbar,skip_pager,sticky',
minimum_width = 200, 
minimum_height = 200,
maximum_width = 800,
gap_x = 20,
gap_y = 0,
alignment = 'top_right',
use_xft = true,
font = 'Roboto:size=10',
xftalpha = 1,
override_utf8_locale = true,
uppercase = false,
draw_shades = false,
default_shade_color = 'black',
draw_outline = false,
default_outline_color = 'black',
default_color = '#ffa726',-- orange
color0 = '#ffffff',-- purewhite
color1 = '#777777',-- Gray
color2 = '#D8BFD8',-- Thistle
color3 = '#9ACD32',-- YellowGreen
color4 = '#FFA07A',-- LightSalmon
color5 = '#FFDEAD',-- NavajoWhite
color6 = '#00BFFF',-- DeepSkycyan
color7 = '#5F9EA0',-- Cadetcyan
color8 = '#BDB76B',-- DarkKhaki
color9 = '#CD5C5C',-- IndianRed
draw_borders = false,
stippled_borders = 5,
border_inner_margin = 5,
border_outer_margin = 0,
border_width = 2,
draw_graph_borders = true,
background = true,
use_spacer = 'none',
no_buffers = true,
short_units = true,
pad_percents = 2,
imlib_cache_size = 0,
double_buffer = true,
update_interval = 1,
};

conky.text = [[
${font Roboto:Light:size=82}$alignr${time %H}${color0}:${time %M}${font}${color}
${font Roboto:Light:size=34}${voffset 12}$alignr${color0}${execi 300 LANG=uk_UA.UTF-8 LC_TIME=uk_UA.UTF-8 date +"%A"}${color},\
 ${execi 300 LANG=uk_UA.UTF-8 LC_TIME=uk_UA.UTF-8 date +"%d"}\
${color0} ${execi 300 LANG=uk_UA.UTF-8 LC_TIME=uk_UA.UTF-8 date +"%B"}${font}${voffset 2}
${font Mono:size=18}${alignc}${goto 450}ПН ВВ СР ЧТ ПТ СБ НД
${alignc}${goto 450}${color}${execpi 1800 LAR=`date +%-d`; ncal -bh | sed '2d' | sed -e '1d' -e 's/\<'$LAR'\>/${color0}&${color}/' | sed ':a;N;$!ba;s/\n/\n${goto 450}/g'}${color}${font}${color0}
${hr}${color}${voffset 4}
${font Roboto:pixelsize=23}${alignr} USER: ${color0}${execi 5000 whoami}${color} ${color1}I${color} MACHINE: ${color0}$nodename${color} ${color1}I${color} UPTIME: ${color0}$uptime${color}
${font Roboto:pixelsize=23}${alignr} DISTRIBUTION: ${color0}${execi 6000 awk -F'=' '/DESCRIPTION/ {print $2}' /etc/lsb-release |sed 's/"//g'}${color} ${color1}I${color} VERSION: ${color0}${execi 6000 awk -F'=' '/DISTRIB_RELEASE=/ {printf $2" "} /CODENAME/ {print $2}' /etc/lsb-release}${color}
${font Roboto:pixelsize=23}${alignr} ARCHITECTURE: ${color0}${machine}${color} ${color1}I${color} KERNEL: ${color0}${kernel}${color}
${font Roboto:pixelsize=23}${alignr} ROOT: ${color0}${fs_used /}${color} / ${color0}${fs_size /}${color} ${color1}I${color} HOME: ${color0}${fs_used /home}${color} / ${color0}${fs_size /home}${color} DATA: ${color0}${fs_used /home/deimos/Temp}${color} / ${color0}${fs_size /home/deimos/Temp}${color}
${font Roboto:pixelsize=23}${alignr} CPU: ${color0}${cpu cpu0}%${color} ${color1}I${color} RAM: ${color0}$mem / $memmax${color} HD: ${color0}${fs_used_perc}%${color}
${font Roboto:pixelsize=23}${alignr} SWAP: ${color0}${swap} / ${swapmax}${color} ${color1}I${color} SYS TEMP: ${color0}${hwmon temp 1}°C${color}
${font Roboto:pixelsize=23}${alignr} YOU CAN INSTALL ${color0}${execpi 12000 aptitude search "~U" | wc -l} UPDATE(S)${voffset 2}
${hr}${color}${voffset 4}
${font Roboto:pixelsize=23}${alignr} LOCAL IP: ${color0}${addr enp34s0}${color}
${font Roboto:pixelsize=23}${alignr} ${color0}${downspeed enp34s0}${color} DOWNLOAD SPEED
${font Roboto:pixelsize=23}${alignr} ${color0}${upspeed enp34s0}${color} UPLOAD SPEED${voffset 2}
${color0}${hr}${color}${voffset 4}
${font Roboto:pixelsize=23}${alignr} Crucial 500GB: ${color0}${execi 120 hddtemp /dev/sdb -n}${color}°C
${font Roboto:pixelsize=23}${alignr} Crucial 250GB: ${color0}${execi 120 hddtemp /dev/sdd -n}${color}°C
${font Roboto:pixelsize=23}${alignr} Seagate 1TB: ${color0}${execi 120 hddtemp /dev/sda -n}${color}°C
${font Roboto:pixelsize=23}${alignr} Seagate 1.5TB: ${color0}${execi 120 hddtemp /dev/sdd -n}${color}°C
${font Roboto:pixelsize=23}${alignr} WD 500GB: ${color0}${execi 120 smartctl -A /dev/nvme0 | awk 'FNR==7 {print $2}'}${color}°C
]]{% endhighlight %}

Шаблони для md-файлів для блогу і для sh-файлів.

#### Костилі
- Світла тема дає контури при використанні ***Compiz*** і не тільки. Поки тавимо **Mint-Y-***
- У ***Firefox*** щоб заховати **title bar** переходимо в налаштування панелі інструментів і знімаємо галочку зліва внизу.
- Рукожопний значок ***Viber*** в треї лікується запуском так **dbus-launch /opt/viber/Viber** або заміною відповідного рядку у ярлику на наступний
**Exec=dbus-launch /opt/viber/Viber**
