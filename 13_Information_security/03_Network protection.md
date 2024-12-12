# Домашнее задание к занятию «Защита сети» - `Арзыбов Владислав`


------

### Подготовка к выполнению заданий

1. Подготовка защищаемой системы:

- установите **Suricata**,
- установите **Fail2Ban**.

2. Подготовка системы злоумышленника: установите **nmap** и **thc-hydra** либо скачайте и установите **Kali linux**.

Обе системы должны находится в одной подсети.

------

### Задание 1

Проведите разведку системы и определите, какие сетевые службы запущены на защищаемой системе:

**sudo nmap -sA < ip-адрес >**

![изображение](https://github.com/user-attachments/assets/cb1a5244-5a48-4a79-8ab7-71899600d7a3)


**sudo nmap -sT < ip-адрес >**

![изображение](https://github.com/user-attachments/assets/2a9cb7d4-1226-4941-b864-b2f911510c3e)

В логе: /var/log/suricata/fast.log

```bash
12/12/2024-14:26:55.428644  [**] [1:2010936:3] ET SCAN Suspicious inbound to Oracle SQL port 1521 [**] [Classification: Potentially Bad Traffic] [Priority: 2] {TCP} 10.0.2.15:52588 -> 10.0.2.5:1521
12/12/2024-14:26:55.406964  [**] [1:2010937:3] ET SCAN Suspicious inbound to mySQL port 3306 [**] [Classification: Potentially Bad Traffic] [Priority: 2] {TCP} 10.0.2.15:33298 -> 10.0.2.5:3306
12/12/2024-14:26:55.472675  [**] [1:2010935:3] ET SCAN Suspicious inbound to MSSQL port 1433 [**] [Classification: Potentially Bad Traffic] [Priority: 2] {TCP} 10.0.2.15:43818 -> 10.0.2.5:1433
12/12/2024-14:26:55.476922  [**] [1:2010939:3] ET SCAN Suspicious inbound to PostgreSQL port 5432 [**] [Classification: Potentially Bad Traffic] [Priority: 2] {TCP} 10.0.2.15:38858 -> 10.0.2.5:5432
```

**sudo nmap -sS < ip-адрес >**

![изображение](https://github.com/user-attachments/assets/b7ccc083-e82f-4104-8767-32ba8c3b7505)

В логе: /var/log/suricata/fast.log

```bash
12/12/2024-14:29:40.177859  [**] [1:2010937:3] ET SCAN Suspicious inbound to mySQL port 3306 [**] [Classification: Potentially Bad Traffic] [Priority: 2] {TCP} 10.0.2.15:61631 -> 10.0.2.5:3306
12/12/2024-14:29:40.200746  [**] [1:2002910:6] ET SCAN Potential VNC Scan 5800-5820 [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 10.0.2.15:61631 -> 10.0.2.5:5801
12/12/2024-14:29:40.199457  [**] [1:2010935:3] ET SCAN Suspicious inbound to MSSQL port 1433 [**] [Classification: Potentially Bad Traffic] [Priority: 2] {TCP} 10.0.2.15:61631 -> 10.0.2.5:1433
12/12/2024-14:29:40.203186  [**] [1:2010936:3] ET SCAN Suspicious inbound to Oracle SQL port 1521 [**] [Classification: Potentially Bad Traffic] [Priority: 2] {TCP} 10.0.2.15:61631 -> 10.0.2.5:1521
12/12/2024-14:29:40.212157  [**] [1:2010939:3] ET SCAN Suspicious inbound to PostgreSQL port 5432 [**] [Classification: Potentially Bad Traffic] [Priority: 2] {TCP} 10.0.2.15:61631 -> 10.0.2.5:5432
```


**sudo nmap -sV < ip-адрес >**

![изображение](https://github.com/user-attachments/assets/732e8b73-1d7f-473f-9919-e01670adf8cf)

В логе: /var/log/suricata/fast.log

```bash
12/12/2024-14:32:13.525517  [**] [1:2010937:3] ET SCAN Suspicious inbound to mySQL port 3306 [**] [Classification: Potentially Bad Traffic] [Priority: 2] {TCP} 10.0.2.15:51967 -> 10.0.2.5:3306
12/12/2024-14:32:13.527984  [**] [1:2010936:3] ET SCAN Suspicious inbound to Oracle SQL port 1521 [**] [Classification: Potentially Bad Traffic] [Priority: 2] {TCP} 10.0.2.15:51967 -> 10.0.2.5:1521
12/12/2024-14:32:13.526320  [**] [1:2010939:3] ET SCAN Suspicious inbound to PostgreSQL port 5432 [**] [Classification: Potentially Bad Traffic] [Priority: 2] {TCP} 10.0.2.15:51967 -> 10.0.2.5:5432
12/12/2024-14:32:13.543650  [**] [1:2010935:3] ET SCAN Suspicious inbound to MSSQL port 1433 [**] [Classification: Potentially Bad Traffic] [Priority: 2] {TCP} 10.0.2.15:51967 -> 10.0.2.5:1433
12/12/2024-14:32:13.564043  [**] [1:2002910:6] ET SCAN Potential VNC Scan 5800-5820 [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 10.0.2.15:51967 -> 10.0.2.5:5801
12/12/2024-14:32:19.740381  [**] [1:2009358:6] ET SCAN Nmap Scripting Engine User-Agent Detected (Nmap Scripting Engine) [**] [Classification: Web Application Attack] [Priority: 1] {TCP} 10.0.2.15:51560 -> 10.0.2.5:80
12/12/2024-14:32:19.740381  [**] [1:2024364:4] ET SCAN Possible Nmap User-Agent Observed [**] [Classification: Web Application Attack] [Priority: 1] {TCP} 10.0.2.15:51560 -> 10.0.2.5:80
12/12/2024-14:32:19.740669  [**] [1:2009358:6] ET SCAN Nmap Scripting Engine User-Agent Detected (Nmap Scripting Engine) [**] [Classification: Web Application Attack] [Priority: 1] {TCP} 10.0.2.15:51572 -> 10.0.2.5:80
12/12/2024-14:32:19.740669  [**] [1:2024364:4] ET SCAN Possible Nmap User-Agent Observed [**] [Classification: Web Application Attack] [Priority: 1] {TCP} 10.0.2.15:51572 -> 10.0.2.5:80
12/12/2024-14:32:19.737316  [**] [1:2009358:6] ET SCAN Nmap Scripting Engine User-Agent Detected (Nmap Scripting Engine) [**] [Classification: Web Application Attack] [Priority: 1] {TCP} 10.0.2.15:51532 -> 10.0.2.5:80
12/12/2024-14:32:19.737316  [**] [1:2024364:4] ET SCAN Possible Nmap User-Agent Observed [**] [Classification: Web Application Attack] [Priority: 1] {TCP} 10.0.2.15:51532 -> 10.0.2.5:80
12/12/2024-14:32:19.738547  [**] [1:2009358:6] ET SCAN Nmap Scripting Engine User-Agent Detected (Nmap Scripting Engine) [**] [Classification: Web Application Attack] [Priority: 1] {TCP} 10.0.2.15:51558 -> 10.0.2.5:80
12/12/2024-14:32:19.738547  [**] [1:2024364:4] ET SCAN Possible Nmap User-Agent Observed [**] [Classification: Web Application Attack] [Priority: 1] {TCP} 10.0.2.15:51558 -> 10.0.2.5:80
```

В логе: /var/log/auth.log

```bash
Dec 12 14:32:13 client2 sshd[19142]: error: kex_exchange_identification: Connection closed by remote host
Dec 12 14:32:13 client2 sshd[19142]: Connection closed by 10.0.2.15 port 38422
```


По желанию можете поэкспериментировать с опциями: https://nmap.org/man/ru/man-briefoptions.html.
*В качестве ответа пришлите события, которые попали в логи Suricata и Fail2Ban, прокомментируйте результат.*



------

### Задание 2

Проведите атаку на подбор пароля для службы SSH:

**hydra -L users.txt -P pass.txt < ip-адрес > ssh**

1. Настройка **hydra**: 
 
 - создайте два файла: **users.txt** и **pass.txt**;
 - в каждой строчке первого файла должны быть имена пользователей, второго — пароли. В нашем случае это могут быть случайные строки, но ради эксперимента можете добавить имя и пароль существующего пользователя.

Дополнительная информация по **hydra**: https://kali.tools/?p=1847.

2. Включение защиты SSH для Fail2Ban:

-  открыть файл /etc/fail2ban/jail.conf,
-  найти секцию **ssh**,
-  установить **enabled**  в **true**.

Дополнительная информация по **Fail2Ban**:https://putty.org.ru/articles/fail2ban-ssh.html.



*В качестве ответа пришлите события, которые попали в логи Suricata и Fail2Ban, прокомментируйте результат.*
