---
layout: post
title: Темна іконка Steam в треї.
category: [LINUX]
---
![qr logo](/assets/media/steam.svg?style=head)  
Якщо в лінуксі використовувати світлу панель задач то значок стіма в треї лишатиметься світлим. Щоб змінити це треба<!--more-->
 знайти темний значок і замінити.  
Як шукати. Кожна програма встановлена через **dpkg** чи **apt** має файл _*.list_ в якому описано що куди і де. Він знаходиться в _/var/lib/dpkg/info_. Згідно нього картинка для трею наступна _/usr/share/icons/hicolor/48x48/apps/steam_tray_mono.png_. Можемо перефарбувати, можемо знайти готову й замінити. Пишуть при апдейті стіма вона зновук стане світлою, але особисто в мене цього не відбулося, все лишилося правильним.  
[![steamtray](/assets/media/steamtray.webp?style=blog "steamtray")](/assets/media/steamtray.webp "steamtray"){:target="_blank"}  
