---
layout: post
title: Збільшення VRAM до 256МБ у VirtualBox.
category: [LINUX]
---

![virtualbox logo](/assets/media/virtualbox.webp?style=head)  
***VirtualBox*** підтримує до 256МБ відеопам'яті, але через графічний інтерфейс можна виділити не більше 128МБ.
    {% highlight shell %}$ VBoxManage modifyvm "Linux Mint 21" --vram 256{% endhighlight %}
<!--more-->
