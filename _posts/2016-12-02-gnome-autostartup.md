---
layout: post
title: Відкладений запуск програм у gnome/unity.
category: [LINUX]
---
![delay logo](/assets/media/autorun.jpeg?style=head)  
Файли що відповідають за програми що стартують разом із системою знаходяться<!--more--> за адресами */etc/xdg/autostart/* - для всіх користувачів та *~/.config/autostart* - для конкретного користувача.

Для того щоб запускати їх через певний час, а не одразу потрібно у кожному з них вказати параметр
**X-GNOME-Autostart-Delay=ХХ**
де **ХХ** - час в секундах.
