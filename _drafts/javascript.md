---
layout: post
title: Javascript для дебілів.
category: [WEB]
---

![atom logo](/assets/media/js.svg?style=head)  
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
