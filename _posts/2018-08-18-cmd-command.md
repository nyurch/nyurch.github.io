---
layout: post
title: Командний рядок Windows. Деякі команди.
category: [WINDOWS]
---
![cmd logo](/assets/media/bash.png?style=head)  
Набір корисних і дуже корисних команд, котрі забуваються в силу того що це Windows і вони рідко використовуються. Час від часу оновлюється.<!--more-->

#### Підрахунок контрольної суми у powershell
    {% highlight powershell %}Get-FileHash /etc/apt/sources.list | Format-List

Algorithm : SHA256
Hash      : 3CBCFDDEC145E3382D592266BE193E5BE53443138EE6AB6CA09FF20DF609E268
Path      : /etc/apt/sources.list{% endhighlight %}

#### Стати власником директорії, всіх файлів та піддиректорій
    {% highlight terminal %}takeown /F об'єкт /R
F - шаблон імені файлу чи директорії
R - примінити до всіх вкладених об'єктів{% endhighlight %}

#### Отримати повний доступ до директорії, всіх файлів та піддиректорій
    {% highlight terminal %}icacls директорія /grant %username%:(OI)(CI)F /T
F - повний доступ
OI - всі НОВІ файли успадковують задані тут дозволи
CI - всі НОВІ піддиректорії успадковують задані тут дозволи
T - всі ІСНУЮЧІ файли та піддиректорії успадковують задані тут дозволи{% endhighlight %}

#### Кастомізація виводу дати і часу
Зразу приклад скрипта:
    {% highlight terminal %}@echo off
set h=%TIME:~0,2%
set m=%TIME:~3,2%
set s=%TIME:~6,2%
set ms=%TIME:~9,2%
set curtime=%h%:%m%:%s%:%ms%

set dd=%DATE:~0,2%
set mm=%DATE:~3,2%
set yyyy=%DATE:~8,2%
set curdate=%dd%-%mm%-%yyyy%
set curdatetime=%curdate% %curtime%

echo Current data and time - %curdatetime%{% endhighlight %}
Суть у тому що після символу :~ перша цифра вказує починаючи з якого символу стандартної видачі брати значення, а друга кількість символів. По такому ж шаблону можна при бажанні працювати з будь-якими системними змінними.

#### Цикл FOR
В загальному синтаксис наступний:
    {% highlight terminal %}for %%змінна in (файли) do дія - для роботи з файлами
for /D %%змінна in (каталоги) do дія - для роботи з каталогами
for /R [шлях] %%змінна in (файли) do дія - для роботи з файлами у підкаталогах
for /L %%змінна in (початок, крок, кінець) do дія - виконання дій в циклі обмеженої довжини що задається початковим і кінцевим значенням та кроком піж ними{% endhighlight %}
Деякі приклади:
Створюємо 6 директорій з іменами від 0 до 5
    {% highlight terminal %}@echo off
for /L %%i in (0, 1, 5) do mkdir %%i{% endhighlight %}
Виводимо вміст всіх текстових файлів у директорії *%temp%*
    {% highlight terminal %}@echo off
for %%i in (%temp%\*.txt) do (echo %%i){% endhighlight %}
Вивести всі піддиректорії з директорій *%appdata%* та *%temp%*
    {% highlight terminal %}@echo off
for /D %%i in (%appdata%\* %temp%\*) do echo %%i{% endhighlight %}
Вивести всі txt- та md-файли з директорії *%temp%*
    {% highlight terminal %}@echo off
for /R %temp% %%i in (*.txt *.md) do echo %%i{% endhighlight %}
Вивести всі піддиректорії з директорії *%temp%*
    {% highlight terminal %}@echo off
for /R %temp% /d %%i in (*) do echo %%i{% endhighlight %}

#### Визначення mac-адреси
1. windows - getmac
2. linux - arp-scan
