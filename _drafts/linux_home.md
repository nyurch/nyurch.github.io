---
layout: post
title: Linux Mint XFCE. Домашній варіант.
category: [LINUX]
---
![linux logo](/assets/media/xfce.svg?style=head)  
Linux Mint XFCE з нуля до домашнього використання на реальному прикладі. Зібрав до купи бо є пара моментів.<!--more-->  
#### Доставляємо очевидний і не дуже софт
{% highlight shell_session %}sudo apt install clipit conky-all faenza-icon-theme git gnome-games gxneur mc pidgin samba spotify-client steam telegram-desktop tilda tldr thunar-gtkhash virtualbox wine{% endhighlight %}

#### Блог
- Ставлю ***Jekyll***:
{% highlight shell_session %}sudo apt-get install ruby-full build-essential zlib1g-dev
echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
gem install jekyll bundler{% endhighlight %}
- Клон репозиторія з **github**:
{% highlight shell_session %}cd ~/Documents
git clone https://github.com/nyurch/nyurch.github.io
cd nyurch.github.io
bundle update{% endhighlight %}
- Глобальні налаштування **git**:
{% highlight shell_session %}git config --global user.email "nicolas.yurchuk@gmail.com"
git config --global user.name "nyurch"{% endhighlight %}

#### Установка ACE Stream
{% highlight shell_session %}sudo rm /etc/apt/preferences.d/nosnap.pref
sudo apt update
sudo apt install snapd
sudo snap install acestreamplayer{% endhighlight %}

#### ACE Stream + Firefox
В профілі у файлі handlers.json в розділ schemes додати  
{% highlight json %}"ace":{"action":4,"ask":true}{% endhighlight %}
Перезавантажити.

#### NAS
Треба **cifs**
{% highlight shell_session %}sudo apt install cifs-utils{% endhighlight %}
_fstab_
{% highlight shell_session %}//server/share /media/Share cifs username=nnn,password=ppp,uid=1000,vers=1.0,noauto,user 0 0{% endhighlight %}
Перечитати _fstab_
{% highlight shell_session %}sudo mount -a{% endhighlight %}

#### NVME-диск
{% highlight shell_session %}sudo apt nvme-cli
chmod u+s nvme
nvme smart-log /dev/nvme0n1{% endhighlight %}
Або можна аналогічно використовувати **smartctl**

#### Steam
_Settings / Steam Play_ галочка **Enable Steam Play for all titles**.

#### Свистєлки і пердєлки
аліаси, конкі, шаблони, скрипти

#### Костилі
- Світла тема дає контури при використанні ***Compiz*** і не тільки. Поки тавимо **Mint-Y-***
- У ***Firefox*** щоб заховати **title bar** переходимо в налаштування панелі інструментів і знімаємо галочку зліва внизу.
- Рукожопний значок ***Viber*** в треї лікується запуском так **dbus-launch /opt/viber/Viber** або заміною відповідного рядку у ярлику на наступний
**Exec=dbus-launch /opt/viber/Viber**
