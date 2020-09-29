---
layout: post
comments: true
title: Jekyll. Пошук по сайту.
category: [WEB]
---
![Jekyll logo](/media/jekyll.png?style=head)  
Останній костиль у блог - пошук по сайту. Є 3 варіанти: **Google Custom Search Engine**, **Lunr.js** та **Simple Jekyll Search**.<!--more--> **Lunr** читав має проблеми з пошуком на кирилиці, тому не видумуючи велосипед для початку пробую використовувати те що вже є в самому **jekyll**  
Зроблено по [статті](https://blog.webjeda.com/instant-jekyll-search/ "Jekyll Instant Search in 3 simple steps!").

- У корені блогу створюємо *search.json* з наступним вмістом

        {% highlight liquid %}{% raw %}
        ---
        ---
        [
          {% for post in site.posts %}
            {
        
              "title"    : "{{ post.title | escape }}",
              "url"      : "{{ site.baseurl }}{{ post.url }}",
              "category" : "{{ post.category }}",
              "tags"     : "{{ post.tags | join: ', ' }}",
              "date"     : "{{ post.date }}"
        
            } {% unless forloop.last %},{% endunless %}
          {% endfor %}
        ]
        {% endraw %}{% endhighlight %}

- Зберігаємо [search-script.js](https://raw.githubusercontent.com/christian-fei/Simple-Jekyll-Search/master/dest/simple-jekyll-search.min.js "Скрипт пошуку");
- Створюємо шаблонну сторінку пошуку, чи додаємо наступний код до шаблону

        {% highlight html %}
        <!-- Html Elements for Search -->
        <div id="search-container">
        <input type="text" id="search-input" placeholder="search...">
        <ul id="results-container"></ul>
        </div>
        
        <!-- Script pointing to search-script.js -->
        <script src="/path/to/search-script.js" type="text/javascript"></script>
        
        <!-- Configuration -->
        <script>
        SimpleJekyllSearch({
          searchInput: document.getElementById('search-input'),
          resultsContainer: document.getElementById('results-container'),
          json: '/search.json'
        })
        </script>{% endhighlight %}

Готово.

