---
layout: post
title: Football Manager.
category: [SOFTWARE]
---
![footballmanager logo](/assets/media/footballmanager.png?style=head)  
Мда... :).<!--more-->

#### Список параметрів які не їдять РА:
1. Agression
2. Determination
3. Flair
4. Natural Fitnes
5. Composure

#### Баги недефолтних скінів:
* green box issue - you can resolve it by changing line **24** in *inbox content with comp matchday preview panel.xml* and line **94** of *inbox content with match preview panel.xml* to be
		{% highlight shell %}<container id="ICdi" height="180">{% endhighlight %}
* кнопка "Заміна" пропала в неанглійських скінах - у файлі *match title bar.xml* знайти **202** рядок та змінити

		{% highlight shell %}<layout class="horizontal_arrange" horizontal_layout="-9,2,-10" />{% endhighlight %}

на

	   {% highlight shell %}<layout class="horizontal_arrange" horizontal_layout="-5,2,-9" />{% endhighlight %}

#### Переіменування нових стадіонів
Робимо файл *.\Football Manager 2020\data\database\db\2010\lnc\all\stadium.lnc* такого типу
  {% highlight shell %}"STADIUM_NAME_CHANGE"    2000003455 "Stade Jean-Bernard Lévy" ""
"STADIUM_NAME_CHANGE"    2000003462 "Stade Henri Monnier" ""
"STADIUM_NAME_CHANGE"    2000003490 "Stade Roger Courtois" ""
"STADIUM_NAME_CHANGE"    2000003541 "Stade Jean Prouff" ""
"STADIUM_NAME_CHANGE"    2000003555 "Stade René Dufaure de Montmirail" ""
"STADIUM_NAME_CHANGE"    2000003543 "Stade Drago Vabec" ""
"STADIUM_NAME_CHANGE"    2000003538 "Friedrich Bayer Arena" ""
"STADIUM_NAME_CHANGE"    2000003561 "Stade Saint-Lambert" ""
"STADIUM_NAME_CHANGE"    2000003563 "Stade Juste Fontaine" ""
"STADIUM_NAME_CHANGE"    2000003560 "Parc Jean-Luc Ettori" ""
"STADIUM_NAME_CHANGE"    2000003564 "Stade Luis Fernandez" ""
"STADIUM_NAME_CHANGE"    2000003572 "Stade Jules Rimet" ""{% endhighlight %}

#### Кастомний скін
Беру з Heffem чи SSD21 папку _./panels/game_ і повністю додаю. Далі розбиратися лінь. Це фотографія домашнього стадіону наступного матчу при прокрутці часу.
З SSD21 _./panels/match/fixture details.xml_ , це фото стадіону на якому відбувався матч на панелі календаря сезону.
Наступний код додає фото міста на клубну панель, чи куди вставиш:
  {% highlight xml %}<widget class="background" file="backgrounds" id="bgnd">
<layout class="stick_to_sides_attachment" alignment="top" inset="0" />
<layout class="stick_to_sides_attachment" alignment="horizontal" inset="0" />
<layout class="stick_to_sides_attachment" alignment="left" offset="0" gap="0" />
<record id="object_property">
<integer id="get_property" value="bgnd" />
<integer id="set_property" value="file" />
</record>
</widget>{% endhighlight %}  
Хм... Не всюду, а на якісь сторінки фото міст, на якісь стадіонів.
При цьому щоб позбутися бекграунду, а фото міст працюють виключно як бекграунд, беру _client object browser.xml_ з дефолтного скіна.
З TCS20 чи SSD21 _./panels/player_ , уже не беру. Вже нормальний у FME Dark.
Трохи розширив топ-бар щоб збільшити там розмір гербів. Файли _.\panels\generic\header.xml_ та _.\panels\generic\titlebar.xml_
Нормальні назви клубів у матчі:
У файлі _.\panels\match\match score area panel.xml_ знайти віджети з іменами і замінити на такі:
{% highlight xml %}<widget class="team_button" id="homN" icon_enabled="true" auto_size="yes" font="title" size="10" alignment="right,centre_y,can_scale" click_event="htac" navigation_focus_target="false" colour="black" mode="1">
  <record id="object_property" get_property="home" set_property="valu" />
</widget>

<widget class="team_button" id="awaN" icon_enabled="true" auto_size="yes" font="title" size="10" alignment="left,centre_y,can_scale" click_event="atac" navigation_focus_target="false" colour="black" mode="1">
  <record id="object_property" get_property="away" set_property="valu" />
</widget>{% endhighlight %}  
Тут же замінити ширину панелі на ``<panel width="510">`` і ширину контейнерів з іменами на ``<container width="410" id="temc">``
