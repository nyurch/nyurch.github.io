---
layout: post
comments: true
title: Підсвітка синтаксису в Jekyll. Markdown-версія.
category: [WEB]
---
![Rouge logo](/media/rouge.png?style=head)
На майбутнє, щоб не забути. Можна перейти для відображення програмного коду від конструкцій типу **&lt;xmp&gt;...&lt;/xmp&gt;**, **&lt;code&gt;...&lt;/code&gt;**, **&lt;pre&gt;&lt;code&gt;...&lt;/code&gt;&lt;/pre&gt;** до використання [Rouge](http://rouge.jneen.net/ "Rouge. Офіційний портал."), що вже вбудовано в **Jekyll 3**. <!--more-->Плюси очевидні, незручності(мабуть екранування спецсимволів) почнуть вилазити в процесі.  **&#123;% rаw %&#125;...&#123;% endrаw %&#125;**.

{% highlight console %}труляля{% endhighlight %}


1. Перевіряємо наявність встановлених Rouge та Kramdown

        {% highlight bash %}gem list --local{% endhighlight %}

2. У файл <path>config.yml</path> додаємо наступне

        {% highlight yaml %}markdown: kramdown
        kramdown:
            input: GFM
            syntax_highlighter: rouge{% endhighlight %}

3. Дивимось доступні на даний момент стилі та створюємо **css-файл**

        {% highlight bash %}rougify help style
        ...
        rougify style pastie > css/rouge.css{% endhighlight %}

4. Підключаємо стиль у основний шаблон <path>_layouts/default.html</path>

        {% highlight html %}<link rel="stylesheet" href="/css/rouge.css">{% endhighlight %}

5. Дивимося список підтримуваних мов та аліаси для них. Можна закинути у файл, щоб було під рукою.

         {% highlight bash %}rougify list > rougify.list{% endhighlight %}

Використання наступне - необхідний обривок коду обгортаємо тегами **{% raw %}{% highlight МОВА ПАРАМЕТРИ %}...{% endhighlight %}{% endraw %}**.  
Приклад більшого тексту:

        {% highlight posh %} $Info = "Install choco and other software"
        
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
        until ($selection -eq 'q') {% endhighlight %}

