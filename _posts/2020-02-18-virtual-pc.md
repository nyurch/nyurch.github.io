---
layout: post
title: Віртуалізація. VirtualBox та VMWare.
category: [SOFTWARE]
---
![virtual logo](/assets/media/guest-os.jpg?style=head)
Костилі для деяких диких глюків та просто деякі моменти при роботі з вітруальними ОС.<!--more-->
#### Лаги
Якщо використовую віртуальну ***Ubuntu*** запущену у ***VMWare Workstation*** під ***Ubuntu*** то отримую з часом дикі тормоза. Лікується, як виявляється, додаванням рядка **clocksource=acpi_pm** у файл *назва_віртуалки.vmx*

#### VirtualBox Guest Additions в Ubuntu
Для початку оновлюємо ядро, доставляємо необхідні пакети і переконфігуровуємся:
    {% highlight shell %}sudo apt-get update
sudo apt-get upgrade
sudo apt-get install build-essential module-assistant
sudo m-a prepare{% endhighlight %}
Тепер можна встановлювати ***Guest Additions***

#### Встановлення VirtualBox Extension Pack в терміналі
    {% highlight shell %}VBoxManage extpack install <ім'я пакету> {% endhighlight %}

#### VMWare Workstation BIOS
Буває нереально встигнути заактивити вікно й натиснути необхідну кнопку. Лікується додаванням рядка **bios.bootdelay = Т** у файл *назва_віртуалки.vmx*. Де **T** - бажаний час затримки у мілісекундах.

#### VirtualBox завантаження з USB-диску
Для тестів завантажувальних флешок - під'єднуємо і створюємо vmdk-образ для VirtualBox
    {% highlight shell %}sudo vboxmanage internalcommands createrawvmdk -filename ~/Temp/usb.vmdk -rawdisk /dev/sdc -relative{% endhighlight %}
Даємо права на образ
    {% highlight shell %}sudo chmod 777 usb.vmdk{% endhighlight %}
Додаємо користувача у групи ***disk***, потрібно для доступу до raw-дисків, та ***vboxusers***, впринципі він уже повинен там бути.
    {% highlight shell %}sudo usermod -a -G disk $USER
sudo usermod -a -G vboxusers $USER{% endhighlight %}
Перелогінюємся. При вставленій флешці створений парусотбайтний файл дозволяє з неї завантажуватися.
