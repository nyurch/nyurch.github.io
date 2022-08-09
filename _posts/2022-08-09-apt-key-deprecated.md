---
layout: post
title: Warning - apt-key is deprecated.
category: [LINUX]
---
Виявляється ***apt-key*** вже вважається застарілою і рекомендується самостійно додавати GPG-ключі в папку _/etc/apt/trusted.gpg.d_.<!--more--> 
Якщо відома адрема розміщення ключа:
    {% highlight shell %}curl -s URL | sudo gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/ІМ'Я_КЛЮЧА'.gpg --import
sudo chmod 644 /etc/apt/trusted.gpg.d/ШМ'Я_КЛЮЧА.gpg{% endhighlight %}
Для локальних ключів:
    {% highlight shell %}cat ФАЙЛ.pub | sudo gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/ІМ'Я_КЛЮЧА.gpg --import
sudo chmod 644 /etc/apt/trusted.gpg.d/ІМ'Я_КЛЮЧА.gpg{% endhighlight %}
З сервера ключів:
    {% highlight shell %}sudo gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/atareao-telegram.gpg --keyserver keyserver.ubuntu.com --recv A3D8A366869FE2DC5FFD79C36A9653F936FD5529
sudo chmod 644 /etc/apt/trusted.gpg.d/atareao-telegram.gpg{% endhighlight %}
В Linux Mint 21 є невеликий костиль - із коробки отримаємо
    {% highlight shell %}gpg: keyring '/etc/apt/trusted.gpg.d/atareao-telegram.asc' created
gpg: failed to create temporary file '/root/.gnupg/.#lk0x0000561467a4b600.xfce-vb.21472': No such file or directory
gpg: connecting dirmngr at '/root/.gnupg/S.dirmngr' failed: No such file or directory
gpg: keyserver receive failed: No dirmngr{% endhighlight %}
Треба попередньо запустити службу
    {% highlight shell %}sudo dirmngr{% endhighlight %}
