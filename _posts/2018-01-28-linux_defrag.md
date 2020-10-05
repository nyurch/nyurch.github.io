---
layout: post
title: Дефрагментація жорстких дисків в Linux.
category: [LINUX]
---
![defragmentation logo](/media/defragmentation.jpg?style=head)  
Незважаючи на те що фрагментація файлових систем в ***Linux*** фактично відсутня є кілька випадків коли вона може бути досить значною і впливати на швидкодію. Як правило це при інтенсивнму використанні торрентів та віртуальних машин з динамічним розміром дисків. <!--more-->Перевірити необхідність дефрагментації можна командою **e4defrag**, що є частиною пакету **e2fsprogs**.
    {% highlight shell %}$ sudo e4defrag -c /dev/sda1
[sudo] password for admin:
<Fragmented files>                             now/best       size/ext
1. /var/log/wtmp.1                              23/1              4 KB
2. /var/log/wtmp                                20/1              4 KB
3. /var/log/ConsoleKit/history.1                 9/1              4 KB
4. /var/log/ConsoleKit/history                   8/1              4 KB
5. /var/log/pm-powersave.log.1                   8/1              4 KB

 Total/best extents				278211/276746
 Average size per extent			36 KB
 Fragmentation score				0
 [0-30 no problem: 31-55 a little bit fragmented: 56- needs defrag]
 This device (/dev/sda1) does not need defragmentation.
 Done.{% endhighlight %}
В даному випадку бачимо що в кінці звіту чітко написано - **This device (/dev/sda1) does not need defragmentation**. А при необхідності дефрагментація запускається командою
    {% highlight shell %}sudo e4defrag /dev/sda1{% endhighlight %}
