---
layout: post
comments: true
title: Блок з коментарями на сайті.
category: [WEB]
---
![disqus logo](/assets/media/disqus.svg?style=head)  
Для можливості коментування на сайті розглядав 2 варіанти [Disqus](https://disqus.com/ "Disqus"){:target="_blank"} та [Staticman](https://staticman.net/ "Staticman"){:target="_blank"}. <!--more-->Почну з першого, далі буде видно. Далі вкорочений переклад [даного мануалу](https://desiredpersona.com/disqus-comments-jekyll/ "disqus-comments"){:target="_blank"}.
- Створюємо акаунт на <a href="https://disqus.com/" target="_blank" >Disqus</a>
- Проходимось там про майстру початкового налаштування.
- В нашому сайті у файл-конфігурації *config.yml* додаємо відомості про ***Disqus***
    {% highlight YAML %}# Disqus Comments
disqus:
  # Leave shortname blank to disable comments site-wide.
  # Disable comments for any post by adding `comments: false` to that post's YAML Front Matter.
  shortname: my_disqus_shortname{% endhighlight %}

Замість **my_disqus_shortname** прописуємо ім'я що отримали при початковій конфігурації
- Створюємо *./_includes/disqus_comments.html* з наступним вмістом
    {% highlight html %}{% raw %}{% if page.comments != false and jekyll.environment == "production" %}
  <div id="disqus_thread"></div>
  <script>
    var disqus_config = function () {
      this.page.url = '{{ page.url | absolute_url }}';
      this.page.identifier = '{{ page.url | absolute_url }}';
    };
    (function() {
      var d = document, s = d.createElement('script');
      s.src = 'https://{{ site.disqus.shortname }}.disqus.com/embed.js';
      s.setAttribute('data-timestamp', +new Date());
      (d.head || d.body).appendChild(s);
    })();
  </script>
  <noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
{% endif %}{% endraw %}{% endhighlight %}

- У *./_layouts/post.html* додаємо такий код
  {% highlight liquid %}{% raw %}{% if site.disqus.shortname %}
  {% include disqus_comments.html %}
{% endif %}{% endraw %}{% endhighlight %}

- Відключити коментарі для однієї конкретної публікації можна тегом **comments: false** в шапці посту.
