---
layout: post
title: Як жити з Hyper-V та VirtualBox.
category: [WINDOWS]
---

![atom logo](/assets/media/hyper-v.png?style=head)  
Виявляється якщо ми встановили _**Hyper-V**_ то про будь-які інші гіпервізори можна забути, навіть якщо софт що використовує _**Hyper-V**_ не активний. Як завжди є костиль, дієвий, хоч і малозручний.  
- Дублюємо варіант запуску
{% highlight shell %}bcdedit /copy {current} /d "No Hyper-V"{% endhighlight %}
Отримаємо щось типу
{% highlight shell %}The entry was successfully copied to {ff-23-113-824e-5c5144ea}.{% endhighlight %}
- Вказуємо що це варіант завантаження з відключеним _**Hyper-V**_
{% highlight shell %}bcdedit /set {ff-23-113-824e-5c5144ea} hypervisorlaunchtype off{% endhighlight %}

Також може бути потрібен костиль на випадок якщо індуське рукоділля не видає варіантів завантаження при перезавантаженні, а тільки при включенні після виключення. В такому разі натискаючи **Перезавантажити** тримаємо **shift**.
