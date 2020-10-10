---
layout: post
title: Зміна розміщення браузерного кешу у Windows.
category: [SOFTWARE]
---
![browsers logo](/assets/media/browsers.png?style=head)  
Варіанти переносу браузерного кешу в нестандартні директорії для розвантаження **ssd** чи просто для зменшення фрагментації системного диску.<!--more-->
#### Internet Explorer
Мабуть також дійсте і для ***Edge***. Потрібно змінити значення 2 параметрів у реєстрі:  
*HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\Cache*  
та  
*HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\Cache*.  
Як досить очевидно витікає з розділу реєстру - налаштування персональне для кожного користувача.

#### Mozilla Firefox
В **about:config** створити рядковій параметр browser.cache.disk.parent_directory зі шляхом до кешу. Наприклад *c:\Temp\Cache*.
Перевірити поточний стан кешу можна на сторінці **about:cache**.

#### Браузери на базі Chromium(Google Chrome, Opera 15+, Vivaldi, etc)
Розміщення кешу задається явним указанням параметру ярлика запуску *--disk-cache-dir="шлях до кешу"*.
