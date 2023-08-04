---
layout: post
title: Outlook 2016+ - The messaging interface returned an unknown error.
category: [WINDOWS]
---
![webcam logo](/assets/media/outlook.svg?style=head)  
**Outlook 2016+** відмовляється відправляти шифровану пошту і видає таку помилку. Якийсь час проблема вирішувалася видаленням останнього оновлення для **Outlook**.<!--more-->
 Також проблема гарантовано вирішується видаленням гілки реєстру _**HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Cryptography\Providers\AMD Provider**_  
 Опціонально може знадобитися видалити _**HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\Default\00000002\SHA224**_.  
Працює після перезавантаження.  
Детальніше [тут](https://answers.microsoft.com/en-us/outlook_com/forum/all/outlook-20192016-trying-to-send-a-smime-signed/de792f65-2e6a-43a1-ac43-10673de75fca?page=2 "Answers MS"){:target="_blank"}. Той рідкий випадок коли на answers.microsoft.com можна прочитати щось толкове.
