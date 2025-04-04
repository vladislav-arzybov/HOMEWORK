# Домашнее задание к занятию 2 «Работа с Playbook» - `Арзыбов Владислав`

## Подготовка к выполнению

1. * Необязательно. Изучите, что такое [ClickHouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [Vector](https://www.youtube.com/watch?v=CgEhyffisLY).
2. Создайте свой публичный репозиторий на GitHub с произвольным именем или используйте старый.
3. Скачайте [Playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

![изображение](https://github.com/user-attachments/assets/5f8cdac0-1172-4d94-b61f-60608e5b1e6b)

## Основная часть

1. Подготовьте свой inventory-файл `prod.yml`.

```
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: 158.160.129.222
```

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev). Конфигурация vector должна деплоиться через template файл jinja2. От вас не требуется использовать все возможности шаблонизатора, просто вставьте стандартный конфиг в template файл. Информация по шаблонам по [ссылке](https://www.dmosk.ru/instruktions.php?object=ansible-nginx-install). не забудьте сделать handler на перезапуск vector в случае изменения конфигурации!
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.

[site.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/17_Sistema_upravleniya_konfiguraciyami/02_Working_with_Playbook/playbooks/site.yml)

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

<details>
  <summary>ansible-lint site.yml</summary>

```bash
reivol@Zabbix:~/GitHub/mnt-homeworks/08-ansible-02-playbook/playbooks$ ansible-lint site.yml
WARNING  Listing 12 violation(s) that are fatal
yaml: trailing spaces (trailing-spaces)
site.yml:42

risky-file-permissions: File permissions unset or incorrect
site.yml:57 Task/Handler: Create Directories

yaml: wrong indentation: expected 4 but found 2 (indentation)
site.yml:57

yaml: missing starting space in comment (comments)
site.yml:58

yaml: trailing spaces (trailing-spaces)
site.yml:60

yaml: truthy value should be one of [false, true] (truthy)
site.yml:74

yaml: truthy value should be one of [false, true] (truthy)
site.yml:83

risky-file-permissions: File permissions unset or incorrect
site.yml:85 Task/Handler: Copy systemd service vector

yaml: truthy value should be one of [false, true] (truthy)
site.yml:90

risky-file-permissions: File permissions unset or incorrect
site.yml:116 Task/Handler: Config vector j2 template

yaml: trailing spaces (trailing-spaces)
site.yml:121

yaml: no new line character at the end of file (new-line-at-end-of-file)
site.yml:122

You can skip specific rules or tags by adding them to your configuration file:
# .ansible-lint
warn_list:  # or 'skip_list' to silence them completely
  - experimental  # all rules tagged as experimental
  - yaml  # Violations reported by yamllint

Finished with 9 failure(s), 3 warning(s) on 1 files.

```  
</details>

- После исправления

![изображение](https://github.com/user-attachments/assets/119c93b4-e91a-46db-847f-9b48903acc63)


6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

- Закоментировал блок Rescue чтобы не смущала ошибка при запуске плейбука, т.к. пакет clickhouse-common-static.noarch.rpm отсутствует для данной версии  

![изображение](https://github.com/user-attachments/assets/ccced087-5aff-4246-9e02-6a44071b592b)

- Проверка останавливается на этапе установки пакетов Clickhouse, т.к. при использовании флага --check никакие изменния не вносятся в систему и пакеты ещё не загружены.

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

Результат: [prod.yml--diff](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/17_Sistema_upravleniya_konfiguraciyami/02_Working_with_Playbook/prodyml--diff.md)

- Проверка состояния слежбы clickhouse-server

![изображение](https://github.com/user-attachments/assets/b94d36eb-2f20-484f-b261-825bed2851e4)

- Проверка создания БД

![изображение](https://github.com/user-attachments/assets/6755ba88-5192-402f-89c2-f2af014b5a33)

- Проверска состояния службы vector.service и замены конфига vector.toml.j2

![изображение](https://github.com/user-attachments/assets/d7528475-6b19-4548-a4cd-25d4bfcbba79)

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

Результат: [prod.yml--diff_2](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/17_Sistema_upravleniya_konfiguraciyami/02_Working_with_Playbook/prodyml--diff_2.md)

- В процессе настройки выполняется копирование базового конфига vaector'а из архива с последующей заменой на измененный конфиг из шаблона vector.toml.j2, при запуске плейбука конфиги перезаписывают друг-друга, playbook идемпотентен.

9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги. Пример качественной документации ansible playbook по [ссылке](https://github.com/opensearch-project/ansible-playbook). Так же приложите скриншоты выполнения заданий №5-8

[README.md](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/17_Sistema_upravleniya_konfiguraciyami/02_Working_with_Playbook/README.md)

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

[08-ansible-02-playbook](https://github.com/vladislav-arzybov/HOMEWORK/commit/322cb6e8f20ebb0443ebc482a855bd91ff302785)

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
