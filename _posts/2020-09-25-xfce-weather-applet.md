---
layout: post
comments: true
title: xfce4-weather-plugin. No Data.
category: [LINUX]
---
![Jekyll logo](/assets/media/xubuntu-weather-plugin.webp?style=head)  
Після зміни версії API на **https://apt.met.no/** в дистрибутивах на базі ***Ubuntu 18.04*** перестав працювати ***xfce4-weather-plugin***.<!--more--> Найпростіший спосіб заміна *libweather.so* на нову перекомпільовану версію.
Зроблено по [статті](https://askubuntu.com/questions/1274259/xfce4-weather-plugin-for-xubuntu-18-04-stopped-working "askubuntu").

Забрати готовий файл можна за посиланням з оригінального обговорення чи [тут](https://github.com/nyurch/nyurch.github.io/tree/master/assets/files/libweather.so "libweather.so")
помістити його за адресою */usr/lib/x86_64-linux-gnu/xfce4/panel/plugins/libweather.so* та перезавантажити плагін.
