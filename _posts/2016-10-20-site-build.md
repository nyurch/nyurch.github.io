---
layout: post
title: Обробка тексту та графіки.
category: [WEB]
---
![build](/assets/media/site-building.webp?style=head)  
Конспект за результатами переходу від старого до нового сайту. Пакетна і одинична обробка текстових та графічних документів. Слідами виконаних робіт згрібаю все в купу.<!--more-->  

Взяти вказаний html-файл, прибити там всі html-теги і зберегти результат у текстовому файлі:
    {% highlight shell %}sed -e :a -e 's/&lt;[^&gt;]*&gt;//g;/&lt;/N;//ba' file.html &gt; file.txt{% endhighlight %}
Додати в кінці кожного рядка вказаного файлу **&lt;br&gt;**. Після дня з бубном довелося використати ***vi*** у неекранному режимі(ex-mode command) бо ні ***sed***, ні ***awk***, хоч ти трісни, вставляли на початок рядка, причому із заміною. Хоча у іншому проекті пару років тому варіант *sed 's/$/ла-ла-ла/'* прекрасно справлявся з задачею дописувати текст в кінець рядка і саме такий варіант всюди описаний в інтернетах.
    {% highlight shell %}ex +"%s/$/&lt;br&gt;/g" -cwq data_file_1.txt{% endhighlight %}
Вирізати в кожному рядку файлу даних 3,4,5 символ та перезаписати дані в інший файл, потім витерти всі символи після 35го та записати результат у 3й файл:
    {% highlight shell %}cat data_file_1.txt | cut --complement -b '3-5' &gt; data_file_2.txt
cat data_file_2.txt | cut --complement -b 35- &gt; data_file_3.txt{% endhighlight %}
Видалити всі пробіли в кінці рядків:
    {% highlight shell %}sed -i 's/ *$//' data_file_4.txt{% endhighlight %}
В деяких випадках коли треба потерти щось з кінця рядків неоднакової довжини варіант  *cut --complement -b* не підходить і використовується варіант з оберненням напрямку рядка, видаленням і оберненням назад. На прикладі видалення 9 останніх символів кожного рядка:
    {% highlight shell %}rev data_file_5.txt  | cut -c 9- | rev{% endhighlight %}
Так був вибраний і перебраний корисний контент із сайту бородатих років та підготовлений до використання деякий абсолютно новий. Побічним завданням сумнівної необхідності було перегнати купу графіки під варіант однакової ширини зі збереженням пропорцій. У даному випадку ширина 256px:
    {% highlight shell %}for i in *.webp; do convert -verbose -quality 80 -resize 256x $i $i; done
for i in *.webp; do convert -verbose -quality 80 -resize 256x $i $i; done
for i in *.jpeg; do convert -verbose -quality 80 -resize 256x $i $i; done
for i in *.gif; do convert -verbose -quality 80 -resize 256x $i $i; done{% endhighlight %}
І ще більш сумнівної необхідності операція конвертації svg у.webp. Для цього ще треба доставити одну бібліотеку:
    {% highlight shell %}sudo apt-get install librsvg2-bin{% endhighlight %}
в результаті можемо піддивитися *rsvg-convert --help*. Використовуємо так:
    {% highlight shell %}for i in *.svg; do rsvg-convert $i -a -w 256 -o `echo $i | sed -e 's/svg$.webp/'`; done{% endhighlight %}
Є не зовсім зрозумілий нюанс, якщо в директорії уже є.webp-файли вони чомусь також оброблювалися і ламалися. Якщо встановлений ***Inkscape*** то можна так:
    {% highlight shell %}for i in *; do inkscape $i --export.webp=`echo $i | sed -e 's/svg$.webp/'`; done{% endhighlight %}
або якщо треба переконвертити також у піддиректоріях то виориствуємо так:
    {% highlight shell %}find . -iname \*.webp -exec convert -verbose -quality 80 -resize 256x "{}" "{}" \;{% endhighlight %}
Ну і в кінці допилюємо до пристойного вигляду сам html-код:
    {% highlight shell %}tidy -i -m -w 260 -ashtml -utf8 index.html{% endhighlight %}
Тут ще один момент - система може містити ***tidy*** без підтримки ***html5***, як моя ***ubuntu 12.04***. Треба прибити встановлену і зібрати новий варіант з ***github***:
    {% highlight shell %}sudo apt-get remove libtidy-0.99-0 tidy
sudo apt-get install git-core automake libtool
git clone https://github.com/w3c/tidy-html5cd tidy-html5/build/cmake&nbsp;
cmake ../.. -DCMAKE_BUILD_TYPE=Release
sudo make install{% endhighlight %}
далі ще ніби треба вставити у файл */etc/ld.so.conf* рядок **/usr/local/lib** і виконати     {% highlight shell %}sudo ldconfig{% endhighlight %} але я здається цього не робив і все працює нормально, а інструкція хоч і писалася для ***ubuntu 10.04/12.04*** але після
    {% highlight shell %}git clone{% endhighlight %}

вже була не правильна, там далі вже мої правки.
А в результаті ще й довелося у всіх файлах перевести всі назви картинок до того ж вигляду що і назви файлів(в даному випадку в нижній регістр), вінді й апачу це до лампочки, але якщо вести роботу в лінуксі то не відображається графіка при неспівпадінні регістру.
    {% highlight shell %}for i in *.html; do sed -i '/src=\"logo/ s/[[:upper:]]/\L&amp;/g' $i $i; done{% endhighlight %}
Механізм наступний - ***sed*** шукає рядки в яких є входження **logo/** і переводить весь рядок у нижній регістр, все знаходиться у циклі який проганяє всі html-файли в директорії. Якщо необхідно перевести все у верхній регістр то
    {% highlight shell %}for i in *.html; do sed -i '/src=\"logo/ s/[[:lower:]]/\U&amp;/g' $i $i; done{% endhighlight %}
