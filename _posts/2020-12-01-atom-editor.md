---
layout: post
title: Текстовий редактор та редактор коду Atom.
category: [SOFTWARE]
---

![atom logo](/assets/media/atom.svg?style=head)  
Перейшов поки до писання заміток з робочого _**linux**_ на домашню _**windows**_ і зіткнувся з чисто суб'єктивним можливо несприйняттям **notepad++** навіть після банальних **gedit(xed)**. Мабуть приблизно таке відчуття повинно бути якщо з **notepad++** перейти на звичайний **notepad**.  <!--more-->
Тому **Atom** i коротко про те що потрібно доставити зразу, щоб не доінсталювати по плагіну раз в місяць, а також про базову конфігурацію.  

#### Базова конфігурація

1. _File/Settings/Core/Progect home_ - можна вказати домашню директорію для проектів
     [![screenshot](/assets/media/screen-atom-0.webp?style=blog "screenshot")](/assets/media/screen-atom-0.webp "screenshot"){:target="_blank"}
2. _File/Settings/Core/Editor_ - кілька корисних доналаштувань:
   - м'які переноси і довжина рядка для них;
   - показувати приховані символи;
   - показувати номери рядків;
   - вказати скільком пробілам відповідає одна табуляція;
3. _File/Settings/Core/System_ - можна додати до контекстного меню файлових менеджерів пункт _"Open with Atom"_ для файлів та директорій.
4. _File/Settings/Packages_ - шукаємо пакет _spell-check_, вказуємо мови для перевірки орфографії. Тут же налаштовуються усі інші встановлені за замовчуванням да самим користувачем додатки. [![screenshot](/assets/media/screen-atom-1.webp?style=blog "screenshot")](/assets/media/screen-atom-1.webp "screenshot"){:target="_blank"}
5. _File/Settings/Install_ - встановлення додаткових пакетів, а тут є де розігнатися навіть з точки зору мінімальнонеобхідного.

#### Додаткові пакети
1. atom-beautify - структуризація написаного аби як коду;
2. atom-i18n - додаткові локалізації інтерфейсу
3. atom-terminal-powershell - відкрити powershell-консоль в директорії з файлом;
4. auto-encoding;
5. color-picker - в css/html колір можна вибрати візуально;
7. file-icons - іконки різних типів файлів в дереві файлів;
8. highlight-selected;
9. language-reg;
10. language-batchfile;
11. language-ini;
12. language-liquid;
13. language-powershell;
14. markdown writer;
15. minimap;
16. multicursor - контрол+клік множить курсор;
17. pigments - в css/html код кольору пишеться у блоці цього кольору;
18. project-manager - швидке переключення піж проектами;

#### Всяка магія
1. ctrl-shift-F - знайти/замінити текст у всьому проекті, чи у файлах/директоріях згідно шаблону;
2. ctrl-shift-T - вікно powershell;
3. можна ділити відкриті файли у 2 ряди чи стовпці [![screenshot](/assets/media/screen-atom-3.webp?style=blog "screenshot")](/assets/media/screen-atom-3.webp "screenshot"){:target="_blank"}

#### Костилі :)
Налаштувань і розширень дочорта, а централізованої рідної синхронізації нема. Поки робимо так(на практиці ще не перевірялося):
1. З директорії _%username%\\.atom_ зберігаємо файли _config.cson_, _keymap.cson_, _snippets.cson_, _styles.less_;
2. Робимо список встановлених пакетів:
        {% highlight posh %}apm list --installed --bare > packages.list{% endhighlight %}
{:start="3"}
3. Заливаєм все на той же **github** чи **gdrive**, **dropbox**, etc.

При розгортанні з бекапа:
1. _*.cson_ та _*.less_ з бекапу повертаємо на місце у _%username%\\.atom_ ;
2. Відновлюємо пакети:
        {% highlight posh %}apm install --packages-file packages.list{% endhighlight %}
