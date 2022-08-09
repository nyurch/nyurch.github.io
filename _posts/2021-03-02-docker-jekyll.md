---
layout: post
title: Jekyll у Docker. Історія одного експерименту.
category: [SOFTWARE]
---
![docker logo](/assets/media/docker.webp?style=head)  
Постановка задачі - треба **Jekyll**, але це значить **Linux**, на на ПК - **Windows**. Використати **Docker** рішення що напрошується, можна звичайно підняти цілу віртуалку, але заради 1 серверу не дуже логічно, а розвертати на існуючій, яка може бути замучена експериментами в будь-який момент, ще нелогічніше.<!--more-->
Отже ставимо [Docker](https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe "Docker for Windows"){:target="_blank"}.  
Розгортаємо **jekyll**
{% highlight bash %}docker pull jekyll/jekyll{% endhighlight %}
Запускаємо
{% highlight bash %}docker run --rm --volume="d:\docker\jekyll\jekyll_home:/srv/jekyll" -p 4000:4000 -it jekyll/jekyll jekyll serve{% endhighlight %}

Далі напрошується **docker-compose**.  
*docker_compose.yml*
{% highlight yaml %}version: '3'

services:
  jekyll:
    image: jekyll/jekyll
    command: jekyll serve
    ports:
      - 4000:4000
    volumes:
      - d:\docker\jekyll\jekyll_home:/srv/jekyll{% endhighlight %}

До даного етапу не дійшов, описано за [статтею з інтернетів](https://matthiaslischka.at/2018/12/22/jekyll-docker-compose/){:target="_blank"}.  
А недійшов, бо з докером у вінді є одна велика неприємність, він працює використовуючи **hyper-v**, а це значить що можна забути про будь-які інші гіпервізори, а жертвувати **virtualbox**-ом заради одного продукту це не діло.  

Зрештою виявилося що **jekyll** можна поставити у вигляді костиля [Ruby+Devkit](https://jekyllrb.com/docs/installation/windows/){:target="_blank"} прямо на віндовс. Можна і на **WSL** звичайно, але маю деякі зауваження, не відомо скільки вона ще проживе, а **WSL 2** уже, знов таки, задіює **hyper-v**.  

Паралельно розмножив кількість відомих [костилів для ***MS***](http://localhost:4000/windows/2021/03/02/hyper-v-on-off.html "Як жити з Hyper-V та VirtualBox"){:target="_blank"} .
