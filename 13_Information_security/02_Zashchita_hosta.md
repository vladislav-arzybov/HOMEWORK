# Домашнее задание к занятию  «Защита хоста» - `Арзыбов Владислав`


------

### Задание 1

1. Установите **eCryptfs**.

![изображение](https://github.com/user-attachments/assets/207d62bd-a153-442b-ab42-80a5c0cbca8e)
   
3. Добавьте пользователя cryptouser.

![изображение](https://github.com/user-attachments/assets/009c6862-16c3-403c-a529-b35f600c1f70)

5. Зашифруйте домашний каталог пользователя с помощью eCryptfs.

*В качестве ответа  пришлите снимки экрана домашнего каталога пользователя с исходными и зашифрованными данными.*  

![изображение](https://github.com/user-attachments/assets/d875e4e1-6115-490b-9ece-a6fe297ce749)

![изображение](https://github.com/user-attachments/assets/05074789-213a-4ee2-9645-ed18b84a368b)



### Задание 2

1. Установите поддержку **LUKS**.

![изображение](https://github.com/user-attachments/assets/b2f1a859-23fd-45c2-bce5-eff346dbb86b)

3. Создайте небольшой раздел, например, 100 Мб.

![изображение](https://github.com/user-attachments/assets/f9100820-0334-4e74-8d15-fe53e9fcdbc7)
   
5. Зашифруйте созданный раздел с помощью LUKS.

*В качестве ответа пришлите снимки экрана с поэтапным выполнением задания.*

![изображение](https://github.com/user-attachments/assets/6f8c04fa-c7a6-467a-86a8-ad39d9a94c49)

Откроем только что созданный раздел с помощью модуля dm-crypt в /dev/mapper

![изображение](https://github.com/user-attachments/assets/3cee3657-2cba-4ccf-8227-0de788599e21)

Также можно посмотреть статус раздела

![изображение](https://github.com/user-attachments/assets/9d2097fc-9db5-4d67-917c-d57188d2fa6d)

Выполним форматирование раздела предварительно затерев все данные нулями 

![изображение](https://github.com/user-attachments/assets/c387729b-4492-4ed3-8bac-7379ab92021e)

Создаем новый каталог и монтируем туда созданный ранее раздел

![изображение](https://github.com/user-attachments/assets/8662287e-a5d7-4e60-b175-81805e0e3d29)

Чтобы отключить раздел и защитить данные выполним

![изображение](https://github.com/user-attachments/assets/d633ce27-7562-4be3-8de7-d4d2a5adcc84)

Как видим диск больше не отображается в системе, для повторного монтирования потребуется снова выполнить команду:

sudo cryptsetup luksOpen /dev/sdb1 disk

## Дополнительные задания (со звёздочкой*)

Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале

### Задание 3 *

1. Установите **apparmor**.

![изображение](https://github.com/user-attachments/assets/1a19b478-757a-4e48-b4e3-0cbf25f51cc6)
   
3. Повторите эксперимент, указанный в лекции.

- ls /etc/apparmor.d/

![изображение](https://github.com/user-attachments/assets/94eba279-1baa-4be9-bd56-74da486afcbc)

- sudo cp /usr/bin/man /usr/bin/man1

![изображение](https://github.com/user-attachments/assets/db8647d8-bbd2-4e30-82a6-3cb7c61b435a)

- sudo cp /bin/ping /usr/bin/man

![изображение](https://github.com/user-attachments/assets/0a00fbb3-3200-423f-9176-1cc5590ef2f6)

- sudo man 127.0.0.1

![изображение](https://github.com/user-attachments/assets/09607fed-7208-49a1-acd5-887c7a2d2389)

- sudo aa-enforce man

![изображение](https://github.com/user-attachments/assets/7ae58475-9f6a-49bc-bea6-e3eb74340da0)

- sudo man 127.0.0.1

![изображение](https://github.com/user-attachments/assets/08e899d9-d3ff-4b85-a518-175d63a77ba9)

5. Отключите (удалите) apparmor.

*В качестве ответа пришлите снимки экрана с поэтапным выполнением задания.*

![изображение](https://github.com/user-attachments/assets/78bfba89-0f05-4ee7-ac19-504cf5e1d442)



