---
layout: post
title: Налаштування WiFi через термінал Ubuntu.
category: [LINUX]
---

![atom logo](/assets/media/wifi.svg?style=head)  

Ніколи не зіштовхувався з такою необхідністю, але може бути корисно мати під рукою.<!--more-->  

Дивимося що там у нас з адаптерами:
{% highlight shell_session %}ls /sys/class/net{% endhighlight %}
Створюємо конфіг для **netplan**
{% highlight shell_session %}sudo nano /etc/netplan/50-cloud-init.yaml{% endhighlight %}
Якось так:
{% highlight yaml %}
# This file is generated from information provided by the datasource. Changes
# to it will not persist across an instance reboot. To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        eth0:
            dhcp4: true
            optional: true
    version: 2
    wifis:
        wlan0:
            dhcp4: true
            optional: true
            access-points:
                "SSID_name":
                    password: "WiFi_password"
{% endhighlight %}

Тобто треба знати ім'я адаптера, ssid та пароль.  
Генеруємо, приміняємо:
{% highlight shell_session %}
$ sudo netplan generate
$ sudo netplan apply
{% endhighlight %}

Передбачається можливість деяких багів:
- Failed to start netplan-wpa-wlan0.service: Unit netplan-wpa-wlan0.service not found.  
Не запущена служба. Виконуємо:
{% highlight shell_session %}
$ sudo systemctl enable wpa_supplicant
$ sudo shutdown now
$ sudo netplan generate
$ sudo netplan apply
{% endhighlight %}  
В мануалі чомусь не `enable`, a `start`...

- Warning: The unit file, source configuration file or drop-ins of netplan-wpa-wlan0.service changed on disk. Run 'systemctl daemon-reload' to reload units.  
Не критично.
