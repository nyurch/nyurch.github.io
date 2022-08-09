---
layout: post
comments: true
title: Підсвітка синтаксису в Jekyll.
category: [WEB]
---
![rouge logo](/assets/media/rouge.webp?style=head)  
Перейшов на використання [Rouge](http://rouge.jneen.net/ "Rouge"){:target="_blank"}, що вже вбудовано в ***Jekyll 3***. <!--more-->Плюси очевидні, незручності(мабуть екранування спецсимволів) почнуть вилазити в процесі.  **&#123;% rаw %&#125;...&#123;% endrаw %&#125;** - екранує код(щось хотів тут написати, але вже забув).

- Перевіряємо наявність встановлених ***Rouge*** та ***Kramdown***
    {% highlight terminal %}gem list --local{% endhighlight %}
- У файл *config.yml* додаємо наступне
    {% highlight yml %}markdown: kramdown
kramdown:
  input: GFM
  syntax_highlighter: rouge{% endhighlight %}
- Дивимось доступні на даний момент стилі та створюємо *css-файл*.
    {% highlight shell %}rougify help style
...
rougify style pastie > css/rouge.css{% endhighlight %}

- Підключаємо стиль у основний шаблон *_layouts/default.html*
    {% highlight html %}<link rel="stylesheet" href="/assets/css/rouge.css">{% endhighlight %}
- Дивимося список підтримуваних мов та аліаси для них. Можна закинути у файл, щоб було під рукою.
    {% highlight terminal %}rougify list > rougify.list{% endhighlight %}

Використання наступне - необхідний обривок коду обгортаємо тегами **{% raw %}{% highlight МОВА ПАРАМЕТРИ %}...{% endhighlight %}{% endraw %}**. Всі вищепоказані вставки у текстові файли уже показані за цим принципом. Приклад більшого тексту:
  {% highlight posh linenos %}$Title = "Welcome"
$Info = "Install choco and other software"

function Show-Menu {
    param (
        [string]$Title = 'Main Menu'
    )
    Clear-Host
    Write-Host "================ $Title ================"

    Write-Host "1: Install choco."
    Write-Host "2: Install software."
    Write-Host "3: Check software update."
    Write-Host "4: Update software."
    Write-Host "5: Uninstall software."
    Write-Host "6: List cinstalled software."
    Write-Host "7: Disable hibernation."
    Write-Host "8: Interface tweaks."
    Write-Host "Q: Quit."

    Write-Host "==========================================="
}

do
 {
    Show-Menu
    $selection = Read-Host "Please make a selection"
    switch ($selection)
    {
    '1' {
    Set-ExecutionPolicy Bypass -Scope Process -Force; `
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    pause
    exit
    } '2' {
    choco install doublecmd --nocolor --limitoutput --no-progress -y
    } '3' {
    choco outdated
    } '4' {
    choco update all
    } '5' {
    choco uninstall doublecmd --nocolor --limitoutput --no-progress -y
    } '6' {
    choco list -localonly
    } '7' {
    powercfg -h off
    } '8' {
    reg import first_run.reg
	cmd /c del /f /q %systemdrive%\users\%username%\desktop\"Microsoft Edge.lnk"
    }
    }
    pause
 }
 until ($selection -eq 'q'){% endhighlight %}

Написано по [даному тексту](https://bnhr.xyz/2017/03/25/add-syntax-highlighting-to-your-jekyll-site-with-rouge.html "Rouge"){:target="_blank"}.
