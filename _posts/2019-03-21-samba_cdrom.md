---
layout: post
title: Мережевий доступ до змінного носія. Samba 4.
category: [LINUX]
---
Є пара моментів з тим як монтувати та розшарювати щоб мати доступ бо варіант зі сліпою аналогією до випадку зі звичайною директорією відкритою лише на читання не працює.<!--more--> Перш за все треба прописати у /etc/fstab куди монтуватиметься носій, у нас на прикладі **CD-ROM**.
  {% highlight conf %}/dev/sr0 /media/cdrom iso9660 defaults,noauto,ro,user,uid=1000,gid=1000 0 0{% endhighlight %}
Звертаємо увагу на **uid/gid** бо буде монтуватися зі значенням **0(root)**.
Перечитуємо відредагований */etc/fstab*
    {% highlight shell %}sudo mount -a{% endhighlight %}
Лишається дати доступ до директорії */media/cdrom* у */etc/samba/smb.conf*.
  {% highlight conf %}[DVD-ROM Drive]
   path = /media/cdrom
   browseable = yes
   read only = no
   guest ok = yes
   locking = no
   preexec = /bin/mount /media/cdrom
   postexec = /bin/umount /media/cdrom
{% endhighlight %}
Перезапускаємо **samba** і все повинно працювати.
    {% highlight terminal %}sudo systemctl restart smbd{% endhighlight %}
