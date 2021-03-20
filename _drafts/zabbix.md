---
layout: post
title: Zabbix. Новомодна система моніторингу.
category: [SOFTWARE]
---
![ansible logo](/assets/media/zabbix.png?style=head)  
***Zabbix*** . Що за звір, чому останнім часом куди не плюнь використовують його, а не класику у вигляді ***nagios*** , надумав на практиці спробувати і подивитися **+** і **-**.<!--more-->

Отже, як каже [wikipedia](https://uk.wikipedia.org/wiki/Zabbix "Zabbix"){:target="_blank"}:
>Zabbix — вільна система моніторингу служб і станів комп'ютерної мережі. Zabbix складається з трьох базових компонентів: сервера для координації виконання перевірок, формування перевірочних запитів та накопичення статистики, агентів для здійснення перевірок на стороні зовнішніх хостів та фронтенда для організації управління системою.

Для роботи системи треба:
1. База банних;
2. PHP;
3. Web-сервер;
4. Zabbix-сервер;
5. Zabbix-агент на всьому що буде моніторитися, хоча деякий примітив типу доступність порту чи пінг може моніторити без агента.

Уже викликає деякі підозри, тому що для **nagios** не потрібно нічого крім самого сервера та web-сервера, а БД і РНР я не люблю.

#### Встановлення на CentOS
**ПОПЕРЕДНІ НАЛАШТУВАННЯ ТА ЗАУВАЖЕННЯ**  
Відключаємо фаєрвол чи дозволяємо що треба:
{% highlight shell %}systemctl stop firewalld && systemctl disable firewalld{% endhighlight %}
або
{% highlight shell %}firewall-cmd --permanent --add-port=80/tcp --add-port=443/tcp --add-port=10051/tcp
firewall-cmd --reload{% endhighlight %}

При підключених репозиторіях забікса і персони обновляємось так `dnf update --nobest` бо буде конфлікт версій.  

При використанні **SELinux** буде помилка при спробі запустити **Zabbix**, відключаємо, або шукаємо як налаштувати запуск з включеним:
У файлі _/etc/sysconfig/selinux_ параметр має виглядати так ***SELINUX=disabled***  
Переходимо у дозволяючий режим **SELinux**:
{% highlight shell %}setenforce 0{% endhighlight %}

**ZABBIX**  
Встановлюємо:
{% highlight shell %}rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-1.el8.noarch.rpm
dnf install zabbix-server-mysql zabbix-web-mysql zabbix-nginx-conf zabbix-agent{% endhighlight %}

Файл конфігурації _/etc/zabbix/zabbix_server.conf_ :
{% highlight ini %}DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=password
Timeout=20{% endhighlight %}

**MYSQL**  
Установка mysql-сервера, автор базового мануалу любить **percona**, ну і чорт з ним, не бачу різниці:
{% highlight shell %}dnf install https://repo.percona.com/yum/percona-release-latest.noarch.rpm
dnf module disable mysql
percona-release setup ps80
dnf install percona-server-server percona-toolkit percona-xtrabackup-80
systemctl enable --now mysqld{% endhighlight %}

В процесі автоматично генерується тимчасовий пароль адміністратора, дивимось його тут
{% highlight shell %}grep "temporary password" /var/log/mysqld.log{% endhighlight %}

Запускаємо інсталяцію:
{% highlight shell %}mysql_secure_installation{% endhighlight %}

Створюємо mysql-базу для Zabbix:
{% highlight shell %}mysql -uroot -p
mysql> create database zabbix character set utf8 collate utf8_bin;
mysql> create user 'zabbix'@'localhost' identified with mysql_native_password by 'password';
mysql> grant all privileges on zabbix.* to zabbix@localhost;
mysql> exit
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix{% endhighlight %}

**NGINX**  
Файли конфігурації:  
_/etc/nginx/conf.d/zabbix.conf_
{% highlight ini %}listen 80 default_server;
server_name example.com;{% endhighlight %}

_/etc/nginx/nginx.conf_
{% highlight ini %}listen 80;
listen [::]:80;{% endhighlight %}

Якщо **default_server** буде в конфі нжинкса, а не забікса то не буде доступу по **ір**.

**PHP**  
_/etc/php-fpm.d/zabbix.conf_
{% highlight php %}php_value[date.timezone] = Europe/Kiev{% endhighlight %}


Запускаємо:
{% highlight shell %}systemctl enable --now zabbix-server
systemctl enable --now nginx php-fpm{% endhighlight %}


#### Встановлення на Ubuntu/Debian
**ПОПЕРЕДНІ НАЛАШТУВАННЯ ТА ЗАУВАЖЕННЯ**  
Відключаємо фаєрвол:
{% highlight shell %}systemctl stop iptables
systemctl disable iptables
systemctl stop ufw
systemctl disable ufw
ufw disable{% endhighlight %}

*SELinux*:
У файлі _/etc/sysconfig/selinux_ параметр має виглядати так ***SELINUX=disabled***  
Перезапускаємо:
{% highlight shell %}setenforce 0{% endhighlight %}

**ZABBIX**  
Встановлюємо:
{% highlight shell %}wget https://repo.zabbix.com/zabbix/5.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.2-1+ubuntu20.04_all.deb
dpkg -i zabbix-release_5.2-1+ubuntu20.04_all.deb
apt update
apt install nginx php-fpm php-mysql mariadb-server zabbix-server-mysql zabbix-frontend-php zabbix-nginx-conf zabbix-agent{% endhighlight %}

Файл конфігурації _/etc/zabbix/zabbix_server.conf_ :
{% highlight ini %}DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=password
Timeout=20{% endhighlight %}

**MYSQL**  
Установка:
{% highlight shell %}apt install mariadb-server{% endhighlight %}

{% highlight shell %}mysql_secure_installation{% endhighlight %}

{% highlight shell %}mysql -uroot -p
Enter password:
mysql> create database zabbix character set utf8 collate utf8_bin;
mysql> grant all privileges on zabbix.* to zabbix@localhost identified by 'password';
mysql> exit

zcat /usr/share/doc/zabbix-sql-scripts/mysql/create.sql.gz | mysql -uzabbix -p zabbix
{% endhighlight %}

**NGINX**  
Файли конфігурації:  
_/etc/nginx/conf.d/zabbix.conf_
{% highlight ini %}listen 80 default_server;
server_name example.com;{% endhighlight %}

_/etc/nginx/nginx.conf_
{% highlight ini %}listen 80;
listen [::]:80;{% endhighlight %}

Запускаємо:
{% highlight shell %}systemctl enable zabbix-server
systemctl restart nginx php7.4-fmp
systemctl enable nginx php7.4-fmp{% endhighlight %}

Базова інструкція для **deb**-систем була малодостовірна, прийшлося поскакати з бубном, так що може в результаті що упустив і в своїй. Для **CentOS** все точно.

#### Фронтенд  
login: Admin  
password: zabbix

#### Висновки
Потребує установки БД, потребує установки клієнту на кожен ПК що хочемо моніторити. Але установка елементарна, один раз трохи проходимося по граблям, щоб зрозуміти що й до чого, потім робимо плейбук для ансібла й валяємо дурака. А можна навіть скачати вже готові плейбуки.  

Щось моніторити не пробував, відклав у довгий ящик.
