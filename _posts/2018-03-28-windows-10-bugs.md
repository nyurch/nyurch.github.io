---
layout: post
title: Костилі для Windows 10. Оновлюється.
category: [WINDOWS]
---
![windows logo](/media/windows_10.jpg?style=head)  
Розгрібаємо результати розрідження мозку у індусів з Microsoft - виключаєм оновлення драйверів, кожне друге з яких призволить до смерті системи, повертаємо працездатність
кнопки F8 у процесі завантаження, змінюємо положення директорії Users та повертаємо функціонал адміністративних мережевих ресурсів.<!--more-->

#### wushowhide
Як виявилося дебілізм свого рішення із забороною приховувати оновлення які можуть призводити до краху системи розуміють навіть індуси із MS. А тому існує абсолютно офіційна утиліта що таки дозволяє це робити. Зветься [wushowhide](https://support.microsoft.com/uk-ua/kb/3073930 "wushowhide"){:target="_blank"}. Костиль різний, для різних версій і збірок, так що навіть тут треба обережно.

#### Administrative share
Виявляється починаючи із ***Win8***(?) за замовчуванням закрито доступ до шар типу *c$*. Ідіотизм рішення також більш ніж очевидний тому офіційна інструкція як його повернути присутня. Треба в гілці реєстру *HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System* створити новий ***DWORD-параметр*** з іменем *LocalAccountTokenFilterPolicy* і присвоїти йому значення *1*.

#### F8
Я може чогось недорозумію, але за весь час існування Windows 8 і новіших я все ніяк не можу зрозуміти якому наркоману після лоботомії прийшла в голову ідея заблокувати функцію клавіші F8 в процесі завантаження системи. На щастя повертається на місце все досить просто.
- У розділі *HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager* створюємо *DWORD-параметр BackupCount* і присвоюємо йому значення рівне бажаній кількості бекапів гілки *CurrentControlSet*. Рекомендують *2*, не буду сперечатися.
- У цьому ж розділі створюємо підрозділ *LastKnownGood*, а в ньому *DWORD-параметр Enabled* зі значенням *1*.
- На останок розблоковуємо спрацювання клавіші ***F8***  

    {% highlight terminal %}
    bcdedit /set "{current}" bootmenupolicy legacy{% endhighlight %}

#### Переміщення директорії Users в процесі встановлення
Для переміщення директорії з профілями користувачів у процесі встановлення потрібно на етапі вибору стандартних параметрів перейти в режим аудиту(CTRL+SHIFT+F3). Комп'ютер перезавантажується і запускає ***sysprep***.
- Закриваємо ***sysprep***;
- Створюємо файл *relocate.xml* такого виду. В даному випадку архітектура ***amd64*** та новий шлях до профілів *d:\Users*;
- Копіюємо файл в корінь будь-якого диску;
- Запускаємо командний рядок від імені адміністратора, впевнюємося що вимкнена служба ***WMPNetworkSvc***  

    {% highlight terminal %}
    net stop wmpnetworksvc{% endhighlight %}

- Запускаємо sysprep з потрібними параметрами

    {% highlight terminal %}
    %windir%\system32\sysprep\sysprep.exe /oobe /reboot /unattend:d:\relocate.xml{% endhighlight %}

Після перезавантаження продовжуємо встановлення системи.Теоретично повинно працювати і на живій системі при виконанні пунктів **2-4**. Правда я після цього отримав зациклений перезапуск в режимі аудиту, можливо тому що система була вже не чиста.

#### Your user profile was not loaded correctly! You have been logged on with a temporary profile.
У ***Win Vista+*** якщо перейменувати/перенести профіль доменного користувача(локального теоретично також) то після перезавантеження він не створиться з нуля, як у ***Win XP***, а завантажиться тимчасовий профіль. Ідіотизм рішення очевидний. Лікується видаленням бекапу гілки реєстру *HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\S-1-5-...bak* у якій параметр ***ProfileImagePath*** вказує на директорію де знаходився видалений/переіменований профіль.

#### Відновлення завантажувача Windows 10.
- Завантажуємося з установочного диску Windows 10;
- Доходимо до етапу з кнопкою ***Install Now*** та натискаємо ***Repair your computer***;
[![windows repair](/media/repair-10.jpg?style=blog "Repair")](/media/repair-10.jpg "Repair"){:target="_blank"}
- Далі йдемо за пунктами ***Troubleshoot/Advanced options/Command Prompt***;
[![windows repair](/media/repair-10-1.jpg?style=blog "Repair")](/media/repair-10-1.jpg "Repair"){:target="_blank"}
- Виконуємо:

    {% highlight terminal %}
    Bootrec /fixMbr
    Bootrec /fixBoot{% endhighlight %}

#### NumLock у Windows 10.
Якщо система не вмикає при старті NumLock незважаючи ні на налаштування bios, ні на свої можна ще спробувати руками у гілці реєстру *HKEY_USERS\.Default\Control Panel\Keyboard* задати параметру *InitialKeyboardIndicators* значення *2*, значення за замовчуванням *0*. Це має увімкнути NumLock ще на етапі *logonscreen*.

#### Пропадає індикатор клавіатури.
Пропадає індикатор розкладки клавіатури після перезавантаження. Якщо зайти в налаштування клавіатури то зразу з'являється. Після перезавантаження знов пропадає. На даний момент лікується костилем в автозавантаженні(*%ProgramData%\Microsoft\Windows\Start Menu\Programs\StartUp*).

    {% highlight shell %}
    @ECHO OFF
    ECHO
    start ms-settings:regionlanguage
    TIMEOUT /T 1
    taskkill /F /IM systemsettings.exe{% endhighlight %}
