---
layout: post
title: Створення власної збірки Ubuntu з блек-джеком та дівками.
category: [LINUX]
---
![ubuntu logo](/media/ubuntu-logo.png?style=head)  
Процес збирання власного дистрибутиву досить простий, очевидний і прекрасно розжований на [офіційній сторінці](https://help.ubuntu.com/community/LiveCDCustomization "LiveCDCustomization"){:target="_blank"}. Дана інструкція це фактично максимально спрощений переклад.<!--more-->
При збиранні образ котрий збирається повинен за розрядністю співпадати з системою на якій проводиться збирання. Отже за порядком:

- Довстановлюємо необхідні пакети:
    {% highlight shell %}sudo aptitude install squashfs-tools genisoimage{% endhighlight %}

- Розпаковуємо та підключаємо чистий образ, у даному випадку **ubuntu-12.04-desktop-amd64.iso**:
    {% highlight shell %}mkdir livecdtmp
cd livecdtmp
mkdir mnt
mkdir extract-cd
sudo mount -o loop ubuntu-12.04-desktop-amd64.iso mnt
sudo rsync --exclude=/casper/filesystem.squashfs -a mnt/ extract-cd
sudo unsquashfs mnt/casper/filesystem.squashfs
sudo mv squashfs-root edit

sudo cp /etc/resolv.conf edit/etc/ <--! для 14.04 !-->
sudo mount -o bind /run/ edit/run <--! для новіших за 14.04 !-->
sudo cp /etc/hosts edit/etc/ <--! може знадобитися !-->

sudo mount --bind /dev/ edit/dev
sudo chroot edit

mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts
export HOME=/root
export LC_ALL=C{% endhighlight %}

- Вносимо необхідні зміни в образ
- Чистимо, розмонтовуємо та перепаковуємо змінений образ
    {% highlight shell %}apt-get clean
rm -rf /tmp/* ~/.bash_history /home/*
rm /var/lib/dbus/machine-id <--! якщо ставився софт !-->
rm /sbin/initctl
dpkg-divert --rename --remove /sbin/initctl
umount /proc || umount -lf /proc
umount /sys
umount /dev/pts
exit

sudo umount edit/dev

chmod +w extract-cd/casper/filesystem.manifest
sudo chroot edit dpkg-query -W --showformat='${Package} ${Version}\n' > extract-cd/casper/filesystem.manifest
sudo cp extract-cd/casper/filesystem.manifest extract-cd/casper/filesystem.manifest-desktop
sudo sed -i '/ubiquity/d' extract-cd/casper/filesystem.manifest-desktop
sudo sed -i '/casper/d' extract-cd/casper/filesystem.manifest-desktop
sudo mksquashfs edit extract-cd/casper/filesystem.squashfs -b 1048576

sudo sh -c "printf $(sudo du -sx --block-size=1 edit | cut -f1) > extract-cd/casper/filesystem.size"

cd extract-cd
sudo rm md5sum.txt
find -type f -print0 | sudo xargs -0 md5sum | grep -v isolinux/boot.cat | sudo tee md5sum.txt{% endhighlight %}

- Створюємо iso-образ:
    {% highlight shell %}sudo mkisofs -D -r -V "$IMAGE_NAME" -cache-inodes -J -T -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -allow-leading-dots -relaxed-filenames -joliet-long -max-iso9660-filenames -o ../ubuntu-12.04-amd64.iso .{% endhighlight %}


В результаті маємо модифікований образ у файлі _ubuntu-12.04-amd64.iso_.  
У принципі останнім часом почав більше схилятися до варіанту постінсталяційного набору сценаріїв розбитих на 3 етапи: додавання сторонніх репозиторіїв, встановлення програм, зміна зовнішнього вигляду. І один, і другий варіант мають свої плюси. Перший дає гарантований результат навіть якщо немає підключення до інтернету, а воно зараз є майже скрізь, другий економить час на процесі збирання образу, а сумарний час розвертання виходить фактично такий же як і у першому випадку бо розмір оновлень для варіанту один за півроку-рік стає таким же як розмір встановлюваних з нуля пакетів у варіанті два.
Практично було перевірено на дистрибутивах **10.04** та **12.04**.
