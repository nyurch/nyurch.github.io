---
layout: post
title: Розмір журналів(логів) systemd.
category: [LINUX]
---

Для домашньої, ще й нормально працюючої системи впринципі немає сенсу збирати гігабайти системних журналів. Основні моменти наступні:<!--more-->
Налаштування журналювання знаходяться в _/etc/systemd/journald.conf_.  
Найцікавіші нам параметри:
- **Storage** - шлях збереження журналів. **persistent** - _/var/log/journal/_, **volatile** - _/run/log/journal_ і відповідно будуть зберігатися тільки для поточного сеансу, **auto** - при наявності директорії _/var/log/journal/_ зберігатимуться сюди, якщо її видалити то в _/run/log/journal_, **none** - відключити журналювання.
- **SystemMaxUse** - максимальний розмір журналів у _/var/log/journal/_
- **RuntimeMaxUse** - максимальний розмір журналів у _/run/log/journal_

Після внесення змін в налаштування журналів перезапускаємо демона:
    {% highlight bash %}$ sudo systemctl restart systemd-journald{% endhighlight %}
Для ручного очищення журналів:
    {% highlight bash %}$ sudo journalctl --vacuum-size=100M{% endhighlight %}
    {% highlight bash %}$ sudo journalctl --vacuum-time=10weeks{% endhighlight %}

