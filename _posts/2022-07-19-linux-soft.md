---
layout: post
title: Нестандартний софт у Linux.
category: [LINUX]
---
![software logo](/assets/media/software.webp?style=head)
Список цікавого софту що не включається в базові збірки, використовується не так часто, а тому часом забуваються. Незаслужено.<!--more-->
#### ***neofetch*** - інформація про систему в терміналі

[![neofetch](/assets/media/neofetch.webp?style=blog "neofetch")](/assets/media/neofetch.webp "neofetch"){:target="_blank"}

#### ***ncdu*** - термінальний аналізатор використання диску

[![ncdu](/assets/media/ncdu.webp?style=blog "ncdu")](/assets/media/ncdu.webp "ncdu"){:target="_blank"}

#### ***htop*** - термінальний монітор процесів

[![htop](/assets/media/htop.webp?style=blog "htop")](/assets/media/htop.webp "htop"){:target="_blank"}

#### [scrpy](https://github.com/Genymobile/scrcpy "scrpy"){:target="_blank"} - перегляд та контроль підключених по USB android-пристроїв

[![scrpy](/assets/media/scrpy.webp?style=blog "scrpy")](/assets/media/scrpy.webp "scrpy"){:target="_blank"}

#### [WoeUSB](https://github.com/slacka/WoeUSB "WoeUSB"){:target="_blank"} - створення завантажувальної флешки з Windows

[![WoeUSB](/assets/media/woeusb.webp?style=blog "WoeUSB")](/assets/media/woeusb.webp "WoeUSB"){:target="_blank"}

#### [GTKStressTest](https://flathub.org/apps/details/com.leinardi.gst "GTKStressTest"){:target="_blank"} - інформація про залізо, та стрес-тест

[![GTKStressTest](/assets/media/stresstest.webp?style=blog "GTKStressTest")](/assets/media/stresstest.webp "GTKStressTest"){:target="_blank"}

#### [![WoeUSB](/assets/media/woeusb.webp?style=blog "WoeUSB")](/assets/media/WoeUSB.webp "WoeUSB"){:target="_blank"}

#### [GTKStressTest](https://flathub.org/apps/details/com.leinardi.gst "GTKStressTest"){:target="_blank"} - інформація про залізо, та стрес-тест

[![GTKStressTest](/assets/media/stresstest.webp?style=blog "GTKStressTest")](/assets/media/StressTest.webp "GTKStressTest"){:target="_blank"}

#### [Tealdeer](https://github.com/dbrgn/tealdeer "Tealdeer"){:target="_blank"} - аналог **man** базується на прикладах

[![Tealdeer](/assets/media/tealdeer.webp?style=blog "Tealdeer")](/assets/media/tealdeer.webp "Tealdeer"){:target="_blank"}

#### ***smem*** - аналіз використання оперативної пам'яті
{% highlight shell %}[11/06/2021 16:32] deimos@sol:~ $ smem -t -k -c pss -P firefox | tail -n 1
  806.0M{% endhighlight %}
Можна зробити універсальний скрипт:
{% highlight shell %}[11/06/2021 16:32] deimos@sol:~ $ echo 'smem -c pss -P "$1" -k -t | tail -n 1' > ~/bin/memory-use && chmod +x ~/bin/memory-use
[11/06/2021 16:32] deimos@sol:~ $ memory-use firefox
  806.0M{% endhighlight %}
Також можна вивести графічне представлення:
{% highlight shell %}[11/06/2021 16:32] deimos@sol:~ $ smem --pie name -c pss{% endhighlight %}
[![smem](/assets/media/smem.webp?style=blog "smem")](/assets/media/smem.webp "smem"){:target="_blank"}

#### [duf](https://github.com/muesli/duf "duf"){:target="_blank"} - альтернатива класичним **du/df**
[![duf](https://github.com/muesli/duf/raw/master/duf.webp?style=blog "smem")](https://github.com/muesli/duf/raw/master/duf.webp "duf"){:target="_blank"}

#### [deb-get](https://github.com/wimpysworld/deb-get "deb-get"){:target="_blank"} - аналог **apt-get** для deb-файлів
{% highlight shell %}[11/07/2022 16:32] deimos@sol:~ $ sudo apt install curl
[11/07/2022 16:32] deimos@sol:~ $ curl -sL https://raw.githubusercontent.com/wimpysworld/deb-get/main/deb-get | sudo -E bash -s install deb-get{% endhighlight %}
використання схоже на **aptitude/apt-get**
