---
layout: post
title: Швидка зміна налаштувань мережі у Windows.
category: [WINDOWS]
---
![lan logo](/assets/media/windows-logo.png?style=head)  
Швидку зміну налаштувань мережі(ip, dns-сервера, шлюз та маска) можна виконувати через cmd-файл наступного змісту. <!--more-->
Запускати краще від імені адміністратора, хоча на ***Windows 7*** і старіших достатньо просто щоб користувач знаходився в групі **Адміністратори**. Єдине зауваження - треба мати психічно здорову назву марежевого інтерфейсу параметри якого ми міняємо, а за замавчуванням вона є такою лише у ***Windows 10***. У даному прикладі інтерфейс переіменовано у **LAN**.
    {% highlight terminal %}netsh interface ip set address "LAN" static 192.168.7.11 255.255.255.0 192.168.7.254 0
netsh interface ip set dns "LAN" static 192.168.11.1
netsh interface ip add dns "LAN" 192.168.11.4{% endhighlight %}
В цілому структура наступна:
    {% highlight terminal %}set address [name=]InterfaceName [source=]{dhcp | static [addr=]IPAddress [mask=]SubnetMask [gateway=]{none | DefaultGateway [[gwmetric=]GatewayMetric]}}
netsh interface ip set dns [name=]InterfaceName [source=]{dhcp | static [addr=]{DNSAddress | none}} [[ddns=]{disabled | enabled}] [[suffix=]{interface | primary}]
netsh interface ip add dns [name=]InterfaceName [addr=] DNSAddress [[index=]DNSIndex]
netsh interface ip set wins [name=]InterfaceName [source=]{dhcp | static [addr=]{WINSAddress | none }}{% endhighlight %}
