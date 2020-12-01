---
layout: post
comments: true
title: MikroTik. RouterOS.
category: [NETWORK]
---

![Markdown logo](/assets/media/mikrotik.png?style=head)  
Шпаргалка по RouterOS.<!--more-->  

#### Прокидаємо порт з інтерфейсу WAN на вказаний ip внутрішньої мережі.
Тут все просто і очевидно. Переходимо в розділ _IP/Firewall/NAT_ .  
За замовчуванням тут повинен бути прописаний маскарадінг(підміна внутрішніх адрес, зовнішньою адресою роутера), якщо нема то треба прописати руками.
{% highlight shell_session %}/ip firewall nat add action=masquerade chain=srcnat{% endhighlight %}

Далі в підрозділі _General_ заповнюємо пункти **Chain** = ***dstnnat*** (destination NAT, інше можливе значення srcnat - source NAT), **Dst. Port** - порт на які будуть приходити дані, **In. Interface** - інтерфейс на якому буде прослуховуватися вказаний порт(очевидно це буде wan-інтерфейс ether1), **Protocol** - протокол передачі. Тут же у підрозділі _Action_ заповнюємо пункти **Action** = ***dst-nat*** (перенаправляти дані із зовнішньої мережі у внутрішню), **To Addresses** та **To Ports** - адреса та порт у внутрішній мережі на які здійснюється перенаправлення. Це руками, або в терміналі, на прикладі rdp.
{% highlight shell_session %}/ip firewall nat add action=dst-nat chain=dstnat dst-port=3389 in-interface=ether1 protocol=tcp to-addresses=192.168.88.254 to-ports=3389{% endhighlight %}

#### VLAN. Базові налаштування.
Є 2 основні типи інтерфейсів - ***trunk*** - один інтерфейс може з різними мітками передавати потоки різних **VLAN**, використовується для підключення інших маршрутизаторів та ***access*** - для підключення клієнтів.  
На прикладі ***access***:
- Створюємо необхідні мости:
{% highlight shell_session %}/interface bridge add comment=OFFICE-VLAN fast-forward=no name=vlan10-bridge
/interface bridge add comment=OFFICE-VLAN fast-forward=no name=vlan20-bridge{% endhighlight %}
- Створюємо пули адрес що буде видавати dhcp-сервер у цих мережах:
{% highlight shell_session %}/ip pool add comment=OFFICE-VLAN name=vlan10-pool ranges=10.0.10.110-10.20.0.253
/ip pool add comment=OFFICE-VLAN name=vlan20-pool ranges=10.0.20.110-10.30.0.253{% endhighlight %}
- Створюємо dhcp-сервера:
{% highlight shell_session %}/ip dhcp-server add address-pool=vlan10-pool disabled=no interface=vlan10-bridge name=vlan10-dhcp
/ip dhcp-server add address-pool=vlan20-pool disabled=no interface=vlan20-bridge name=vlan20-dhcp{% endhighlight %}
- В кожній мережі призначаємо адресу маршрутизатору:
{% highlight shell_session %}/ip address add address=10.0.10.1/24 comment=OFFICE-VLAN interface=vlan10-bridge network=10.0.10.0
/ip address add address=10.0.20.1/24 comment=OFFICE-VLAN interface=vlan20-bridge network=10.0.20.0{% endhighlight %}
- Для кожної мережі вказуємо шлюз та dns-сервер:
{% highlight shell_session %}/ip dhcp-server network add address=10.0.10.0/24 comment=OFFICE-VLAN dns-server=10.0.10.1 gateway=10.0.10.1 netmask=24
/ip dhcp-server network add address=10.0.20.0/24 comment=OFFICE-VLAN dns-server=10.0.20.1 gateway=10.0.20.1 netmask=24{% endhighlight %}
Це по мануалу, по практиці dns-сервер вказувати не треба, бо не працює в результаті вихід в світ. ЗХ, треба дивитися кожен раз на практиці.
Тепер зв'язуємо порти, мости й мережі:
{% highlight shell_session %}/interface bridge port add bridge=vlan10-bridge comment="OFFICE-VLAN" interface=ether3
/interface bridge port add bridge=vlan20-bridge comment="OFFICE-VLAN" interface=ether4{% endhighlight %}
В дефолтній конфігурації порти вже пов'язані, тому спочатку мости для портів **ether3** та **ether4** треба видалити.

В результаті 3й та 4й порти маршрутизатора тепер видають підключеним клієнтам адреси з підмереж 10.0.10.0 та 10.0.20.0 відповідно.

В _Interfaces/Interface List_ є 2 дефолтних списка - WAN та LAN. Або створюємо якщо нема:
{% highlight shell_session %}/interface list add comment=defconf name=WAN
/interface list add comment=defconf name=LAN{% endhighlight %}

Додаємо віртуальні мережі до списку LAN, а порт що стирчить в світ до списку WAN:
{% highlight shell_session %}/interface list member add interface=ether1 list=WAN
/interface list member add interface=vlan10-bridge list=LAN
/interface list member add interface=vlan20-bridge list=LAN{% endhighlight %}

Дозволяємо доступ на роутер тільки з інтерфейсів із групи LAN:
{% highlight shell_session %}/ip neighbor discovery-settings set discover-interface-list=LAN{% endhighlight %}

Тепер треба дозволити їм ходити в інтернет. Дозволяємо запити до сервера dns та налаштовуємо маскарадінг:
{% highlight shell_session %}/ip dns set allow-remote-requests=yes
/ip firewall nat add action=masquerade chain=srcnat comment="defconf: masquerade" ipsec-policy=out,none out-interface-list=WAN{% endhighlight %}
Це повинно бути в дефолтній конфігурації.

І типу повинно працювати, але далі я трохи жопоручу і поки для виходу з VLAN в інет роблю правило
{% highlight shell_session %}/ip firewall nat add action=accept chain=srcnat comment="defconf: masquerade" out-interface-list=LAN{% endhighlight %}
