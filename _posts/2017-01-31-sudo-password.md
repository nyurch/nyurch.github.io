---
layout: post
title: Час дії пароля при виконанні команди з правами суперюзера.
category: [LINUX]
---
![sudo logo](/assets/media/sudo.png?style=head)  
Коли виконується команда від імені суперюзера, наприклад **sudo apt update**, наступні **Х** хвилин команди типу **sudo команда** можна виконувати не вводячи пароль.<!--more--> Змінити час дії пароля можна у файлі */etc/sudoers*
    {% highlight terminal %}sudo visudo{% endhighlight %}
І рядок
  {% highlight shell %}Defaults        env_reset{% endhighlight %}
змінюємо на
  {% highlight shell %}Defaults        env_reset,timestamp_timeout=20{% endhighlight %}
де параметр **timestamp_timeout** задає термін дії паролю у хвилинах.
