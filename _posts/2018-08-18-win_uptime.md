---
layout: post
title: Взнаємо uptime віддаленого ПК з Windows.
category: [WINDOWS]
---
![windows logo](/assets/media/windows-logo.png?style=head)  
Є 3 способи взнати час роботи віддаленого ПК від керуванням ***Windows***: <!--more-->

- **systeminfo** - стандартна вбудована утиліта
    {% highlight terminal %}SystemInfo /s Remote_Computer | find "Boot Time:"{% endhighlight %}
- **PSInfo** від ***Sysinternals***
    {% highlight terminal %}PSInfo Uptime \\Remote_Computer{% endhighlight %}
- **PowerShell** - якщо версія системи дозволяє
    {% highlight posh %}(Get-Date) - (Get-CimInstance Win32_OperatingSystem -ComputerName Remote_Computer).LastBootupTime{% endhighlight %}
