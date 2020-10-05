---
layout: post
title: Налаштування параметрів мережі Ubuntu в терміналі.
category: [LINUX]
---
Виявляється є момент, плюс чомусь **address** завжди намагаюся писати з однією d.<!--more-->
Всі налаштування мережевого адаптера знаходяться тепер у файлі */etc/network/interfaces*. Для його налаштування необхідно дописати у кінець файлу наступні параметри для статичної ip-адреси
  {% highlight shell %}# Моя мережа.
iface eth0 inet static
address 192.168.0.1
netmask 255.255.255.0
gateway 192.168.0.254
dns-nameservers 192.168.0.254 8.8.8.8
auto eth0 {% endhighlight %}
та наступні для динамічної
  {% highlight shell %}# Моя мережа.
iface eth0 inet dhcp
auto eth0{% endhighlight %}
Є 2 моменти:
- Звично необхідно знати ім'я інтерфейсу, у даному випадку **eth0**. Подивитися його, як завжди, можна або скориставшись командою
      {% highlight shell %}ifconfig{% endhighlight %}
або
      {% highlight shell %}sudo lshw -C network | grep "logical name"{%endhighlight %}
- Налаштування dns-серверу, починаючи з ***Ubuntu 12.04***, задається параметром **dns-nameservers**. ***!!!*** файл */etc/resolv.conf* тепер генерується автоматично і всі руками внесені в нього зміни видаляються.

Тимчасові налаштування адаптеру які обнуляться після перезавантаження системи можна задати наступною командою:
    {% highlight shell %}sudo ip addr add 192.168.0.1/24 dev eth0{% endhighlight %}
Після внесення всіх змін перезапускаємо мережу командою на вибір:
    {% highlight shell %}sudo /etc/init.d/networking restart
sudo services networking restart
sudo ifconfig eth0 down && sudo ifconfig eth0 up
sudo ifdown eth0 && sudo ifup eth0{% endhighlight %}
