---
layout: post
title: Перекодування тексту.
category: [LINUX]
---
Утиліти для перекодування текстових наборів символів<!--more-->
**recode**, **iconv**
{% highlight shell %}recode CP1251..UTF8 BACKUP-EXEC-201501.txt
iconv -f UTF-8 -t WINDOWS-1251 < BACKUP-EXEC-201501.txt > BACKUP-EXEC-2020.txt{% endhighlight %}
