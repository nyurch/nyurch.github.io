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
Беру з Heffem чи SSD21 папку _./panels/game_ і повністю додаю. Далі розбиратися лінь.
З SSD21 _./panels/match/fixture details.xml_
З TCS20 чи SSD21 _./panels/player_
