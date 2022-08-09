---
layout: post
title: Jekyll. Приховані та неопубліковані пости.
category: [WEB]
---
![jekyll logo](/assets/media/jekyll.webp?style=head)  
При необхідності приховати якусь давню і неактуальну публікацію без видалення із сервера чи при необхідності тимчасово<!--more--> приховати недороблену публікацію можна використовувати 2 методи:

-  Тег **published** у шапці посту
  {% highlight html %}---
layout: post
title: Jekyll. Приховані та неопубліковані пости.
published: false
category: [WEB]
---{% endhighlight %}

для перегляду можна запустити локальний сервер з ключем
    {% highlight terminal %}jekyll serve --unpublished{% endhighlight %}

-  Директорія **_drafts**
пости в директорії можуть мати як правильну назву типу *ДАТА-НАЗВА.html(чи .md)* так і бути без дати.
для перегляду також можна запустити локальний сервер з ключем
    {% highlight terminal %}jekyll serve --drafts{% endhighlight %}
якщо не вказана дата посту, при збірці сайту за дату буде взята дата останньої модифікації.
