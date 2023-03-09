---
layout: post
title: Некоректне ім'я підключення.
category: [WINDOWS]
---

Якщо в Network & Internet Settings показується неправильне ім'я підключення переходимо в редактор реєстру  
гілка _HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles_, шукаємо в списку це підключення і виправляємо параметер **ProfileName**. 
