# Домашнее задание к занятию 2 «Работа с Playbook» - `Арзыбов Владислав`

## Подготовка к выполнению

1. * Необязательно. Изучите, что такое [ClickHouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [Vector](https://www.youtube.com/watch?v=CgEhyffisLY).
2. Создайте свой публичный репозиторий на GitHub с произвольным именем или используйте старый.
3. Скачайте [Playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

![изображение](https://github.com/user-attachments/assets/2f6e9806-e2f1-4aef-a34b-2570fc2b649b)


## Основная часть

1. Подготовьте свой inventory-файл `prod.yml`.

```
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: 158.160.176.225
```

3. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev). Конфигурация vector должна деплоиться через template файл jinja2. От вас не требуется использовать все возможности шаблонизатора, просто вставьте стандартный конфиг в template файл. Информация по шаблонам по [ссылке](https://www.dmosk.ru/instruktions.php?object=ansible-nginx-install). не забудьте сделать handler на перезапуск vector в случае изменения конфигурации!
4. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
5. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.
6. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

<details>
  <summary>ansible-lint</summary>

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

8. Попробуйте запустить playbook на этом окружении с флагом `--check`.
9. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
10. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
11. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги. Пример качественной документации ansible playbook по [ссылке](https://github.com/opensearch-project/ansible-playbook). Так же приложите скриншоты выполнения заданий №5-8
12. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
