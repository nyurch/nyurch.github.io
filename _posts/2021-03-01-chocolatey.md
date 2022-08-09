---
layout: post
title: Chocolatey. Створення власного пакету та локальний репозиторій.
category: [SOFTWARE]
---
![chocolatey logo](/assets/media/choco.webp?style=head)  
[Оновлення 01/03/2021](#ще-пара-костилів-до-шоколаду)  
Ком'юніті репозиторій **Chocolatey** містить фактично все що треба, але в той же час для деякого чисто корпоративного чи рідкісного софту треба писати самому. В нульовому наближенні це робиться якось так...<!--more-->

- Інсталимо якщо ще не встановлений ***Chocolatey*** та необхідні додаткові пакети.
      {% highlight powershell %}powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%systemdrive%\chocolatey\bin{% endhighlight %}
тут звертаємо увагу на *.\chocolatey\bin* бо положення може відрізнятися від версії до версії.
      {% highlight powershell %}cinst warmup
cinst git
cinst nuget.commandline{% endhighlight %}
- Йдемо в папку з ***chocolate*** і створюємо папку *packages* де будуть зібрані пакети
- Генеруємо шаблон(на прикладі ***Total Commander***)
  {% highlight powershell %}choco new totalcmd
cd totalcmd{% endhighlight %}
- Правимо файли *totalcmd.nuspec* - описовий файл в корені та файл конфігурації *chocolateyinstall.ps1*
- Очищаємо файл конфігурації від всього закоментованого
  {% highlight powershell %}$f='C:\ProgramData\chocolatey\packages\totalcmd\tools\chocolateyinstall.ps1'
gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f{% endhighlight %}

- Генеруємо контрольну суму для установочного файлу.
  {% highlight powershell %}Get-FileHash tcmd951x32_64.exe | Format-List{% endhighlight %}
- Генеруємо пакет для ***Chocolatey***.
      {% highlight powershell %}choco pack{% endhighlight %}
- Перевірити наявність пакету можна так:
      {% highlight powershell %}choco list -s C:\ProgramData\chocolatey\packages{% endhighlight %}
- Тепер його можна встановлювати указавши джерело пакетів, без указання джерела його шукатиме на офіційному репозиторії.
      {% highlight powershell %}choco install totalcmd -s C:\ProgramData\chocolatey\packages -y{% endhighlight %}

Зразки файлів конфігурації *totalcmd.nuspec*
  {% highlight conf %} <?xml version="1.0" encoding="utf-8"?>
<package xmlns="http://schemas.microsoft.com/packaging/2015/06/nuspec.xsd">
  <metadata>
    <id>totalcmd</id>
    <version>9.51</version>
    <title>totalcmd (Install)</title>
    <authors>nyurch</authors>
    <projectUrl>https://www.ghisler.com/</projectUrl>
    <tags>totalcmd file manager</tags>
    <summary>file manager</summary>
    <description>file manager</description>
  </metadata>
  <files>
    <file src="tools\**" target="tools" />
  </files>
</package>{% endhighlight %}

та *chocolateyinstall.ps1*

  {% highlight conf %}$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'C:\Users\zf\Downloads\tcmd951x32_64.exe'
файл chocolateyinstall.ps1
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url

  softwareName  = 'totalcmd*'

  checksum      = '2D2115049AEA04C0AF4090571F212AC553811338FA6C9EAEBFF88D6B61D35448'
  checksumType  = 'sha256'

  silentArgs    = "/AHMD`"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs{% endhighlight %}

Тепер до основного, все це добре але хотілося б мати локальний сервер який би дзеркалив репозиторій ком'юніті плюс містив софт якого там нема. Це вирішується або покупкою корпоративних версій ***Chocolatey PRO*** чи ***Chocolatey Business(C4B)*** у яких для команди *choco* доступний ключ **download**. А можна як завжди ліпити з глини і палок, що як мінімум цікавіше :) Для цього є проект [ChocolateStore](https://github.com/BahKoo/ChocolateStore "ChocolateStore"){:target="_blank"}. В результаті можна закачати з репозиторію потрібні програми, додати свої, надати доступ до локального репозиторію в мережі і вказувати що програми ставимо з нього
  {% highlight posh %}choco install totalcmd -s \\127.0.0.1\packages -y{% endhighlight %}
Тепер можна добавити глини і палок щоб пакети у локальному репозиторії обновлялися наприклад раз у тиждень і маємо досить непогане рішення. Ну і можна додати свистєлок і пердєлок зліпивши наприклад на ***zenity*** графічний інтерфейс щоб ставити не весь софт, а натикати галочок напроти потрібного і поставити тільки обране.

#### Ще пара костилів до шоколаду.

На віддаленому ПК включити **PowerShell remoting**
{% highlight powershell %}Enable-PSRemoting -Force{% endhighlight %}

Установка chocolatey на віддалений ПК(задати значення remotePC)
{% highlight powershell %}$Credential = Get-Credential
Invoke-Command -ComputerName remotePC -Credential $Credential -ScriptBlock {
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    choco feature enable -n allowGlobalConfirmation
}
{% endhighlight %}

І далі
{% highlight powershell %}$Credential = Get-Credential
Invoke-Command -ComputerName remotePC -Credential $Credential -ScriptBlock {
    choco install program1
    choco install program2
    choco install program3
}
{% endhighlight %}

Хоча краще звичайно не придумувати велосипед і використовувати **Ansible**, мануал по якому все ще в драфті.
