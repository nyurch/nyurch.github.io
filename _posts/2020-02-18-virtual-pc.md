---
layout: post
title: Віртуалізація. VirtualBox та VMWare.
category: [SOFTWARE]
---
![virtual logo](/assets/media/guest-os.webp?style=head)
Костилі для деяких диких глюків та просто деякі моменти при роботі з вітруальними ОС.<!--more-->
#### Лаги
Якщо використовую віртуальну ***Ubuntu*** запущену у ***VMWare Workstation*** під ***Ubuntu*** то отримую з часом дикі тормоза. Лікується, як виявляється, додаванням рядка **clocksource=acpi_pm** у файл *назва_віртуалки.vmx*

#### VirtualBox Guest Additions в Ubuntu
Установка та перевірка:
{% highlight bash %}   sudo apt-get install linux-headers-$(uname -r) build-essential dkms
   wget http://download.virtualbox.org/virtualbox/6.1.18/VBoxGuestAdditions_6.1.18.iso
   sudo mkdir /media/VBoxGuestAdditions
   sudo mount -o loop,ro VBoxGuestAdditions_4.3.8.iso /media/VBoxGuestAdditions
   sudo sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run
   rm VBoxGuestAdditions_4.3.8.iso
   sudo umount /media/VBoxGuestAdditions
   sudo rmdir /media/VBoxGuestAdditions
   sudo reboot
   sudo lsmod | grep vbox{% endhighlight %}
При підключенні спільної папки додаємо юзера в групу:
{% highlight bash %}   sudo adduser $USER vboxsf{% endhighlight %}
бо інакше буде **/media/sf_sharedFolder/: Permission denied**.

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
