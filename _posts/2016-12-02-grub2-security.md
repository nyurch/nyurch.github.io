---
layout: post
title: Grub2 та безпека.
category: [BOOT]
---
![grub](/media/grub.png?style=head)  
Давно відомо що опції відомого завантажувача ***grub2*** можна змінювати в самому процесі завантаження. Це може як дуже допомагати в цілому, так і нести певну небезпеку для unix-подібних операційних систем зокрема. Тому досить розумним виглядає вимагати аутентифікації користувача який намагається вносити зміни в конфігурацію ***grub2*** в процесі завантаження.<!--more-->

Для цього потрібно виконати кілька елементарних рухів.

- командою *grub-mkpasswd-pbkdf2* генеруємо пароль який використовуватиметься для зміни конфігурації ***grub2*** в процесі завантаження;

- створюємо файл /etc/grub.d/01_passwd наступного змісту
  {% highlight shell %}#!/bin/bash
set -e
cat << EOF
set superusers="root"
password_pbkdf2 root наш_пароль
EOF{% endhighlight %}

- дозволяємо виконання файлу як програми та змінюємо права доступу
    {% highlight shell %}sudo chmod u+x,go-rw /etc/grub.d/01_passwd{% endhighlight %}

- оновлюємо ***grub2***
    {% highlight shell %}sudo update-grub{% endhighlight %}
