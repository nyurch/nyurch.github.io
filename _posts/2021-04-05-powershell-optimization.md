---
layout: post
title: Дещо про оптимізацію терміналу powershell.
category: [WINDOWS]
---

![powershell logo](/assets/media/ps.png?style=head)  
Останнім часом більше доводиться працювати з **_Windows_** і тому дозрів нарешті до оптимізації терміналу, щоб з убогості повної зробити щось що хоч більш-менш пристойно виглядає і дає хоч якусь мінімально прийнятну візуалізацію при хоч якійсь автоматизації. Вцілому жити без додаткових костилів від **_Sysinternals_** та без **_Cygwin_** все ще важко, але вже можна зліпити щось мінімально прийнятне.<!--more-->  
Отже основні моменти:
1. [Кольори](#кольори);
2. [Псевдоніми](#псевдоніми);
3. [_grep_](#grep) і таке інше з **_Cygwin_**;
4. [Prompt](#prompt).


#### Базові відомості
Для **_powershell_** аналог _.bashrc_ це такі файли:
- _$PSHOME\Profile.ps1_ - для всіх користувачів, для всіх вузлів;
- _$PSHOME\Microsoft.PowerShell_profile.ps1_ - для всіх користувачів, тільки для консолі;
- _$PsHome\Microsoft.PowerShellISE_profile.ps1_ - для всіх користувачів, тільки для **ISE**;
- _$HOME\Documents\PowerShell\Profile.ps1_ - для даного користувача, для всіх вузлів;
- _$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1_ - для даного користувача, тільки для консолі;
- _$HOME\Documents\PowerShell\Microsoft.PowerShellISE_profile.ps1_ - для даного користувача, тільки для **ISE**;


Крім того кожен новий вузол, наприклад **Visual Studio Code** буде мати свої профілі типу:
- _$PSHOME\Microsoft.VSCode_profile.ps1_
- _$HOME\Documents\PowerShell\Microsoft.VSCode_profile.ps1_


Не ускладнювати... Ні, не чули :)
Далі розглядаю виключно налаштування спільного профілю для консолі та **ISE** для конкретного користувача.  
У найпростішому випадку структура директорії _$HOME\Documents\PowerShell_ буде така:
{% highlight bash %}
C:.
│   profile.ps1
│
└───Modules
    ├───Get-ChildItemColor
    │       FileInfo.ps1
    │       Get-ChildItemColor.psd1
    │       Get-ChildItemColor.psm1
    │       Get-ChildItemColorTable.ps1
    │       MatchInfo.ps1
    │       ProcessInfo.ps1
    │       PSColorHelper.ps1
    │       ServiceController.ps1
    │
    ├───Get-ConsoleColors
    │       Get-ConsoleColors.ps1
    │       Get-ConsoleColors.psm1
    │
    └───Prompt
            Prompt.ps1
            Prompt.psm1
{% endhighlight %}
_profile.ps1_ - наш профіль, _Modules_ - директорія з додатковими модулями які ми використовуємо.

Модулі в профілі підключається так:
{% highlight powershell %}
###COLORIZE FILE TYPES
Import-Module Get-ChildItemColor
$GetChildItemColorTable.File['Directory'] = "Magenta"

###VIEW COLORS
Import-Module Get-ConsoleColors

###CUSTOM PROMPT
Import-Module Prompt
{% endhighlight %}
#### Кольори
Отже, для початку дами, а потім і блек-джек. Можна придумувати свій велосипед, а можна взяти вже готовий з [github](https://github.com/joonro/Get-ChildItemColor "Get-ChildItemColor"){:target="_blank"}.  
По даному набору скриптів маю 1 зауваження. Довелося закоментувати у файлі _Get-ChildItemColor.psm1_ секцію
{% highlight powershell %}
elseif($_ -is [System.ServiceProcess.ServiceController])
{
    ServiceController $_
    $_ = $null
}
{% endhighlight %}
бо десь на середині букви **P** валився кольоровий аплет _get-service_. **_Windows 10 Enterprise LTSC 1809_**, на інших не перевіряв.

Також використовую допоміжний модуль [Get-ConsoleColors](https://www.networkadm.in/easily-display-powershell-console-colors/ "Get-ConsoleColors"){:target="_blank"}, для візуалізації доступних кольорів.  

#### Псевдоніми
**Alias**... Вони ніби і є, але аби все було просто і логічно то це були б не **_Microsoft_**. Тому вони, за великим рахунком, існують тільки для заміни страшних конструкцій типу **Clear-Content** на старі добрі **cls** і т.п. Псевдонім типу `alias ls='ls -l'` створити не можна... Ну і нафіг би були потрібні такі аліаси, аби не один костиль. Щоб створити "складний" псевдонім, потрібно створити функцію, а потім створити псевдонім для неї. Наприклад, псевдонім **jkl** що запускає сервер **_jekyll_**   буде представляти собою наступну конструкцію:
{% highlight powershell %}
#Jekyll
Function runjkl {jekyll serve --watch --source "d:/github/nyurch.github.io" --destination "d:/github/nyurch.github.io/_site"}
Set-alias -name jkl -value runjkl
{% endhighlight %}
Аналогічно псевдонім для швидкого переходу в робочу директорію:
{% highlight powershell %}
#Work folder
Function workcd {cd e:\install}
Set-alias -name temp -value workcd
{% endhighlight %}

#### grep
Досить очевидне рішення - додати із **_Cygwin_** через псевдонім
{% highlight powershell %}
Set-alias grep c:\Cygwin64\bin\grep.exe
{% endhighlight %}
Аналогічно будь-яку іншу необхідну команду.

#### Prompt
Трохи функціоналу prompt-у. Пишемо скрипт, зберігаємо як _psm1_, кладемо в папку _Modeles_ і підключаємо в профілі.

Результатом може бути **powershell-термінал** такого виду:
[![PowerShell](/assets/media/custom-ps.png?style=blog "PowerShell")](/assets/media/custom-ps.png "PowerShell"){:target="_blank"}

Ще не **_tilda_** і навіть не **_gnome-terminal_**, але вже веселіше.

Не вистачає закладок, не вистачає гарячих клавіш(подумую ще **_AutoHotkey_**  прикрутити)...

_prompt.psm1_
{% highlight powershell %}
function Prompt {
    #Assign Windows Title Text
    $host.ui.RawUI.WindowTitle = "WELCOME BACK $env:Username!"

    #Configure current user, current folder and date outputs
    $CmdPromptCurrentFolder = Split-Path -Path $pwd -Leaf
    $CmdPromptUser = [Security.Principal.WindowsIdentity]::GetCurrent();
    $Date = Get-Date -Format 'dddd dd/MM/yyyy HH:mm'

    # Test for Admin / Elevated
    $IsAdmin = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

    #Decorate the CMD Prompt
    Write-Host ""
    Write-host ($(if ($IsAdmin) { 'Elevated ' } else { '' })) -BackgroundColor DarkRed -ForegroundColor White -NoNewline
    Write-Host " USER:$($CmdPromptUser.Name.split("\")[1]) " -BackgroundColor DarkBlue -ForegroundColor White -NoNewline
    Write-Host " $date " -ForegroundColor Yellow
    Write-Host " $pwd " -ForegroundColor Green
    return "> "
} #end prompt function
{% endhighlight %}

[PowerShell Documentation](https://docs.microsoft.com/uk-ua/powershell/ "Official product documentation for PowerShell"){:target="_blank"}.
