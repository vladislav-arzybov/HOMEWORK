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

В логах записи отсутствуют.
Опция -sA используется для определения, находится ли порт за брандмауэром, ACK-пакеты проверяют, как система реагирует на запросы фильтрации пакетов.


**sudo nmap -sT < ip-адрес >**

![изображение](https://github.com/user-attachments/assets/2a9cb7d4-1226-4941-b864-b2f911510c3e)

В логе: /var/log/suricata/fast.log

```bash
12/12/2024-14:26:55.428644  [**] [1:2010936:3] ET SCAN Suspicious inbound to Oracle SQL port 1521 [**] [Classification: Potentially Bad Traffic] [Priority: 2] {TCP} 10.0.2.15:52588 -> 10.0.2.5:1521
12/12/2024-14:26:55.406964  [**] [1:2010937:3] ET SCAN Suspicious inbound to mySQL port 3306 [**] [Classification: Potentially Bad Traffic] [Priority: 2] {TCP} 10.0.2.15:33298 -> 10.0.2.5:3306
12/12/2024-14:26:55.472675  [**] [1:2010935:3] ET SCAN Suspicious inbound to MSSQL port 1433 [**] [Classification: Potentially Bad Traffic] [Priority: 2] {TCP} 10.0.2.15:43818 -> 10.0.2.5:1433
12/12/2024-14:26:55.476922  [**] [1:2010939:3] ET SCAN Suspicious inbound to PostgreSQL port 5432 [**] [Classification: Potentially Bad Traffic] [Priority: 2] {TCP} 10.0.2.15:38858 -> 10.0.2.5:5432
```

опция -sT выполняет сканирование TCP-портов. В логе зафиксирована попытка скинирования портов и указан ip адрес атакующей машины.

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

Опция -sS запускает метод сканирования с помощью протокола TCP SYN, но полноценное TCP-соединение с портом сканируемой машины не устанавливается. В логе помимо фиксации событий скинирования портов с конкретного адреса атакующей машины мы также видим попытку подключения к удаленному рабочему столу жертвы.


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

Опция -sV — в отличии от остальных дополнительно указывает подробную информацию о службе, которая запущена на определённом порту. В логе suricata помимо записей о сканировании порта и адреса атакующей машины зафиксирована информация об обнаружении сканирования с помощью инструмента Nmap.

В логе: /var/log/auth.log

```bash
Dec 12 14:32:13 client2 sshd[19142]: error: kex_exchange_identification: Connection closed by remote host
Dec 12 14:32:13 client2 sshd[19142]: Connection closed by 10.0.2.15 port 38422
```
Зафиксирована попытка подключения по порту 38422 использующегося для сервиса Xn Control Plane.


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

![изображение](https://github.com/user-attachments/assets/9baff91e-5ee4-4a85-bbd1-5ace6fe8d506)

2. Включение защиты SSH для Fail2Ban:

-  открыть файл /etc/fail2ban/jail.conf,
-  найти секцию **ssh**,
-  установить **enabled**  в **true**.

Дополнительная информация по **Fail2Ban**:https://putty.org.ru/articles/fail2ban-ssh.html.

![изображение](https://github.com/user-attachments/assets/4b725add-1f79-4583-a021-461fcc8595a8)

*В качестве ответа пришлите события, которые попали в логи Suricata и Fail2Ban, прокомментируйте результат.*

![изображение](https://github.com/user-attachments/assets/3f14dad5-d2c5-4218-8f69-a09b70301962)

Работа программы hydra закончена, но подходящих паролей не обнаружено.

В логе: /var/log/suricata/fast.log

```bash
12/12/2024-16:00:32.423292  [**] [1:2001219:20] ET SCAN Potential SSH Scan [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 10.0.2.15:32908 -> 10.0.2.5:22
12/12/2024-16:00:32.423292  [**] [1:2003068:7] ET SCAN Potential SSH Scan OUTBOUND [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 10.0.2.15:32908 -> 10.0.2.5:22
12/12/2024-16:00:32.424196  [**] [1:2001219:20] ET SCAN Potential SSH Scan [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 10.0.2.15:32940 -> 10.0.2.5:22
12/12/2024-16:00:32.424196  [**] [1:2003068:7] ET SCAN Potential SSH Scan OUTBOUND [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 10.0.2.15:32940 -> 10.0.2.5:22
12/12/2024-16:00:32.425887  [**] [1:2003068:7] ET SCAN Potential SSH Scan OUTBOUND [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 10.0.2.15:33014 -> 10.0.2.5:22
12/12/2024-16:00:32.480228  [**] [1:2260002:1] SURICATA Applayer Detect protocol only one direction [**] [Classification: Generic Protocol Command Decode] [Priority: 3] {TCP} 10.0.2.5:22 -> 10.0.2.15:32968
12/12/2024-16:00:32.480680  [**] [1:2260002:1] SURICATA Applayer Detect protocol only one direction [**] [Classification: Generic Protocol Command Decode] [Priority: 3] {TCP} 10.0.2.5:22 -> 10.0.2.15:32992
12/12/2024-16:00:32.480458  [**] [1:2260002:1] SURICATA Applayer Detect protocol only one direction [**] [Classification: Generic Protocol Command Decode] [Priority: 3] {TCP} 10.0.2.5:22 -> 10.0.2.15:32982
12/12/2024-16:00:34.786621  [**] [1:2003068:7] ET SCAN Potential SSH Scan OUTBOUND [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 10.0.2.15:45868 -> 10.0.2.5:22
12/12/2024-16:00:35.233915  [**] [1:2003068:7] ET SCAN Potential SSH Scan OUTBOUND [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 10.0.2.15:45914 -> 10.0.2.5:22
12/12/2024-16:00:35.369985  [**] [1:2003068:7] ET SCAN Potential SSH Scan OUTBOUND [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 10.0.2.15:45924 -> 10.0.2.5:22
12/12/2024-16:00:35.939259  [**] [1:2003068:7] ET SCAN Potential SSH Scan OUTBOUND [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 10.0.2.15:45904 -> 10.0.2.5:22
12/12/2024-16:00:36.407399  [**] [1:2210054:1] SURICATA STREAM excessive retransmissions [**] [Classification: Generic Protocol Command Decode] [Priority: 3] {TCP} 10.0.2.15:32906 -> 10.0.2.5:22
12/12/2024-16:00:36.408373  [**] [1:2210054:1] SURICATA STREAM excessive retransmissions [**] [Classification: Generic Protocol Command Decode] [Priority: 3] {TCP} 10.0.2.15:32940 -> 10.0.2.5:22
12/12/2024-16:00:36.408379  [**] [1:2210054:1] SURICATA STREAM excessive retransmissions [**] [Classification: Generic Protocol Command Decode] [Priority: 3] {TCP} 10.0.2.15:32922 -> 10.0.2.5:22
12/12/2024-16:00:36.471162  [**] [1:2210054:1] SURICATA STREAM excessive retransmissions [**] [Classification: Generic Protocol Command Decode] [Priority: 3] {TCP} 10.0.2.15:32932 -> 10.0.2.5:22
12/12/2024-16:00:36.471172  [**] [1:2210054:1] SURICATA STREAM excessive retransmissions [**] [Classification: Generic Protocol Command Decode] [Priority: 3] {TCP} 10.0.2.15:32914 -> 10.0.2.5:22
12/12/2024-16:00:36.535415  [**] [1:2210054:1] SURICATA STREAM excessive retransmissions [**] [Classification: Generic Protocol Command Decode] [Priority: 3] {TCP} 10.0.2.15:32956 -> 10.0.2.5:22
12/12/2024-16:00:36.836024  [**] [1:2003068:7] ET SCAN Potential SSH Scan OUTBOUND [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 10.0.2.15:45888 -> 10.0.2.5:22
12/12/2024-16:00:36.919175  [**] [1:2210054:1] SURICATA STREAM excessive retransmissions [**] [Classification: Generic Protocol Command Decode] [Priority: 3] {TCP} 10.0.2.15:32888 -> 10.0.2.5:22
12/12/2024-16:00:37.047334  [**] [1:2210054:1] SURICATA STREAM excessive retransmissions [**] [Classification: Generic Protocol Command Decode] [Priority: 3] {TCP} 10.0.2.15:33024 -> 10.0.2.5:22
12/12/2024-16:00:37.859278  [**] [1:2003068:7] ET SCAN Potential SSH Scan OUTBOUND [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 10.0.2.15:45868 -> 10.0.2.5:22
12/12/2024-16:00:37.923513  [**] [1:2003068:7] ET SCAN Potential SSH Scan OUTBOUND [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 10.0.2.15:45892 -> 10.0.2.5:22
12/12/2024-16:00:38.711475  [**] [1:2210054:1] SURICATA STREAM excessive retransmissions [**] [Classification: Generic Protocol Command Decode] [Priority: 3] {TCP} 10.0.2.15:33040 -> 10.0.2.5:22
12/12/2024-16:00:38.711480  [**] [1:2210054:1] SURICATA STREAM excessive retransmissions [**] [Classification: Generic Protocol Command Decode] [Priority: 3] {TCP} 10.0.2.15:33054 -> 10.0.2.5:22
12/12/2024-16:00:38.883872  [**] [1:2003068:7] ET SCAN Potential SSH Scan OUTBOUND [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 10.0.2.15:45868 -> 10.0.2.5:22
12/12/2024-16:00:39.543375  [**] [1:2210054:1] SURICATA STREAM excessive retransmissions [**] [Classification: Generic Protocol Command Decode] [Priority: 3] {TCP} 10.0.2.15:32874 -> 10.0.2.5:22
12/12/2024-16:00:39.543380  [**] [1:2210054:1] SURICATA STREAM excessive retransmissions [**] [Classification: Generic Protocol Command Decode] [Priority: 3] {TCP} 10.0.2.15:32892 -> 10.0.2.5:22
12/12/2024-16:00:39.608422  [**] [1:2210054:1] SURICATA STREAM excessive retransmissions [**] [Classification: Generic Protocol Command Decode] [Priority: 3] {TCP} 10.0.2.15:32886 -> 10.0.2.5:22
12/12/2024-16:00:39.608427  [**] [1:2210054:1] SURICATA STREAM excessive retransmissions [**] [Classification: Generic Protocol Command Decode] [Priority: 3] {TCP} 10.0.2.15:32908 -> 10.0.2.5:22
12/12/2024-16:00:39.671348  [**] [1:2210054:1] SURICATA STREAM excessive retransmissions [**] [Classification: Generic Protocol Command Decode] [Priority: 3] {TCP} 10.0.2.15:33008 -> 10.0.2.5:22
12/12/2024-16:00:39.907744  [**] [1:2003068:7] ET SCAN Potential SSH Scan OUTBOUND [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 10.0.2.15:45888 -> 10.0.2.5:22
12/12/2024-16:00:40.483376  [**] [1:2003068:7] ET SCAN Potential SSH Scan OUTBOUND [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 10.0.2.15:45924 -> 10.0.2.5:22
12/12/2024-16:00:42.083200  [**] [1:2003068:7] ET SCAN Potential SSH Scan OUTBOUND [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 10.0.2.15:45904 -> 10.0.2.5:22
12/12/2024-16:00:46.435526  [**] [1:2003068:7] ET SCAN Potential SSH Scan OUTBOUND [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 10.0.2.15:45914 -> 10.0.2.5:22
12/12/2024-16:00:54.755382  [**] [1:2003068:7] ET SCAN Potential SSH Scan OUTBOUND [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 10.0.2.15:45924 -> 10.0.2.5:22
```

В логе: /var/log/auth.log

```bash
Dec 12 16:00:32 client2 sshd[21244]: Invalid user admin from 10.0.2.15 port 32866
Dec 12 16:00:32 client2 sshd[21244]: Received disconnect from 10.0.2.15 port 32866:11: Bye Bye [preauth]
Dec 12 16:00:32 client2 sshd[21244]: Disconnected from invalid user admin 10.0.2.15 port 32866 [preauth]
Dec 12 16:00:32 client2 sshd[766]: error: beginning MaxStartups throttling
Dec 12 16:00:32 client2 sshd[766]: drop connection #11 from [10.0.2.15]:32968 on [10.0.2.5]:22 past MaxStartups
Dec 12 16:00:32 client2 sshd[21248]: Invalid user reivol from 10.0.2.15 port 32888
Dec 12 16:00:32 client2 sshd[21246]: Invalid user admin from 10.0.2.15 port 32874
Dec 12 16:00:32 client2 sshd[21249]: Invalid user admin from 10.0.2.15 port 32892
Dec 12 16:00:32 client2 sshd[21246]: pam_unix(sshd:auth): check pass; user unknown
Dec 12 16:00:32 client2 sshd[21246]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=10.0.2.15 
Dec 12 16:00:32 client2 sshd[21248]: pam_unix(sshd:auth): check pass; user unknown
Dec 12 16:00:32 client2 sshd[21248]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=10.0.2.15 
Dec 12 16:00:32 client2 sshd[21247]: Invalid user admin from 10.0.2.15 port 32886
Dec 12 16:00:32 client2 sshd[21251]: Invalid user admin from 10.0.2.15 port 32908
Dec 12 16:00:32 client2 sshd[21249]: pam_unix(sshd:auth): check pass; user unknown
Dec 12 16:00:32 client2 sshd[21249]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=10.0.2.15 
Dec 12 16:00:32 client2 sshd[21253]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=10.0.2.15  user=root
Dec 12 16:00:32 client2 sshd[21250]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=10.0.2.15  user=root
Dec 12 16:00:32 client2 sshd[21256]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=10.0.2.15  user=root
Dec 12 16:00:32 client2 sshd[21251]: pam_unix(sshd:auth): check pass; user unknown
Dec 12 16:00:32 client2 sshd[21251]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=10.0.2.15 
Dec 12 16:00:32 client2 sshd[21247]: pam_unix(sshd:auth): check pass; user unknown
Dec 12 16:00:32 client2 sshd[21247]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=10.0.2.15 
Dec 12 16:00:32 client2 sshd[21252]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=10.0.2.15  user=root
Dec 12 16:00:32 client2 sshd[21258]: Invalid user super from 10.0.2.15 port 32956
Dec 12 16:00:32 client2 sshd[21261]: Invalid user super from 10.0.2.15 port 33014
Dec 12 16:00:32 client2 sshd[21255]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=10.0.2.15  user=root
Dec 12 16:00:32 client2 sshd[21264]: Invalid user reivol from 10.0.2.15 port 33024
Dec 12 16:00:32 client2 sshd[21260]: Invalid user admin from 10.0.2.15 port 33008
Dec 12 16:00:32 client2 sshd[21258]: pam_unix(sshd:auth): check pass; user unknown
Dec 12 16:00:32 client2 sshd[21265]: Invalid user reivol from 10.0.2.15 port 33040
Dec 12 16:00:32 client2 sshd[21258]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=10.0.2.15 
Dec 12 16:00:32 client2 sshd[21261]: pam_unix(sshd:auth): check pass; user unknown
Dec 12 16:00:32 client2 sshd[21261]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=10.0.2.15 
Dec 12 16:00:32 client2 sshd[21264]: pam_unix(sshd:auth): check pass; user unknown
Dec 12 16:00:32 client2 sshd[21264]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=10.0.2.15 
Dec 12 16:00:32 client2 sshd[21260]: pam_unix(sshd:auth): check pass; user unknown
Dec 12 16:00:32 client2 sshd[21260]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=10.0.2.15 
Dec 12 16:00:32 client2 sshd[21265]: pam_unix(sshd:auth): check pass; user unknown
Dec 12 16:00:32 client2 sshd[21265]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=10.0.2.15 
Dec 12 16:00:32 client2 sshd[21266]: Invalid user reivol from 10.0.2.15 port 33054
Dec 12 16:00:32 client2 sshd[21266]: pam_unix(sshd:auth): check pass; user unknown
Dec 12 16:00:32 client2 sshd[21266]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=10.0.2.15 
Dec 12 16:00:34 client2 sshd[21246]: Failed password for invalid user admin from 10.0.2.15 port 32874 ssh2
Dec 12 16:00:34 client2 sshd[21248]: Failed password for invalid user reivol from 10.0.2.15 port 32888 ssh2
Dec 12 16:00:34 client2 sshd[21249]: Failed password for invalid user admin from 10.0.2.15 port 32892 ssh2
Dec 12 16:00:34 client2 sshd[21253]: Failed password for root from 10.0.2.15 port 32922 ssh2
Dec 12 16:00:34 client2 sshd[21250]: Failed password for root from 10.0.2.15 port 32906 ssh2
Dec 12 16:00:34 client2 sshd[21256]: Failed password for root from 10.0.2.15 port 32940 ssh2
Dec 12 16:00:34 client2 sshd[21251]: Failed password for invalid user admin from 10.0.2.15 port 32908 ssh2
Dec 12 16:00:34 client2 sshd[21247]: Failed password for invalid user admin from 10.0.2.15 port 32886 ssh2
Dec 12 16:00:34 client2 sshd[21252]: Failed password for root from 10.0.2.15 port 32914 ssh2
Dec 12 16:00:34 client2 sshd[21255]: Failed password for root from 10.0.2.15 port 32932 ssh2
Dec 12 16:00:34 client2 sshd[21258]: Failed password for invalid user super from 10.0.2.15 port 32956 ssh2
Dec 12 16:00:34 client2 sshd[21261]: Failed password for invalid user super from 10.0.2.15 port 33014 ssh2
Dec 12 16:00:34 client2 sshd[21264]: Failed password for invalid user reivol from 10.0.2.15 port 33024 ssh2
Dec 12 16:00:34 client2 sshd[21260]: Failed password for invalid user admin from 10.0.2.15 port 33008 ssh2
Dec 12 16:00:34 client2 sshd[21265]: Failed password for invalid user reivol from 10.0.2.15 port 33040 ssh2
Dec 12 16:00:34 client2 sshd[21266]: Failed password for invalid user reivol from 10.0.2.15 port 33054 ssh2
```

В логе: /var/log/fail2ban.log

```bash
2024-12-12 16:00:32,396 fail2ban.filter         [20073]: INFO    [ssh] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,397 fail2ban.filter         [20073]: INFO    [sshd] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,550 fail2ban.filter         [20073]: INFO    [ssh] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,551 fail2ban.filter         [20073]: INFO    [ssh] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,570 fail2ban.filter         [20073]: INFO    [sshd] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,570 fail2ban.filter         [20073]: INFO    [sshd] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,571 fail2ban.filter         [20073]: INFO    [sshd] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,578 fail2ban.filter         [20073]: INFO    [ssh] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,603 fail2ban.filter         [20073]: INFO    [sshd] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,604 fail2ban.filter         [20073]: INFO    [sshd] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,619 fail2ban.filter         [20073]: INFO    [ssh] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,620 fail2ban.filter         [20073]: INFO    [ssh] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,676 fail2ban.filter         [20073]: INFO    [ssh] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,680 fail2ban.filter         [20073]: INFO    [sshd] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,684 fail2ban.filter         [20073]: INFO    [sshd] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,682 fail2ban.filter         [20073]: INFO    [ssh] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,687 fail2ban.filter         [20073]: INFO    [ssh] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,690 fail2ban.filter         [20073]: INFO    [ssh] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,688 fail2ban.filter         [20073]: INFO    [sshd] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,694 fail2ban.filter         [20073]: INFO    [sshd] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,702 fail2ban.filter         [20073]: INFO    [sshd] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,703 fail2ban.filter         [20073]: INFO    [ssh] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,717 fail2ban.filter         [20073]: INFO    [ssh] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:32,717 fail2ban.filter         [20073]: INFO    [sshd] Found 10.0.2.15 - 2024-12-12 16:00:32
2024-12-12 16:00:33,048 fail2ban.actions        [20073]: NOTICE  [sshd] Ban 10.0.2.15
2024-12-12 16:00:33,048 fail2ban.actions        [20073]: NOTICE  [ssh] Ban 10.0.2.15
```
В логах зафиксированы попытки подключиться к серверу по ssh, а также ошибки ввода пароля и блокировки адреса машины злоумышленника.

![изображение](https://github.com/user-attachments/assets/ae9ea0bb-8eb5-4f46-8db5-d6232818f070)

При повторном запуске приложения появляется ошибка свидетельствующая о блокировке данного хоста.
