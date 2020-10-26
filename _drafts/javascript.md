---
layout: post
title: Javascript для дебілів.
category: [WEB]
---

![atom logo](/assets/media/js.svg?style=head)  

#### Два і більше скрипта на одну подію.
Часом мавпа хоче прикрутити до сайту трошки **javascript-ів**, але мавпа є мавпа. Працює тільки **1** з **Х** доданих що мають спрацьовувати при події наприклад **onscroll**. <!--more-->  
Проблему вирішує наступна конструкція:

{% highlight js %}
window.onscroll = function() {
    scrollFunction();
    myFunction();
    myFunctionPrg();
};
{% endhighlight %}

або так

{% highlight js %}
window.addEventListener("scroll", scrollFunction);
window.addEventListener("scroll", myFunction);
window.addEventListener("scroll", myFunctionPrg);
{% endhighlight %}

Другий варіант реалізовував практично, в шаблоні сайту. Перший не перевіряв.

#### Змінні
Один костиль для одного сайту.  
Змінні такого типу в **js**-файлі, щоб не використовувати ніяких баз даних:
{% highlight js %}
var var_ch = {
	variable_1: "1973, 1974, 1977, 1980, 1982, 1983, 1985, 1986, 1989, 1990, 1995, 2004, 2006, 2008",
	variable_2: "1968, 1987, 2007, 2009, 2012, 2013, 2015, 2017",
	variable_3: "1963, 1996, 2002, 2003, 2005, 2014, 2016",
	variable_4: "1972, 1975, 1976, 1978, 1979, 1999, 2010",
}
var var_c = {
	variable_1: "1977, 1986, 1992, 1994, 2011",
	variable_2: "1963, 1964, 1967, 1968, 1980, 1989, 2010, 2012",
	variable_3: "1981, 1988, 1997, 1999, 2001, 2003, 2004, 2013",
}
{% endhighlight %}

Далі у **html**-файлі вони використовуються якось так:

{% highlight html %}
<b>Рядок змінних 1:</b> <script type="text/javascript">document.writeln(var_ch.variable_1)</script><br>
<b>Рядок змінних 2:</b> <script type="text/javascript">document.writeln(var_c.variable_1)</script><br>
{% endhighlight %}
