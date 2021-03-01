---
layout: post
title: Zabbix.
category: [SOFTWARE]
---
![ansible logo](/assets/media/ansible.svg?style=head)  
Zabbix. <!--more-->

Отже, як каже [wikipedia](https://uk.wikipedia.org/wiki/Ansible "Ansible"){:target="_blank"}:
>Ansible — програмне забезпечення, що надає засоби для управління конфігурацією, оркестровки, централізованої установки застосунків і паралельного виконання типових завдань на групі систем.

CentOS
mysql-сервер
{% highlight shell %}dnf install https://repo.percona.com/yum/percona-release-latest.noarch.rpm
dnf module disable mysql
percona-release setup ps80
dnf install percona-server-server percona-toolkit percona-xtrabackup-80
systemctl enable --now mysqld{% endhighlight %}

тимчасовий пароль дивимось тут grep "temporary password" /var/log/mysqld.log

запускаємо інсталяцію mysql_secure_installation

zabbix
{% highlight shell %}rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-1.el8.noarch.rpm
dnf install zabbix-server-mysql zabbix-web-mysql zabbix-nginx-conf zabbix-agent{% endhighlight %}

mysql-база для zabbix
{% highlight shell %}mysql -uroot -p
mysql> create database zabbix character set utf8 collate utf8_bin;
mysql> create user 'zabbix'@'localhost' identified with mysql_native_password by '1qaz@WSX';
mysql> grant all privileges on zabbix.* to zabbix@localhost;
mysql> exit
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix{% endhighlight %}

при підключених репах забікса і персони обновляємось так dnf update --nobest бо буде конфлікт

/etc/zabbix/zabbix_server.conf
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=1qaz@WSX
Timeout=20

запускаємо
systemctl enable --now zabbix-server

при ввімкненому SELinux буде помилка, відключаємо
mcedit /etc/sysconfig/selinux
тут SELINUX=disabled
перезамускаємо
setenforce 0


/etc/nginx/conf.d/zabbix.conf
listen 80 default_server;
server_name example.com;

/etc/nginx/nginx.conf
listen 80;
listen [::]:80;

якщо default_server буде в конфі нжинкса, а не забікса не буде доступу по ір

/etc/php-fpm.d/zabbix.conf
php_value[date.timezone] = Europe/Kiev

systemctl enable --now nginx php-fpm

помилка?
# systemctl stop firewalld
# systemctl disable firewalld
або
# firewall-cmd --permanent --add-port=80/tcp --add-port=443/tcp --add-port=10051/tcp
# firewall-cmd --reload

Ubuntu, Debian
# wget https://repo.zabbix.com/zabbix/5.0/debian/pool/main/z/zabbix-release/zabbix-release_5.0-1+buster_all.deb
# dpkg -i zabbix-release_5.0-1+buster_all.deb
# apt update

# apt install mariadb-server zabbix-server-mysql zabbix-frontend-php zabbix-nginx-conf zabbix-agent

mysql_secure_installation

mysql -uroot -p
Enter password:
> create database zabbix character set utf8 collate utf8_bin;
> grant all privileges on zabbix.* to zabbix@localhost identified by '1qaz@WSX';
> exit

 zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix

 і далі те саме
 потім
 # systemctl restart nginx php7.3-fpm
# systemctl enable nginx php7.3-fpm

фаєрвол
# systemctl stop iptables
# systemctl disable iptables
# ufw disable

Фронтенд

    login Admin
    password zabbix

    https://serveradmin.ru/ustanovka-i-nastrojka-zabbix-5-0/












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

Далі про налаштування клієнтів....
