---
layout: post
title: Firefox та html5 в Linux.
category: [SOFTWARE]
---
![firefox logo](/assets/media/firefox-logo.webp?style=head)  
На даний момент чомусь не працює ***html5-відео*** наприклад на ***yuotube***.<!--more--> Лікується досить просто, треба створити новий **boolean** ключ *media.mediasource.ignore_codecs* і задати йому значення **true**. Також при необхідності задати значення **true** всім ключам що містять *mediasource*.
В результаті маємо те що маємо:
[![html5](/assets/media/html5.webp?style=blog "html5")](/assets/media/html5.webp "html5"){:target="_blank"}  
