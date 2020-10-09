---
layout: post
title: Налаштування операційних систем для роботи з ssd.
category: [HARDWARE]
---
![ssd logo](/assets/media/ssd.png?style=head)  
З поширенням ssd виникають деякі моменти по налаштуванню та оптимізації операційних систем для більш ефективної роботи дискової системи та збереженню ресурсу дисків.<!--more--> Перший момент - спільний для всіх систем, диск повинен працювати в режимі **AHCI**, другий момент - повинна бути активована команда [TRIM](https://uk.wikipedia.org/wiki/TRIM "збарегти TCM"){:target="_blank"} в самій операційній системі. Як це перевірити і при необхідності ввімкнути:

#### Linux
Ядро системи повинно бути новіше за 2.6.33, повинна використовуватися файлова система **BTRFS**, **XFS**, **JFS** чи **EXT4**. Диск повинен монтуватися з параметром **discard**, на зразок такого
  {% highlight shell %}UUID=897fd1c0-08d6-4d26-a9c5-f6bbfbd0227a /               ext4    discard,errors=remount-ro 0       1{% endhighlight %}
Перевірити включення команди можна так
    {% highlight shell %}hdparm -I /dev/sdd | grep "TRIM supported"{% endhighlight %}
Результат виконання команди:
    {% highlight shell %}* Data Set Management TRIM supported (limit 1 block){% endhighlight %}
**Data Set Management TRIM supported (limit 1 block)** означає що технологія підтримується, **\*** що **TRIM** ввімкнено.

#### Windows
Система повинна бути не старіша за ***Windows 7***. Перевірити включення команди можна так
    {% highlight terminal %}fsutil behavior query disabledeletenotify{% endhighlight %}
в результаті отримаємо вивід такого типу
    {% highlight terminal %}NTFS DisableDeleteNotify = 0 (1, is not currently set)
ReFS DisableDeleteNotify = 0 (1, is not currently set){% endhighlight %}
що означає наступне

- 0 - підтримку **TRIM** ввімкнено
- 1 - підтримку **TRIM** вимкнено
- not currently set - буде задіяно як тільки буде підключено **ssd** із даною файловою системою

Ввімкнути чи вимкнути **TRIM** можна виконавши команду
    {% highlight terminal %}fsutil behavior set disabledeletenotify NTFS 0{% endhighlight %}
Крім того для будь-якої операційної системи можна відключати чи оптимізувати вікористання файлу(розділу) підкачки, переносити на HDD(якщо він є) директорії(розділи) з тимчасовими файлами, переносити чи оптимізувати частоту записів на диск що виконують браузери в процесі роботи. Як це зробити описувалося раніше в наступних статтях:  

[Використовуємо найновіший софт на древніх ПК](https://nyurch.github.io/linux/2018/03/20/linux_old-pc.html "Використовуємо найновіший софт на древніх ПК"){:target="_blank"}  
[Зміна розміщення браузерного кешу у Windows](https://nyurch.github.io/software/2016/12/10/browsers-cache.html "Зміна розміщення браузерного кешу у Windows"){:target="_blank"}  
[Костилі для Windows 10](https://nyurch.github.io/windows/2018/03/28/windows-10-bugs.html "Костилі для Windows 10"){:target="_blank"}
