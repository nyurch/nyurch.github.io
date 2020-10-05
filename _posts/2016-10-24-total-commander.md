---
layout: post
title: Total Commander LP 9.1a
category: [SOFTWARE]
---
![tcm logo](/media/tc-logo.png?style=head)  
На ***Windows*** без ***Total Commander*** як на машині без коліс. Біда в тому що він у базовій комплектації як машина з колесами, але без мотору. Тому своя персональна збірка - ідеальний варіант, тим більше що в найпростішому вигляді, без інсталятора й вибору варіантів установки, її може навіть шимпанзе із зоопарку зібрати.<!--more-->
Отже інсталятор для x64 та x86 систем суміщено, розрядність системи автоматично визначається в процесі встановлення. На 32-розрядну систему ставиться 32-бітна версія, а на 64-розрядну - 32-бітна й 64-бітна(так як не всі плагіни ще мають 64-бітні версії). Є деякі костилі бо зараз трохи лінь заглиблюватися в програмуванні та ***Inno Setup***. Так зараз на x64-системі якщо запускати ***Notepad++*** з іконки у x86-версії ТС то отримаємо дулю, а сама іконка чомусь не промальовується. Головне що при запуску програми що відповідає розрядності системи багів не виявлено. Отже...
**Тип інсталятора:** ***innosetup***.  
**Склад збірки**:
- **додатковий софт**: ccleaner, defraggler, recuva, notepad++(редактор за замовчуванням), extDir(працює по Shift +F7), impomezia(вибір кольорових схем для файлів), totalupdater(оновлення встановлених плагінів), ch4tc(очищення історії менеджера);
- **плагіни:** **архіваторні** - 7zip, IMAginator, IShield, ISO; **контентні** - anytag, directory, dirsize, exeinfo, image info, lotsofhashes, media info; **системні** - DiskInternals_Reader, EnvVars, Plugin Manager, Registry, Services2, sftp4tc, Startups, SystemEventsEx, Uninstall; **лістерні** - AKFont, ArchView, Excellence, fileinfo, Highlight. HTMLView, ICLView, Imagine, LinkInfo, Listdoc, LogViewer, OOoViewer, slister, SVGView, SWFView, VisualDirSize;
- **додаткові набори колонок**: Відео, Аудіо, Програмні файли, Доступ і модифікація, Графіка, Статистика тек.  

Скріншоти процесу встановлення та базовий:
[![install tcm](/media/install_tc-01.png?style=blog "install tcm")](/media/install_tc-01.png "install tcm"){:target="_blank"}  
[![install tcm](/media/install_tc-02.png?style=blog "install tcm")](/media/install_tc-02.png "install tcm"){:target="_blank"}  
[![install tcm](/media/install_tc-03.png?style=blog "install tcm")](/media/install_tc-03.png "install tcm"){:target="_blank"}  
Забрати [тут](https://goo.gl/7xVLEC "збарегти TCM"){:target="_blank"}.
