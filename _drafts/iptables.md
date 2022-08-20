---
layout: post
title: Шпаргалка по iptables.
category: [LINUX]
---
![linux logo](/assets/media/firewall.webp?style=head)  
Найпростіший конфіг та шпаргалка по ***iptables***.<!--more--> Інструкція частково дублюється в коментарях скрипта.
1. Перевіряємо наявність, при необхідності встановлюємо _**iptables-persistent**_, після встановлення згенеруються 2 файла з правилами що будуть примінятися при старті системи - _/etc/iptables/rules.v4_ та _/etc/iptables/rules.v6_, для дистрибутивів що не ростуть з ***debian*** ще можливо _**iptables-services**_, щоб можна було вмикати/вимикати/перезавантажувати _**iptables.service**_
2. Зупиняємо та видаляємо з автозавантаження надбудови над ***iptables***, наприклад ***ufw*** чи ***firewalld***
{% highlight bash %}systemctl stop ufw
systemctl disable ufw{% endhighlight %}
Тепер фаєрвол повністю деактивовано.
Перевіряємо це:
{% highlight bash %}iptables -L --line-numbers -v -n{% endhighlight %}
Не повинно відображатися ніяких правил.

{:start="3"}
3. В ***debian*** та похідних від нього ***iptables*** в ядрі, для інших вмикаємо та додаємо в автозавантаження:
{% highlight bash %}systemctl enable iptables.service
systemctl start iptables.service{% endhighlight %}
{:start="4"}
4. Приклад скрипта що генерує найпростіші правила. Після виконання запису правил, скрипт попросить підтвердити правильність. Якщо це не буде зроблено(зник доступ до віддаленого серверу чи просто передумали) то через 20с відновляться попередні правила.
{% highlight shell %}
#!/bin/sh

#
#Встановлюємо якщо немає iptables-persistent
#при цьому у /etc/iptables генеруються rules.v4 та rules.v6, файли з правилами для IPv4 та IPv6
#ці правила приміняються при перезавантаженні
#якщо їх не буде загрузиться чистий iptables
#

#Задаємо змінні для спрощення скрипта
#==============================================================================
## Фаєрвол
export IPT="iptables"
export IPT_SAVE="/usr/sbin/iptables-save"
export IPT_RESTORE="/usr/sbin/iptables-restore"
export IPT_BACKUP="/etc/iptables"
export IPT_RULES="/etc/iptables"
## Інтерфейс із зовнішнім ip та сам ip
#export WAN=enp0s3
#export WAN_IP=10.0.2.15

## Локальні інтерфейс та мережа
export LAN1=enp0s3
export LAN1_IP_RANGE=10.0.2.0/24
#==============================================================================

#Бекапимо правила на випадок косяків.
#Є 2 моменти
#iptables-save може знаходитися в різних місцях у різних дистрибутивах
#(наприклад /usr/sbin/iptables-save чи /sbin/iptables-save)
#запис у /etc/iptables може бути заборонений навіть через sudo.
#працюємо під рутом sudo su
#==============================================================================
safeMode="y" # y/n
if [ "$safeMode" = "y" ] ; then
printf "\n Збереження вихідних правил ...\n"
$IPT_SAVE > $IPT_BACKUP/rules.v4.backup
fi
#==============================================================================

#Базові налаштування
#==============================================================================
## Очистка правил
$IPT -F
$IPT -F -t nat
$IPT -F -t mangle
$IPT -X
$IPT -t nat -X
$IPT -t mangle -X

## Заборонити все що не дозволено
$IPT -P INPUT DROP
$IPT -P OUTPUT DROP
$IPT -P FORWARD DROP

## Дозволити все для localhost та локальної мережі
$IPT -A INPUT -i lo -j ACCEPT
$IPT -A INPUT -i $LAN1 -j ACCEPT
$IPT -A OUTPUT -o lo -j ACCEPT
$IPT -A OUTPUT -o $LAN1 -j ACCEPT

## Дозволити ping
$IPT -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
$IPT -A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT
$IPT -A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT
$IPT -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

## Дозволити трафік з внутрішньої мережі у світ
#$IPT -A OUTPUT -o $WAN -j ACCEPT
## Розкоментувати щоб дозволити вхідні з'єднання сервера. Не рекомендовано.
# $IPT -A INPUT -i $WAN -j ACCEPT

## Дозволити встановлені та дочірні від них підключення
$IPT -A INPUT -p all -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPT -A OUTPUT -p all -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPT -A FORWARD -p all -m state --state ESTABLISHED,RELATED -j ACCEPT

## Ввімкнути франментацію пакетів, що необхідно через різні значення MTU
#$IPT -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
#==============================================================================

#Деякий захист від мамкиних хакерів
#==============================================================================
## Заборона неопізнаних пакетів
$IPT -A INPUT -m state --state INVALID -j DROP
$IPT -A FORWARD -m state --state INVALID -j DROP

## Нульових пакетів
$IPT -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

## Syn-flood
$IPT -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
$IPT -A OUTPUT -p tcp ! --syn -m state --state NEW -j DROP

## Заборона вказаних ip
#$IPT -A INPUT -s 10.0.0.2 -j REJECT
#$IPT -A OUTPUT -s 10.0.0.2 -j REJECT
#==============================================================================

#Прокинути порт зі світу в локалку
#==============================================================================
## Вхідний на порт 12345 сервера прокинути на порт 3389 машини 10.0.0.2
# $IPT -t nat -A PREROUTING -p tcp --dport 12345 -i ${WAN} -j DNAT --to 10.0.0.2:3389
# Дозволяємо вхідний трафік на цей порт. Тому що всі вхідні заборонено трохи нижче
#$IPT -A FORWARD -i $WAN -o $LAN1 -j REJECT. Дозвіл повинен бути вище по тексту за заборону.
# $IPT -A FORWARD -i $WAN -d 10.0.0.2 -p tcp -m tcp --dport 3389 -j ACCEPT
#==============================================================================

#Обмін між світом і локалкою.
#==============================================================================
## Вихідні з локалки дозволено.
#$IPT -A FORWARD -i $LAN1 -o $WAN -j ACCEPT
## Ззовні в локалку заборонено.
#$IPT -A FORWARD -i $WAN -o $LAN1 -j REJECT
#==============================================================================

#Вмикаємо NAT для доступу локалки до світу
#==============================================================================
#$IPT -t nat -A POSTROUTING -o $WAN -s $LAN1_IP_RANGE -j MASQUERADE
#==============================================================================

#Відкриваємо порти
#==============================================================================
## SSH
#$IPT -A INPUT -i $WAN -p tcp --dport 22 -j ACCEPT

## Пошта
#$IPT -A INPUT -p tcp -m tcp --dport 25 -j ACCEPT
#$IPT -A INPUT -p tcp -m tcp --dport 465 -j ACCEPT
#$IPT -A INPUT -p tcp -m tcp --dport 110 -j ACCEPT
#$IPT -A INPUT -p tcp -m tcp --dport 995 -j ACCEPT
#$IPT -A INPUT -p tcp -m tcp --dport 143 -j ACCEPT
#$IPT -A INPUT -p tcp -m tcp --dport 993 -j ACCEPT

## web-сервер
#$IPT -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
#$IPT -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT

## DNS-сервер
#$IPT -A INPUT -i $WAN -p udp --dport 53 -j ACCEPT
#==============================================================================

#Ввімкнути логи
#==============================================================================
#Встановлюємо rsyslog якщо немає
#створюємо конфігі для rsyslog
#sudo touch /etc/rsyslog.d/10-iptables_in.conf
#у файлах конфігурації додаємо 2 рядки
#
#:msg, contains, "iptables block_in: " -/var/log/iptables_in.log
#& ~
#
$IPT -N block_in
$IPT -N block_out
$IPT -N block_fw

$IPT -A INPUT -j block_in
$IPT -A OUTPUT -j block_out
$IPT -A FORWARD -j block_fw

$IPT -A block_in -j LOG --log-level info --log-prefix "iptables block_in: "
$IPT -A block_in -j DROP
$IPT -A block_out -j LOG --log-level info --log-prefix "iptables block_out: "
$IPT -A block_out -j DROP
$IPT -A block_fw -j LOG --log-level info --log-prefix "iptables block_fw: "
$IPT -A block_fw -j DROP
#==============================================================================


#==============================================================================
if [ "$safeMode" != "y" ];then exit;fi
printf "\n Нові правила таблиці filter:\n"
$IPT -S
printf "\n Нові правила таблиці nat:\n"
$IPT -t nat -S
printf "\n Нові правила таблиці mangle:\n"
$IPT -t mangle -S
rc() {
old=$(stty -g)
stty raw min 0 time 200
printf '%s' $(dd bs=1 count=1 2>/dev/null)
stty $old
}
printf "\n Відновити початкові правила? (Y/n) \n 25 сек до відновлення...: "
answer=$(rc)
if [ "$answer" = "n" ] || [ "$answer" = "N" ] ; then
printf "\n Зберігаємо правила у файл /etc/iptables/rules.v4 ...\n"
$IPT_SAVE > $IPT_RULES/rules.v4
exit
fi
printf "\n Відновлюємо початкові правила ...\n"
$IPT_RESTORE < $IPT_BACKUP/rules.v4.backup

printf "\n Початкові правила таблиці filter:\n"
$IPT -S
printf "\n Початкові правила таблиці nat:\n"
$IPT -t nat -S
printf "\n Початкові правила таблиці mangle:\n"
$IPT -t mangle -S

{% endhighlight %}

{:start="5"}
5. Скрипт налаштований писати логи по пакетам що були відсіяні в 3 окремих файли: _/var/log/iptables_in.log_, _/var/log/iptables_out.log_, _/var/log/iptables_fw.log_.  Відповідно для вхідних, вихідних пакетів, та пакетів що пересилаються між 2 інтерфейсами.  
Для цього треба встановити, якщо не встановлено ***rsyslog*** та  створити 3 файли з відповідними конфігураціями:
{% highlight bash %}
touch /etc/rsyslog.d/10-iptables_in.conf
touch /etc/rsyslog.d/11-iptables_out.conf
touch /etc/rsyslog.d/12-iptables_fw.conf
{% endhighlight %}
Вміст файлів конфігурації наступний:
{% highlight bash %}
:msg, contains, "iptables block_in: " -/var/log/iptables_in.log
& ~
{% endhighlight %}
Тепер логи заблокованого пишуться в окремі файли, за замовчуванням в ***debian*** все пишеться у _/var/log/kernel.log_

{:start="6"}
6. Якщо треба пересилати пакети між інтерфейсами це повинно бути дозволено. Треба поставити **1** замість **0** у _/proc/sys/net/ipv4/ip_forward_
