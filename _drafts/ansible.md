---
layout: post
title: Оптимізація рутинних операцій через Ansible.
category: [SOFTWARE]
---
![ansible logo](/assets/media/ansible.svg?style=head)  
На минулій, гори вона в пеклі, роботі все збирався систематизувати гору скриптів зліплених з batch, powershell, sysinternals suite, zenity, гівна і палок у вигляді чогось єдиноподібного. А точніше обєднати все ansibl-ом. Да все якось руки не доходили і от невелика систематизація уже зробленого і зауваження по тому як робити не треба. <!--more-->

#### Серверна частина
Отже, як каже [wikipedia](https://uk.wikipedia.org/wiki/Ansible "Ansible"){:target="_blank"}:
>Ansible — програмне забезпечення, що надає засоби для управління конфігурацією, оркестровки, централізованої установки застосунків і паралельного виконання типових завдань на групі систем.

Ну і по суті на цьому можна було б завершити. Для некосмічного масштабу задач все максимально чітко, логічно, з прекрасною документацією й, за великим рахунком, час розгортання готової до використання системи залежить від кількості задач що автоматизуються і від наявності уже готових заготовок для **playbook**-ів.

Етап перший - установка. Можливі 3 варіанти:
1. ***Windows/Cygwin*** ;
2. ***Windows/WSL*** ;
3. ***Linux*** .

Перший варіант не підходить. Да даний момент версія _**ansible**_ там **2.8.4**, не буде можливості встановити і використовувати модуль _**win_chocolatey**_, для якого треба мінімум **2.9**, да і були моменти з установкою всіх необхідних модулів пітона.
Варіанти 2-3 виглядають рівнозначно. Тому:
    {% highlight shell %}sudo apt install ansible python3 python3-apt python3-pip{% endhighlight %}

І доставляємо модуль для **chocolatey**:
    {% highlight shell %}ansible-galaxy collection install chocolatey.chocolatey{% endhighlight %}
В результаті отримуємо в директорії _/etc/ansible_ 2 файли:
    {% highlight shell %}-rw-r--r-- 1 root root 19985 Mar  5  2020 ansible.cfg
-rw-r--r-- 1 root root  1209 Feb 22 11:06 hosts{% endhighlight %}

Файл конфігурації самого _**ansible**_ та файл з групами хостів, для початку все закоментовано. У файл з групами хостів н.п. додаємо 2 категорії, для windows-pc та для linux-pc:
    {% highlight yaml %}[winpc]
10.0.0.3

[winpc:vars]
ansible_user=admin
ansible_password=adminpassword
ansible_connection=winrm
ansible_winrm_server_cert_validation=ignore

[linpc]
10.0.0.2

[linpc:vars]
ansible_connection=ssh
ansible_ssh_user=ansible
ansible_ssh_pass=password{% endhighlight %}

Тут у нас логін/пароль лежить у відкритому вигляді, можна трохи підшифруватися.
1. Створюємо файл
    {% highlight bash %}sudo ansible-vault create winpassword_vars.yml{% endhighlight %}
з наступним вмістом
    {% highlight yaml %}ansible_user: admin
ansible_password: adminpassword{% endhighlight %}
{:start="2"}
2. Плейбук виконуємо так
    {% highlight bash %}sudo ansible-playbook --ask-vault-pass -e @winpassword_vars.yml myplaybook.yml{% endhighlight %}

Для тесту пропінгуємо хости з групи winpc:
    {% highlight bash %}sudo ansible winpc -i hosts -e @winpassword_vars.yml -m win_ping --ask-vault-pass
[sudo] password for deimos: **********
Vault password: **********
10.0.0.3 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}{% endhighlight %}

З шифруванням паролів якраз трохи можна заплутатися, в офіційній документації трохи коротко, а в інтернетах графомани копіпастять мануали 10-річної давності, на форумах буває 1 адекватний на 100 відповідей проскочить - "так правильно що не працює, це застаріло ще в 1.х :D". Так що може можна якось простіше, поки обдумую.  
Коли є групи хостів незмінні і такі що часто міняються, логічніше тримати їх у різних файлах інвентаризації і ці файли також можуть бути у форматі **yaml**. Наприклад 2 типи хостів з приведеного вище файлу *hosts* можуть бути розділені на 2 yml-файли:
{% highlight yaml %}winpc:
  hosts:
    10.0.0.3
  vars:
    ansible_connection: winrm
    ansible_winrm_server_cert_validation: ignore{% endhighlight %}  
та
{% highlight yaml %}linpc:
  hosts:
    10.0.0.2
  vars:
    ansible_connection: ssh{% endhighlight %}  
Я так розумію тепер при виконанні плейбука треба явно вказувати файл інвентаризації де описані хости, інакше шукатиме в *hosts* .
В результаті мабуть ще розумно зробити для довгих команд з купою параметрів аліаси і можна використовувати.  

Цікавий модуль для візуалізації інформації про хости з інвенторі - [ansible-cmdb](https://github.com/fboender/ansible-cmdb "ansible-cmdb на github"){:target="_blank"}.  

[![ansible-cmdb](https://raw.githubusercontent.com/fboender/ansible-cmdb/master/contrib/screenshot-overview.png?style=blog "ansible-cmdb")](https://raw.githubusercontent.com/fboender/ansible-cmdb/master/contrib/screenshot-overview.png "ansible-cmdb"){:target="_blank"}  

Можна використовувати теги, для виконання певник операцій, а не всього плейбука, на прикладі шаблону *win_chocolatey_full_with_tags.yml*.  
Тоді плейбук виконується з ключем `--tags`

#### Налаштування Windows-клієнтів
Повинно бути виконано кілька умов:
1. PowerShell >=3.0;
2. .Net >=4.0;
3. Ввімкнена служба WinRM;

Дві перші умови виконуються автоматично для **Windows 10+**.  
Перевірити роботу служби:
{% highlight cmd %}WinRM enumerate winrm/config/listener{% endhighlight %}

Увімкнути службу можна 2 способами:
1. Використовуючи купку костилів з доступом до ПК де це вмикається. Послідовність із старих запасів скриптів така:
дозволити виконання *powershell*-скриптів
{% highlight batch %}@echo off
cls
color FC
net session >nul 2>&1
if %errorLevel% == 0 (powershell Set-ExecutionPolicy RemoteSigned) else (echo "Run as Administrator please...")
pause{% endhighlight %}
активувати службу
{% highlight powershell %}$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
powershell.exe -ExecutionPolicy ByPass -File $file{% endhighlight %}

Упс... Кажуть можна просто
{% highlight shell %}winrm quickconfig{% endhighlight %}
{:start="2"}
2. Через групові політики, якщо робити по нормальному:
[Інструкція](https://winitpro.ru/index.php/2012/01/31/kak-aktivirovat-windows-remote-management-s-pomoshhyu-gruppovoj-politiki/ "Інструкція"){:target="_blank"}.  
У двох словах:
- Консоль **Group Policy Management editor**, перейти у розділ *Computer Configuration/Policies/Windows Components/Windows Remote Management (WinRM)* і активувати параметри *Allow automatic configuration of listeners* та *Allow Basic Authentication*, при цьому у пункті *IPv4 filter* задаємо значення **\***
- Далі у розділі *Computer Configuration/Policies/Windows Components/Windows Remote Shell* активуємо пункт *Allow Remote Shell Access*
- І прописуємо автозапуск у розділі *Computer Configuration/Windows Settings/Security Settings/System Services*

Тепер ще й можемо віддалено запускати програми, наприклад
{% highlight shell %}winrs –r:remote-pc cmd{% endhighlight %}
запустить у нас консоль віддаленого ПК де ми зможемо працювати так ніби це наш локальний ПК.

#### Налаштування Linux-клієнтів
Для доступу по паролю:
1. Встановити sshpass
2. export ANSIBLE_HOST_KEY_CHECKING=False
3. sshd_config - дозволити аутентифікацію по паролю, вказати яким юзерам дозволено підключатися AllowUsers ansible

