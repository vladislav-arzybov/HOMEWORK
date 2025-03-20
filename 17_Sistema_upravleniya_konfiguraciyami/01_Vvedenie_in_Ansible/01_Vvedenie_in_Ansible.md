# Домашнее задание к занятию 1 «Введение в Ansible» - `Арзыбов Владислав`

## Подготовка к выполнению

1. Установите Ansible версии 2.10 или выше.

![изображение](https://github.com/user-attachments/assets/c6a5d126-ae50-44f2-b683-d74576adbd01)

2. Создайте свой публичный репозиторий на GitHub с произвольным именем.

![изображение](https://github.com/user-attachments/assets/24d5e633-d8d5-46b4-9489-cab99243be38)

3. Скачайте [Playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

![изображение](https://github.com/user-attachments/assets/d89ccbfe-8a22-402a-90a9-f2a75fca0978)

## Основная часть

1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте значение, которое имеет факт `some_fact` для указанного хоста при выполнении playbook.

- ansible-playbook -i inventory/test.yml site.yml

![изображение](https://github.com/user-attachments/assets/32628e5f-0b2b-4663-8b43-0ab4c37255f5)

2. Найдите файл с переменными (group_vars), в котором задаётся найденное в первом пункте значение, и поменяйте его на `all default fact`.

![изображение](https://github.com/user-attachments/assets/0413199e-548b-4ff4-a884-f9b1b4348c51)

![изображение](https://github.com/user-attachments/assets/769c05f4-6318-4252-bfdf-96f686f6c099)

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

- docker run -t -d --name ubuntu pycontribs/ubuntu
- docker run -t -d --name centos7 pycontribs/centos:7

![изображение](https://github.com/user-attachments/assets/4530bebd-28c3-4dae-a73b-71329e424718)

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

- ansible-playbook -i inventory/prod.yml site.yml

![изображение](https://github.com/user-attachments/assets/da69acb0-c086-4019-a8e4-423aa2a636cb)

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились значения: для `deb` — `deb default fact`, для `el` — `el default fact`.

- some_fact: "deb default fact"
- some_fact: "el default fact"

6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

![изображение](https://github.com/user-attachments/assets/fcad9c71-acde-4de8-8545-62968651c31a)

7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

- ansible-vault encrypt group_vars/deb/examp.yml
- ansible-vault encrypt group_vars/el/examp.yml 

![изображение](https://github.com/user-attachments/assets/f609c085-87b7-4414-8c52-02dd3990845a)

![изображение](https://github.com/user-attachments/assets/dc8a0b35-63db-4c26-91ac-5083c47446c8)

8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

- ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass

![изображение](https://github.com/user-attachments/assets/53ea5bd6-2ae5-4387-b883-882c359dc6a1)

9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

- ansible-doc -t connection -l

![изображение](https://github.com/user-attachments/assets/af727fee-034a-4574-b7b9-2acef4bfcb59)

Для работы с докером можно выбрать плагин: community.docker.docker

10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

```
  local:
    hosts:
      localhost:
        ansible_connection: local
```

11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь, что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

![изображение](https://github.com/user-attachments/assets/d12054a8-bd16-4dfd-a59a-b39441838f9b)

12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

![изображение](https://github.com/user-attachments/assets/d29be238-fcca-4b11-a7c5-5b769dc939f1)

[playbook](https://github.com/vladislav-arzybov/HOMEWORK/tree/main/17_Sistema_upravleniya_konfiguraciyami/01_Vvedenie_in_Ansible/playbook)

13. Предоставьте скриншоты результатов запуска команд.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.

- ansible-vault decrypt group_vars/deb/examp.yml
- ansible-vault decrypt group_vars/el/examp.yml

3. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.

![изображение](https://github.com/user-attachments/assets/1094f9b9-e011-4753-a646-58d72715a62e)

![изображение](https://github.com/user-attachments/assets/d93d7be9-9a10-4667-abff-4ae3efdef972)

5. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.

![изображение](https://github.com/user-attachments/assets/b8a33fe7-f161-4062-bcd9-ee16ba151da1)

7. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот вариант](https://hub.docker.com/r/pycontribs/fedora).

- docker run -t -d --name fedora pycontribs/fedora

![изображение](https://github.com/user-attachments/assets/72919a8e-6a61-4ab4-ad2f-f5eed63c98c9)

```
  fed:
    hosts:
      fedora:
        ansible_connection: docker
```

![изображение](https://github.com/user-attachments/assets/b5ef332f-c208-4829-a127-af3b0943998f)

![изображение](https://github.com/user-attachments/assets/57bf99f8-c58c-4a28-a07a-7af8fa901f01)

9. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.

<details>
  <summary>script.sh</summary>

```
reivol@Zabbix:~/GitHub/HOMEWORK/17_Sistema_upravleniya_konfiguraciyami/01_Vvedenie_in_Ansible/playbook$ ./script.sh 
docker start
fedora
centos7
ubuntu

PLAY [Print os facts] **************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************
ok: [localhost]
ok: [fedora]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ********************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [fedora] => {
    "msg": "Fedora"
}

TASK [Print fact] ******************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [fedora] => {
    "msg": "fedora default fact"
}

PLAY RECAP *************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

docker stop
fedora
centos7
ubuntu
reivol@Zabbix:~/GitHub/HOMEWORK/17_Sistema_upravleniya_konfiguraciyami/01_Vvedenie_in_Ansible/playbook$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
reivol@Zabbix:~/GitHub/HOMEWORK/17_Sistema_upravleniya_konfiguraciyami/01_Vvedenie_in_Ansible/playbook$ 
```

</details>

11. Все изменения должны быть зафиксированы и отправлены в ваш личный репозиторий.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
