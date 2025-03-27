# Домашнее задание к занятию 3 «Использование Ansible» - `Арзыбов Владислав` для ДЗ

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.

![изображение](https://github.com/user-attachments/assets/74ec6682-4eed-4689-a370-3cdc19c85226)

2. Репозиторий LightHouse находится [по ссылке](https://github.com/VKCOM/lighthouse).

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает LightHouse.
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику LightHouse, установить Nginx или любой другой веб-сервер, настроить его конфиг для открытия LightHouse, запустить веб-сервер.
4. Подготовьте свой inventory-файл `prod.yml`.

```
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: 89.169.137.146
vector:
  hosts:
    vector-01:
      ansible_host: 89.169.144.160
lighthouse:
  hosts:
    lighthouse-01:
      ansible_host: 89.169.137.33
```

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

![изображение](https://github.com/user-attachments/assets/d7f40121-1057-42be-a4a5-b4cd723dffc8)

После исправления:

![изображение](https://github.com/user-attachments/assets/78d5dc29-faa7-495e-a83b-67d830314f47)

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

![изображение](https://github.com/user-attachments/assets/87042826-b137-418a-9b9d-3e6de10a8c2a)

![изображение](https://github.com/user-attachments/assets/c99519dd-1035-4cdd-97bf-1664b27a176f)

Проверка останавливается на этапе установки пакетов Clickhouse либо клонирования репозитория, т.к. при использовании флага --check никакие изменния в систему не вносятся и необходимые пакеты для выполнения команд ещё не загружены.

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

Результат: [prod.yml--diff.md](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/17_Sistema_upravleniya_konfiguraciyami/03_Using_Ansible/prodyml--diff.md)

Проверяем что на сервере lighthouse nginx установлен и работает:

![изображение](https://github.com/user-attachments/assets/770abc80-ed55-4af9-8f26-e55854fc10cd)

Подключаемся к серверу по ip для проверки работы LightHouse

![изображение](https://github.com/user-attachments/assets/6582dc2c-295c-49b5-aa23-137b0520c511)

![изображение](https://github.com/user-attachments/assets/75e86e55-46c4-4e5e-8f67-e2ee038c41eb)

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

результат: [prod.yml--diff2.md](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/17_Sistema_upravleniya_konfiguraciyami/03_Using_Ansible/prodyml--diff2.md)

В процессе настройки выполняется копирование базового конфига vaector'а из архива с последующей заменой на измененный конфиг из шаблона vector.toml.j2, при запуске плейбука конфиги перезаписывают друг-друга, playbook идемпотентен.

9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

[README.md](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/17_Sistema_upravleniya_konfiguraciyami/03_Using_Ansible/README.md)

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

[08-ansible-03-yandex](https://github.com/vladislav-arzybov/HOMEWORK/commit/da3357a6c6e6fa97b3fbb426c16d15dab070463c)

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
