---
layout: post
title: Firefox та html5 в Linux.
category: [SOFTWARE]
---
![firefox logo](/assets/media/firefox-logo.png?style=head)  
На даний момент чомусь не працює ***html5-відео*** наприклад на ***yuotube***.<!--more--> Лікується досить просто, треба створити новий **boolean** ключ *media.mediasource.ignore_codecs* і задати йому значення **true**. Також при необхідності задати значення **true** всім ключам що містять *mediasource*.
В результаті маємо те що маємо:
[![html5](/assets/media/html5.png?style=blog "html5")](/assets/media/html5.png "html5"){:target="_blank"}  
