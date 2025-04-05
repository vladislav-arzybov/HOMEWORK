# Домашнее задание к занятию 5 «Тестирование roles»

## Подготовка к выполнению

1. Установите molecule и его драйвера: `pip3 install "molecule molecule_docker molecule_podman`.
2. Выполните `docker pull aragast/netology:latest` —  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.

![изображение](https://github.com/user-attachments/assets/76c9233e-ffac-4319-a402-3f29816ffe19)


## Основная часть

Ваша цель — настроить тестирование ваших ролей. 


Задача — сделать сценарии тестирования для vector. 

Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s ubuntu_xenial` (или с любым другим сценарием, не имеет значения) внутри корневой директории clickhouse-role, посмотрите на вывод команды. Данная команда может отработать с ошибками или не отработать вовсе, это нормально. Наша цель - посмотреть как другие в реальном мире используют молекулу И из чего может состоять сценарий тестирования.

![изображение](https://github.com/user-attachments/assets/854e5e6d-db52-4023-8fe9-117318c815ed)

3. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.

![изображение](https://github.com/user-attachments/assets/6c499076-36f7-4fc5-ac67-48c0dbf618c4)

4. Добавьте несколько разных дистрибутивов (oraclelinux:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.

Образы для тестов были собраны заранее из Dockerfile на основе images oraclelinux:8 и ubuntu:latest с предустановкой python3.12 и systemd

```
platforms:
  - name: ubuntu
    image: ubuntu_sistem:latest
    command: /lib/systemd/systemd
    pre_build_image: true
    privileged: true
    cgroupns_mode: host
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:rw
  - name: oraclelinux8
    image: oraclelinux_sistem:latest
    command: /usr/sbin/init
    pre_build_image: true
    privileged: true
    cgroupns_mode: host
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:rw
```

<details>
  <summary>module.marketing_vm</summary>

  ```bash

reivol@Zabbix:~/Ansible_v2/Les_5/vector-role$ molecule test
WARNING  Driver docker does not provide a schema.
INFO     default scenario test matrix: dependency, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
WARNING  Another version of 'ansible.posix' 1.1.1 was found installed in /usr/lib/python3/dist-packages/ansible_collections, only the first one will be used, 2.0.0 (/home/reivol/.ansible/collections/ansible_collections).
WARNING  Another version of 'community.docker' 1.2.2 was found installed in /usr/lib/python3/dist-packages/ansible_collections, only the first one will be used, 4.5.2 (/home/reivol/.ansible/collections/ansible_collections).
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=ubuntu)
changed: [localhost] => (item=oraclelinux8)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=ubuntu)
ok: [localhost] => (item=oraclelinux8)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /home/reivol/Ansible_v2/Les_5/vector-role/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=ubuntu)
ok: [localhost] => (item=oraclelinux8)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item=ubuntu) 
skipping: [localhost] => (item=oraclelinux8) 
skipping: [localhost]

TASK [Synchronization the context] *********************************************
skipping: [localhost] => (item=ubuntu) 
skipping: [localhost] => (item=oraclelinux8) 
skipping: [localhost]

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item=unix://var/run/docker.sock)
ok: [localhost] => (item=unix://var/run/docker.sock)

TASK [Create docker network(s)] ************************************************
skipping: [localhost]

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/ubuntu_sistem:latest) 
skipping: [localhost] => (item=molecule_local/oraclelinux_sistem:latest) 
skipping: [localhost]

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item=ubuntu)
ok: [localhost] => (item=oraclelinux8)

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=ubuntu)
changed: [localhost] => (item=oraclelinux8)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item=ubuntu)
changed: [localhost] => (item=oraclelinux8)

PLAY RECAP *********************************************************************
localhost                  : ok=6    changed=2    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Include vector] **********************************************************
included: reivol.vector for oraclelinux8, ubuntu

TASK [reivol.vector : VECTOR | Create dir] *************************************
changed: [oraclelinux8]
changed: [ubuntu]

TASK [reivol.vector : VECTOR | Get vector distrib] *****************************
changed: [oraclelinux8]
changed: [ubuntu]

TASK [reivol.vector : VECTOR | Unarchive vector] *******************************
changed: [oraclelinux8]
changed: [ubuntu]

TASK [reivol.vector : VECTOR | Copy bin file vector] ***************************
changed: [ubuntu]
changed: [oraclelinux8]

TASK [reivol.vector : VECTOR | Copy systemd service vector] ********************
changed: [ubuntu]
changed: [oraclelinux8]

TASK [reivol.vector : VECTOR | Create user vector] *****************************
changed: [oraclelinux8]
changed: [ubuntu]

TASK [reivol.vector : VECTOR | Create vector catalog] **************************
changed: [ubuntu]
changed: [oraclelinux8]

TASK [reivol.vector : VECTOR | Create vector config dir] ***********************
changed: [oraclelinux8]
changed: [ubuntu]

TASK [reivol.vector : VECTOR | Config vector j2 template] **********************
changed: [ubuntu]
changed: [oraclelinux8]

RUNNING HANDLER [reivol.vector : Start vector service] *************************
changed: [ubuntu]
changed: [oraclelinux8]

PLAY RECAP *********************************************************************
oraclelinux8               : ok=11   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=11   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running default > idempotence

PLAY [Converge] ****************************************************************

TASK [Include vector] **********************************************************
included: reivol.vector for oraclelinux8, ubuntu

TASK [reivol.vector : VECTOR | Create dir] *************************************
ok: [oraclelinux8]
ok: [ubuntu]

TASK [reivol.vector : VECTOR | Get vector distrib] *****************************
ok: [oraclelinux8]
ok: [ubuntu]

TASK [reivol.vector : VECTOR | Unarchive vector] *******************************
ok: [ubuntu]
ok: [oraclelinux8]

TASK [reivol.vector : VECTOR | Copy bin file vector] ***************************
ok: [ubuntu]
ok: [oraclelinux8]

TASK [reivol.vector : VECTOR | Copy systemd service vector] ********************
ok: [oraclelinux8]
ok: [ubuntu]

TASK [reivol.vector : VECTOR | Create user vector] *****************************
ok: [oraclelinux8]
ok: [ubuntu]

TASK [reivol.vector : VECTOR | Create vector catalog] **************************
ok: [oraclelinux8]
ok: [ubuntu]

TASK [reivol.vector : VECTOR | Create vector config dir] ***********************
ok: [oraclelinux8]
ok: [ubuntu]

TASK [reivol.vector : VECTOR | Config vector j2 template] **********************
ok: [oraclelinux8]
ok: [ubuntu]

PLAY RECAP *********************************************************************
oraclelinux8               : ok=10   changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=10   changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running default > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running default > verify
INFO     Running Ansible Verifier
WARNING  Skipping, verify playbook not configured.
INFO     Verifier completed successfully.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=ubuntu)
changed: [localhost] => (item=oraclelinux8)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=ubuntu)
changed: [localhost] => (item=oraclelinux8)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory

```  

</details>


6. Добавьте несколько assert в verify.yml-файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.). 
7. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.

<details>
  <summary>module.marketing_vm</summary>

  ```bash

WARNING  Driver docker does not provide a schema.
INFO     default scenario test matrix: dependency, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
WARNING  Another version of 'ansible.posix' 1.1.1 was found installed in /usr/lib/python3/dist-packages/ansible_collections, only the first one will be used, 2.0.0 (/home/reivol/.ansible/collections/ansible_collections).
WARNING  Another version of 'community.docker' 1.2.2 was found installed in /usr/lib/python3/dist-packages/ansible_collections, only the first one will be used, 4.5.2 (/home/reivol/.ansible/collections/ansible_collections).
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
WARNING  Skipping, '--destroy=never' requested.
INFO     Running default > syntax
INFO     Sanity checks: 'docker'

playbook: /home/reivol/Ansible_v2/Les_5/vector-role/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=ubuntu)
ok: [localhost] => (item=oraclelinux8)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item=ubuntu) 
skipping: [localhost] => (item=oraclelinux8) 
skipping: [localhost]

TASK [Synchronization the context] *********************************************
skipping: [localhost] => (item=ubuntu) 
skipping: [localhost] => (item=oraclelinux8) 
skipping: [localhost]

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item=unix://var/run/docker.sock)
ok: [localhost] => (item=unix://var/run/docker.sock)

TASK [Create docker network(s)] ************************************************
skipping: [localhost]

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/docker.io/ubuntu:latest) 
skipping: [localhost] => (item=molecule_local/docker.io/oraclelinux:8) 
skipping: [localhost]

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item=ubuntu)
ok: [localhost] => (item=oraclelinux8)

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=ubuntu)
changed: [localhost] => (item=oraclelinux8)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item=ubuntu)
changed: [localhost] => (item=oraclelinux8)

PLAY RECAP *********************************************************************
localhost                  : ok=6    changed=2    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Include vector] **********************************************************
included: reivol.vector for oraclelinux8, ubuntu

TASK [reivol.vector : VECTOR | Create dir] *************************************


```  

</details>


5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example).
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
6. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Не забудьте указать в ответе теги решений Tox и Molecule заданий. В качестве решения пришлите ссылку на  ваш репозиторий и скриншоты этапов выполнения задания. 

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли LightHouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории.

В качестве решения пришлите ссылки и скриншоты этапов выполнения задания.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.
