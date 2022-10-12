---
layout: post
title: Запуск Viber згорнутим у трей. Linux Mint XFCE.
category: [LINUX]
---

![viber logo](/assets/media/viber.webp?style=head)  
Давно ходив навколо цієї проблеми, але працювало за принципом "ну і чорт з ним", але зрештою вирішив розібратися. Суть проблеми - ***Viber***, як мінімум в **XFCE** не стартує при запуску системи згорнутим в трей, максимум що можна добитися ключами запуску це старт мінімізованим. Як виявилося задачка ще та, проблема давно відома, але всі відповіді і рекомендації в інтернетах діляться на 2 категорії - 99.99% нікчемні графомани переписують один у одного одну й ту ж нікчемну інструкцію як запустити мінімізованим і всього парочка де згадується ***devilspie***, але непрацюючих, через непрацюючий/застарілий конфіг.<!--more-->  
Отже що таке ***devilspie***
>What is devilspie?  
>devilspie is a non-gui utility that lets you make applications start in specified workplaces, in specified sizes and placements, minimized or maximized and much more based on simple config files.

Логіка роботи наступна:
- встановлюємо(ноступна зі стандартного репозитарію);
- створюємо конфігураційний файл _~.devilspie/viber-minimize.ds_;
- створюємо скрипт який запускатиме зв'язку.  
Конфігурація:
    {% highlight conf %}$ (if (is (application_name) "ViberPC")  
    (begin
     (close)
     (spawn_sync "bash -c \"ps auxww| grep -E 'devilspie' | awk '{print \$2}'| xargs kill\"")
    )
){% endhighlight %}
Алгоритм роботи:
- шукається вікно у якого **application_name=ViberPC**;
- для нього виконується **close**;
- на останок найцікавіше - вбиваємо процес **devilspie**, інакше вікно програми буде знову закриватися як тільки спробувати його відкрити :)  
Скрипт для додавання в автозапуск:
    {% highlight bash %}$ #!/bin/bash
devilspie &
/opt/viber/Viber{% endhighlight %}

Детальніше [тут](https://help.ubuntu.com/community/Devilspie "Devilspie"){:target="_blank"} і у **man**.
