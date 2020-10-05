---
layout: post
title: Автозапуск сервісів.
category: [LINUX]
---
**systemd** - менеджер системи та сервісів має утиліту **systemctl** що дозволяє виявити знаходиться той чи інший сервіс в автозавантаженні та за необхідності вилучити<!--more--> чи додати його туди.
Щоб взнати чи сервіс автозавантажується
    {% highlight shell %}systemctl is-enabled SERVICE{% endhighlight %}
Додати чи видалити з автостарту
    {% highlight shell %}sudo systemctl enable/disable SERVICE{% endhighlight %}
Побачити список всіх автостартуючих чи відключених сервісів
    {% highlight shell %}sudo systemctl list-unit-files --state=enabled
sudo systemctl list-unit-files --state=disabled{% endhighlight %}
Якщо менеджер сервісів **sysvinit** то команда **chkconfig**
