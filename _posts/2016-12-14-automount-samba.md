---
layout: post
title: Автоматичне монтування мережевих ресурсів в Linux(Ubuntu).
category: [LINUX]
---
![samba logo](/media/samba.jpg?style=head)  
Трохи про автоматичне монтування мережевих ресурсів в ***Linux(Ubuntu)***.<!--more--> Спочатку ставимо необхідні пакети:
    {% highlight shell %}sudo apt-get install samba smbfs{% endhighlight %}

Створюємо директорії в які буде відбуватися підключення:
    {% highlight shell %}mkdir /media/share{% endhighlight %}

У файлі */etc/fstab* прописуємо що і куди мотуємо:
  {% highlight shell %}//host/share /media/share cifs  iocharset=utf8,codepage=cp866,uid=500,gid=500,rw,credentials=/root/pass.txt 0 0{% endhighlight %}

Створюємо файл */root/pass.txt* з даними для авторизації:
  {% highlight shell %}username=user
password=password{% endhighlight %}

Змінюємо права доступу до нього:
    {% highlight shell %}sudo chmod 600 /root/pass.txt{% endhighlight %}

Перезавантажуємося, або виконуємо
    {% highlight shell %}sudo mount -a{% endhighlight %}
