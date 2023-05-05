---
layout: post
title: Командний рядок Linux. Деякі команди.
category: [LINUX]
---

![linux logo](/assets/media/bash.webp?style=head)  
Набір корисних і дуже корисних команд, котрі в силу своєї довжини не завжди вміщаються в голові.<!--more-->

#### Вивід топ-5 директорій

На прикладі деректорії _~/_:
  {% highlight shell %}du -h ~/ | sort -rh | head -5{% endhighlight %}
Вивід топ-5 директорій включаючи піддиректорії:
  {% highlight shell %}du -hS ~/ | sort -rh | head -5{% endhighlight %}
Вивід топ-5 файлів:
  {% highlight shell %}find ~/\* -type f -exec du -Sh {} + | sort -rh | head -n 5{% endhighlight %}

#### Монтування ISO-образу

  {% highlight shell %}mount -o loop,iocharset=utf8 -t iso9660 /шлях/до/образу /куди/монтувати{% endhighlight %}

#### Знайти всі mp3-файли й перекодувати теги в UTF8

  {% highlight shell %}find /де/шукати/ -name "\*.mp3" -print0 | xargs -0 mid3iconv -eCP1251 --remove-v1{% endhighlight %}

#### Виконати захват відео без звуку з екрану

  {% highlight shell %}ffmpeg -f x11grab -s 1920x1080 -r 25 -i :0.0 -vcodec qtrle -f mov ~/video.mov{% endhighlight %}
Детальніше на [ffmpeg.org](http://www.ffmpeg.org/ffmpeg.html){:target="\_blank"}.

#### Вимкнення ПК з Windows через Linux

  {% highlight shell %}net rpc shutdown -r -f -C "shutting down" -I 192.168.7.14 -U домен/\\логін%пароль{% endhighlight %}

#### Порівняння директорій

  {% highlight shell %}diff -q dir-1/ dir-2/{% endhighlight %}
Або використовуючи програму **_meld_** при наявності графічного оточення.

#### Копіювання файлів із відображенням прогресу

Використовується програма **_pv_** яка ставиться зі стандартних репозиторіїв. Приклад використання:
  {% highlight shell %}pv що_копіювати > куди_копіювати{% endhighlight %}
Взято з [www.tecmint.com](http://www.tecmint.com/monitor-copy-backup-tar-progress-in-linux-using-pv-command/){:target="\_blank"}.
![linux pv](/assets/media/copy-files-show-progress-bar.gif?style=blog)

#### Використання команд grep/egrep для перегляду файлів.

Команди **_grep/egrep_** можна використовувати для виводу вмісту файлу без певних визначених рядків. Наприклад можна виводити вміст файлів конфігурації без закоментованих рядків. Досить цікава штука так як розмір файлу може бути в кілька метрів довжиною, а на 99.99% це можуть бути коментарі та закоментовані параметри. При цьому основна відмінність команди **_egrep_** від **_grep_** в тому що для неї просто можна задавати не один фільтр, а декілька. Приклад використання:
  {% highlight shell %}egrep -v "^$|^#" /boot/grub/grub.cfg{% endhighlight %}
Що тут маємо - **^X** - показує який символ початку рядка ми хочемо додати у шаблон, де **X** - будь-який символ. **\|** використовуємо для розділення при додаванні кількох символів у шаблон. У даному випадку ми виводимо вміст файлу _/boot/grub/grub.cfg_ без порожніх(**^$**) та без закоментованих(**^#**) рядків.
Без ключа **-v** виведуться лише порожні та закоментовані рядки.

#### sed

Знайти в директорії та у всіх вкладених директоріях файли **txt** й замінити в них один текст на інший:
  {% highlight shell %}find -name '_.txt' -exec sed -i -e 's/що замінити/на що замінити/i' "{}" \\;{% endhighlight %}
У файлі _test_ вставити слово **ТЕКСТ** на початку кожного рядка:
  {% highlight shell %}sed 's/^/текст/' test{% endhighlight %}
У файлі **test** з'єднати рядки попарно(як варіант видалення порожніх рядків). Класичний приклад, зараз чомусь ще й видаляє перший символ кожного рядка:
  {% highlight shell %}sed '$!N;s/\\n/ /' test{% endhighlight %}
У файлі **test** витерти порожні рядки. Класичний приклад, без \\s_ перед $, що гуляє всіма інтернетами, зараз чомусь не спрацьовує.
  {% highlight shell %}sed '/^\\s_$/d' test{% endhighlight %}
У файлі **test** в кінці рядка дописати **КІНЕЦЬ РЯДКА**. Класичний приклад, без \\s_ перед $, що гуляє всіма інтернетами, зараз чомусь не спрацьовує.
  {% highlight shell %}sed 's/\\s_$/ кінець рядка/g' test{% endhighlight %}
У файлі **test** через кожні 2 символи написати **ВСТАВКА**:
  {% highlight shell %}sed 's/(..)/\\1ВСТАВКА/g' test{% endhighlight %}
У файлі **test** витерти пробіл перед комами чи витерти всі пробіли перед комами:
  {% highlight terminal %}sed 's/ ,/,/g' test
sed 's/( )+,/,/g' test
sed 's/ _,/,/g' test{% endhighlight %}
У файлі **test** додати в кінці рядків крапку якщо її немає.
  {% highlight terminal %}sed 's/[^\.]$/./' test{% endhighlight %}
Хитрий набір команд бере файл **file_list** що є файлом який містить список файлів та тек створеним у **_Total Commander_** і робить з нього список в один рядок:
  {% highlight terminal %}sed -i 's/.$//' file_list
cat file_list | tr '\\n' ' ' > test
cat test | tr '[:upper:]' '[:lower:]' > file_list
sed -i 's/\\/,/g;s/( )+/ /g;s/, $//' file_list
rm test{% endhighlight %}
У файлі **test** замінити 2+ пробілів одним, ( )+ можна заміняти на  пробілпробіл_:
  {% highlight terminal %}sed 's/( )+/ /g' test
sed 's/  _/ /g' test{% endhighlight %}
У файлі **test** вставити пробіл після кожного символу:
  {% highlight terminal %}sed 's/()+/ /g' test{% endhighlight %}
У файлі **test** витерти пробіли в кінці рядків:
  {% highlight terminal %}sed 's/ _$//' test{% endhighlight %}
У файлі **test** витерти пробіл перед крапками чи витерти всі пробіли перед крапками:
  {% highlight terminal %}sed 's/ ././g' test
sed 's/( )+././g' test{% endhighlight %}
або ( )+ можна заміняти на  пробіл_ :
  {% highlight terminal %}sed 's/ \*././g' test{% endhighlight %}

#### Визначення mac-адреси

-   **_Windows_** - getmac
-   **_Linux_** - arp-scan  
