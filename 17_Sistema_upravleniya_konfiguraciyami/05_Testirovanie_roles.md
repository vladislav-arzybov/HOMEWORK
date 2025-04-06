# Домашнее задание к занятию 5 «Тестирование roles»

## Подготовка к выполнению

1. Установите molecule и его драйвера: `pip3 install "molecule molecule_docker molecule_podman`.

![изображение](https://github.com/user-attachments/assets/e7b56914-3d79-410c-a720-f980eb820f08)

2. Выполните `docker pull aragast/netology:latest` —  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.

![изображение](https://github.com/user-attachments/assets/76c9233e-ffac-4319-a402-3f29816ffe19)


## Основная часть

Ваша цель — настроить тестирование ваших ролей. 


Задача — сделать сценарии тестирования для vector. 

Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s ubuntu_xenial` (или с любым другим сценарием, не имеет значения) внутри корневой директории clickhouse-role, посмотрите на вывод команды. Данная команда может отработать с ошибками или не отработать вовсе, это нормально. Наша цель - посмотреть как другие в реальном мире используют молекулу И из чего может состоять сценарий тестирования.

![изображение](https://github.com/user-attachments/assets/854e5e6d-db52-4023-8fe9-117318c815ed)

2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.

![изображение](https://github.com/user-attachments/assets/6c499076-36f7-4fc5-ac67-48c0dbf618c4)

3. Добавьте несколько разных дистрибутивов (oraclelinux:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.

Образы для тестов были собраны заранее из [Dockerfile](https://github.com/vladislav-arzybov/vector-role/tree/main/DOCK) на основе images oraclelinux:8 и ubuntu:latest с предустановкой python3.12 и systemd

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
  <summary>molecule test</summary>

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


4. Добавьте несколько assert в verify.yml-файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.).

```
  tasks:
  - name: Ansible check file exists.
    stat:
      path: "/etc/vector/vector.toml"
    register: file_status
  - debug:
      msg: "File exists."
    when: file_status.stat.exists
  - debug:
      msg: "ERROR: File not found!"
    when: file_status.stat.exists == False
  - name: Get Service Status
    ansible.builtin.service:
      name: vector.service
    register: service_status
  - debug:
      var: service_status.status.ActiveState
```

5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.

<details>
  <summary>molecule test with verify.yml</summary>

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
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=ubuntu)
changed: [localhost] => (item=oraclelinux8)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

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
changed: [ubuntu]
changed: [oraclelinux8]

TASK [reivol.vector : VECTOR | Unarchive vector] *******************************
changed: [ubuntu]
changed: [oraclelinux8]

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
changed: [ubuntu]
changed: [oraclelinux8]

TASK [reivol.vector : VECTOR | Config vector j2 template] **********************
changed: [oraclelinux8]
changed: [ubuntu]

RUNNING HANDLER [reivol.vector : Start vector service] *************************
changed: [oraclelinux8]
changed: [ubuntu]

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
ok: [oraclelinux8]
ok: [ubuntu]

TASK [reivol.vector : VECTOR | Copy bin file vector] ***************************
ok: [oraclelinux8]
ok: [ubuntu]

TASK [reivol.vector : VECTOR | Copy systemd service vector] ********************
ok: [oraclelinux8]
ok: [ubuntu]

TASK [reivol.vector : VECTOR | Create user vector] *****************************
ok: [ubuntu]
ok: [oraclelinux8]

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

PLAY [Verify] ******************************************************************

TASK [Ansible check file exists.] **********************************************
ok: [ubuntu]
ok: [oraclelinux8]

TASK [debug] *******************************************************************
ok: [oraclelinux8] => {
    "msg": "File exists."
}
ok: [ubuntu] => {
    "msg": "File exists."
}

TASK [debug] *******************************************************************
skipping: [oraclelinux8]
skipping: [ubuntu]

TASK [Get Service Status] ******************************************************
ok: [ubuntu]
ok: [oraclelinux8]

TASK [debug] *******************************************************************
ok: [oraclelinux8] => {
    "service_status.status.ActiveState": "active"
}
ok: [ubuntu] => {
    "service_status.status.ActiveState": "active"
}

PLAY RECAP *********************************************************************
oraclelinux8               : ok=4    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
ubuntu                     : ok=4    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

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


6. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

[1.1.0](https://github.com/vladislav-arzybov/vector-role/commit/c9d52f2aa9bbe411f63f19615d632a9fe6cd5019)


### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example).

![изображение](https://github.com/user-attachments/assets/76e73fd2-feb3-443c-83d4-59c6c5b7829a)

3. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.

- docker run --privileged=True -v /home/reivol/Ansible_v2/Les_5/vector-role/:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash

![изображение](https://github.com/user-attachments/assets/78da9718-5fd0-416b-907c-fe72d2f80a9a)

4. Внутри контейнера выполните команду `tox`, посмотрите на вывод.

<details>
  <summary>tox</summary>

  ```bash
[root@b3eeac1a13dd vector-role]# tox
py37-ansible210 create: /opt/vector-role/.tox/py37-ansible210
py37-ansible210 installdeps: -rtox-requirements.txt, ansible<3.0
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,arrow==1.2.3,bcrypt==4.2.1,binaryornot==0.4.4,cached-property==1.5.2,Cerberus==1.3.7,certifi==2025.1.31,cffi==1.15.1,chardet==5.2.0,charset-normalizer==3.4.1,click==8.1.8,click-help-colors==0.9.4,cookiecutter==2.6.0,cryptography==44.0.2,distro==1.9.0,enrich==1.2.7,idna==3.10,importlib-metadata==6.7.0,Jinja2==3.1.6,jmespath==1.0.1,lxml==5.3.2,markdown-it-py==2.2.0,MarkupSafe==2.1.5,mdurl==0.1.2,molecule==3.6.1,molecule-podman==1.1.0,packaging==24.0,paramiko==2.12.0,pluggy==1.2.0,pycparser==2.21,Pygments==2.17.2,PyNaCl==1.5.0,python-dateutil==2.9.0.post0,python-slugify==8.0.4,PyYAML==6.0.1,requests==2.31.0,rich==13.8.1,selinux==0.2.1,six==1.17.0,subprocess-tee==0.3.5,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.7,zipp==3.15.0
py37-ansible210 run-test-pre: PYTHONHASHSEED='2357126235'
py37-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. A future release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
py37-ansible30 create: /opt/vector-role/.tox/py37-ansible30
py37-ansible30 installdeps: -rtox-requirements.txt, ansible<3.1
py37-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==1.0.0,arrow==1.2.3,bcrypt==4.2.1,binaryornot==0.4.4,cached-property==1.5.2,Cerberus==1.3.7,certifi==2025.1.31,cffi==1.15.1,chardet==5.2.0,charset-normalizer==3.4.1,click==8.1.8,click-help-colors==0.9.4,cookiecutter==2.6.0,cryptography==44.0.2,distro==1.9.0,enrich==1.2.7,idna==3.10,importlib-metadata==6.7.0,Jinja2==3.1.6,jmespath==1.0.1,lxml==5.3.2,markdown-it-py==2.2.0,MarkupSafe==2.1.5,mdurl==0.1.2,molecule==3.6.1,molecule-podman==1.1.0,packaging==24.0,paramiko==2.12.0,pluggy==1.2.0,pycparser==2.21,Pygments==2.17.2,PyNaCl==1.5.0,python-dateutil==2.9.0.post0,python-slugify==8.0.4,PyYAML==6.0.1,requests==2.31.0,rich==13.8.1,selinux==0.2.1,six==1.17.0,subprocess-tee==0.3.5,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.7,zipp==3.15.0
py37-ansible30 run-test-pre: PYTHONHASHSEED='2357126235'
py37-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. A future release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
py39-ansible210 create: /opt/vector-role/.tox/py39-ansible210
py39-ansible210 installdeps: -rtox-requirements.txt, ansible<3.0
py39-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==24.10.0,ansible-core==2.15.13,attrs==25.3.0,bracex==2.5.post1,cffi==1.17.1,click==8.1.8,click-help-colors==0.9.4,cryptography==44.0.2,distro==1.9.0,enrich==1.2.7,importlib-resources==5.0.7,Jinja2==3.1.6,jmespath==1.0.1,jsonschema==4.23.0,jsonschema-specifications==2024.10.1,lxml==5.3.2,markdown-it-py==3.0.0,MarkupSafe==3.0.2,mdurl==0.1.2,molecule==6.0.3,molecule-podman==2.0.3,packaging==24.2,pluggy==1.5.0,pycparser==2.22,Pygments==2.19.1,PyYAML==6.0.2,referencing==0.36.2,resolvelib==1.0.1,rich==14.0.0,rpds-py==0.24.0,selinux==0.3.0,subprocess-tee==0.4.2,typing_extensions==4.13.1,wcmatch==10.0
py39-ansible210 run-test-pre: PYTHONHASHSEED='2357126235'
py39-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
py39-ansible30 create: /opt/vector-role/.tox/py39-ansible30
py39-ansible30 installdeps: -rtox-requirements.txt, ansible<3.1
py39-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==24.10.0,ansible-core==2.15.13,attrs==25.3.0,bracex==2.5.post1,cffi==1.17.1,click==8.1.8,click-help-colors==0.9.4,cryptography==44.0.2,distro==1.9.0,enrich==1.2.7,importlib-resources==5.0.7,Jinja2==3.1.6,jmespath==1.0.1,jsonschema==4.23.0,jsonschema-specifications==2024.10.1,lxml==5.3.2,markdown-it-py==3.0.0,MarkupSafe==3.0.2,mdurl==0.1.2,molecule==6.0.3,molecule-podman==2.0.3,packaging==24.2,pluggy==1.5.0,pycparser==2.22,Pygments==2.19.1,PyYAML==6.0.2,referencing==0.36.2,resolvelib==1.0.1,rich==14.0.0,rpds-py==0.24.0,selinux==0.3.0,subprocess-tee==0.4.2,typing_extensions==4.13.1,wcmatch==10.0
py39-ansible30 run-test-pre: PYTHONHASHSEED='2357126235'
py39-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
_________________________________________________________________________________________________ summary __________________________________________________________________________________________________
ERROR:   py37-ansible210: commands failed
ERROR:   py37-ansible30: commands failed
ERROR:   py39-ansible210: commands failed
ERROR:   py39-ansible30: commands failed
```  

</details>

Ошибка возникает по причине ещё не созданного сценария compatibility в папке molecule.

6. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.

- molecule init scenario compatibility --driver-name podman

![изображение](https://github.com/user-attachments/assets/e7e097ff-42e7-4c38-8774-94dae033be0b)

```
driver:
  name: podman
platforms:
  - name: instance
  #  image: localhost/ubuntu_podman:latest
    image: docker.io/pycontribs/centos:7
    pre_build_image: true
scenario:
  test_sequence:
    - destroy
    - create
    - converge
    - destroy
```

Образ ubuntu_podman:latest был создан заранее на основе Dockerfile, чтобы осуществить первичную проверку на localhost машине: podman build -f Dockerfile -t ubuntu_podman .

```
FROM ubuntu:latest
RUN apt-get update && \
    apt-get install -y python3.12
```

<details>
  <summary>podman</summary>

  ```bash
reivol@Zabbix:~/Ansible_v2/Les_5/vector-role$ molecule test -s compatibility
WARNING  Driver podman does not provide a schema.
INFO     compatibility scenario test matrix: destroy, create, converge, destroy
INFO     Performing prerun with role_name_check=0...
WARNING  Another version of 'ansible.posix' 1.1.1 was found installed in /usr/lib/python3/dist-packages/ansible_collections, only the first one will be used, 2.0.0 (/home/reivol/.ansible/collections/ansible_collections).
WARNING  Another version of 'community.docker' 1.2.2 was found installed in /usr/lib/python3/dist-packages/ansible_collections, only the first one will be used, 4.5.2 (/home/reivol/.ansible/collections/ansible_collections).
WARNING  Another version of 'containers.podman' 1.4.1 was found installed in /usr/lib/python3/dist-packages/ansible_collections, only the first one will be used, 1.16.3 (/home/reivol/.ansible/collections/ansible_collections).
INFO     Running compatibility > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'localhost/ubuntu_podman:latest', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': 'j200601686370.26745', 'results_file': '/home/reivol/.ansible_async/j200601686370.26745', 'changed': True, 'item': {'image': 'localhost/ubuntu_podman:latest', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running compatibility > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="instance registry username: None specified") 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: localhost/ubuntu_podman:latest") 
skipping: [localhost]

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=instance)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=localhost/ubuntu_podman:latest) 
skipping: [localhost]

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="instance command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=instance: None specified) 
skipping: [localhost]

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item=instance)

PLAY RECAP *********************************************************************
localhost                  : ok=9    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running compatibility > converge

PLAY [Converge] ****************************************************************

TASK [Include vector] **********************************************************
included: reivol.vector for instance

TASK [reivol.vector : VECTOR | Create dir] *************************************
changed: [instance]

TASK [reivol.vector : VECTOR | Get vector distrib] *****************************
changed: [instance]

TASK [reivol.vector : VECTOR | Unarchive vector] *******************************
changed: [instance]

TASK [reivol.vector : VECTOR | Copy bin file vector] ***************************
changed: [instance]

TASK [reivol.vector : VECTOR | Copy systemd service vector] ********************
changed: [instance]

TASK [reivol.vector : VECTOR | Create user vector] *****************************
changed: [instance]

TASK [reivol.vector : VECTOR | Create vector catalog] **************************
changed: [instance]

TASK [reivol.vector : VECTOR | Create vector config dir] ***********************
changed: [instance]

TASK [reivol.vector : VECTOR | Config vector j2 template] **********************
changed: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=10   changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running compatibility > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'localhost/ubuntu_podman:latest', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (299 retries left).
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (298 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': 'j895211325122.32295', 'results_file': '/home/reivol/.ansible_async/j895211325122.32295', 'changed': True, 'item': {'image': 'localhost/ubuntu_podman:latest', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```  

</details>

8. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.

- Сценарий успешно запускается на python3.7, но падает в ошибку совместимости на python3.9

![изображение](https://github.com/user-attachments/assets/e70df590-059f-4a35-8f2c-a4d09be6fe5b)

- Чтобы проверить работу на python3.9 была изменена версия  ansible на ansible50: ansible<5.0

![изображение](https://github.com/user-attachments/assets/ef789fa8-e15b-408c-8cae-8363edb7cbf4)


```
[tox]
minversion = 1.8
basepython = python3.6
#envlist = py{37,39}-ansible{210,30}
envlist = py{37,39}-ansible{50}
skipsdist = true

[testenv]
passenv = *
deps =
    -r tox-requirements.txt
    ansible210: ansible<3.0
    ansible30: ansible<3.1
    ansible50: ansible<5.0
commands =
    {posargs:molecule test -s compatibility --destroy always}
```

10. Запустите команду `tox`. Убедитесь, что всё отработало успешно.

<details>
  <summary>tox compatibility ERR</summary>

  ```bash
[root@850df218c797 vector-role]# tox
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,arrow==1.2.3,bcrypt==4.2.1,binaryornot==0.4.4,cached-property==1.5.2,Cerberus==1.3.7,certifi==2025.1.31,cffi==1.15.1,chardet==5.2.0,charset-normalizer==3.4.1,click==8.1.8,click-help-colors==0.9.4,cookiecutter==2.6.0,cryptography==44.0.2,distro==1.9.0,enrich==1.2.7,idna==3.10,importlib-metadata==6.7.0,Jinja2==3.1.6,jmespath==1.0.1,lxml==5.3.2,markdown-it-py==2.2.0,MarkupSafe==2.1.5,mdurl==0.1.2,molecule==3.6.1,molecule-podman==1.1.0,packaging==24.0,paramiko==2.12.0,pluggy==1.2.0,pycparser==2.21,Pygments==2.17.2,PyNaCl==1.5.0,python-dateutil==2.9.0.post0,python-slugify==8.0.4,PyYAML==6.0.1,requests==2.31.0,rich==13.8.1,selinux==0.2.1,six==1.17.0,subprocess-tee==0.3.5,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.7,zipp==3.15.0
py37-ansible210 run-test-pre: PYTHONHASHSEED='1755504438'
py37-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. A future release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature
INFO     compatibility scenario test matrix: destroy, create, converge, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/b984a4/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/b984a4/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/b984a4/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /root/.ansible/roles/reivol.vector symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running compatibility > destroy
INFO     Sanity checks: 'podman'
/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. A future release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. A future release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature
/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/paramiko/pkey.py:82: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "cipher": algorithms.TripleDES,
/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/paramiko/transport.py:253: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "class": algorithms.TripleDES,
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '93276621967.754', 'results_file': '/root/.ansible_async/93276621967.754', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running compatibility > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. A future release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature
/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/paramiko/pkey.py:82: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "cipher": algorithms.TripleDES,
/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/paramiko/transport.py:253: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "class": algorithms.TripleDES,
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="instance registry username: None specified") 

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/centos:7") 

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=instance)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=docker.io/pycontribs/centos:7) 

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="instance command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=instance: None specified) 

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (299 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (298 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (297 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (296 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (295 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (294 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (293 retries left).
changed: [localhost] => (item=instance)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running compatibility > converge

PLAY [Converge] ****************************************************************

TASK [Include vector] **********************************************************
/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. A future release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature
/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/paramiko/pkey.py:82: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "cipher": algorithms.TripleDES,
/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/paramiko/transport.py:253: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "class": algorithms.TripleDES,

TASK [reivol.vector : VECTOR | Create dir] *************************************
changed: [instance]

TASK [reivol.vector : VECTOR | Get vector distrib] *****************************
changed: [instance]

TASK [reivol.vector : VECTOR | Unarchive vector] *******************************
changed: [instance]

TASK [reivol.vector : VECTOR | Copy bin file vector] ***************************
changed: [instance]

TASK [reivol.vector : VECTOR | Copy systemd service vector] ********************
changed: [instance]

TASK [reivol.vector : VECTOR | Create user vector] *****************************
changed: [instance]

TASK [reivol.vector : VECTOR | Create vector catalog] **************************
changed: [instance]

TASK [reivol.vector : VECTOR | Create vector config dir] ***********************
changed: [instance]

TASK [reivol.vector : VECTOR | Config vector j2 template] **********************
changed: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=9    changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running compatibility > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. A future release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature
/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/paramiko/pkey.py:82: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "cipher": algorithms.TripleDES,
/opt/vector-role/.tox/py37-ansible210/lib/python3.7/site-packages/paramiko/transport.py:253: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "class": algorithms.TripleDES,
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (298 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '875888062552.2626', 'results_file': '/root/.ansible_async/875888062552.2626', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
py37-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==1.0.0,arrow==1.2.3,bcrypt==4.2.1,binaryornot==0.4.4,cached-property==1.5.2,Cerberus==1.3.7,certifi==2025.1.31,cffi==1.15.1,chardet==5.2.0,charset-normalizer==3.4.1,click==8.1.8,click-help-colors==0.9.4,cookiecutter==2.6.0,cryptography==44.0.2,distro==1.9.0,enrich==1.2.7,idna==3.10,importlib-metadata==6.7.0,Jinja2==3.1.6,jmespath==1.0.1,lxml==5.3.2,markdown-it-py==2.2.0,MarkupSafe==2.1.5,mdurl==0.1.2,molecule==3.6.1,molecule-podman==1.1.0,packaging==24.0,paramiko==2.12.0,pluggy==1.2.0,pycparser==2.21,Pygments==2.17.2,PyNaCl==1.5.0,python-dateutil==2.9.0.post0,python-slugify==8.0.4,PyYAML==6.0.1,requests==2.31.0,rich==13.8.1,selinux==0.2.1,six==1.17.0,subprocess-tee==0.3.5,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.7,zipp==3.15.0
py37-ansible30 run-test-pre: PYTHONHASHSEED='1755504438'
py37-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. A future release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature
INFO     compatibility scenario test matrix: destroy, create, converge, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/b984a4/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/b984a4/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/b984a4/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /root/.ansible/roles/reivol.vector symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running compatibility > destroy
INFO     Sanity checks: 'podman'
/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. A future release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. A future release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature
/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/paramiko/pkey.py:82: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "cipher": algorithms.TripleDES,
/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/paramiko/transport.py:253: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "class": algorithms.TripleDES,
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '1663807344.2779', 'results_file': '/root/.ansible_async/1663807344.2779', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running compatibility > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. A future release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature
/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/paramiko/pkey.py:82: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "cipher": algorithms.TripleDES,
/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/paramiko/transport.py:253: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "class": algorithms.TripleDES,
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="instance registry username: None specified") 

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/centos:7") 

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=instance)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=docker.io/pycontribs/centos:7) 

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="instance command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=instance: None specified) 

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item=instance)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running compatibility > converge

PLAY [Converge] ****************************************************************

TASK [Include vector] **********************************************************
/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. A future release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature
/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/paramiko/pkey.py:82: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "cipher": algorithms.TripleDES,
/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/paramiko/transport.py:253: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "class": algorithms.TripleDES,

TASK [reivol.vector : VECTOR | Create dir] *************************************
changed: [instance]

TASK [reivol.vector : VECTOR | Get vector distrib] *****************************
changed: [instance]

TASK [reivol.vector : VECTOR | Unarchive vector] *******************************
changed: [instance]

TASK [reivol.vector : VECTOR | Copy bin file vector] ***************************
changed: [instance]

TASK [reivol.vector : VECTOR | Copy systemd service vector] ********************
changed: [instance]

TASK [reivol.vector : VECTOR | Create user vector] *****************************
changed: [instance]

TASK [reivol.vector : VECTOR | Create vector catalog] **************************
changed: [instance]

TASK [reivol.vector : VECTOR | Create vector config dir] ***********************
changed: [instance]

TASK [reivol.vector : VECTOR | Config vector j2 template] **********************
changed: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=9    changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running compatibility > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. A future release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature
/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/paramiko/pkey.py:82: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "cipher": algorithms.TripleDES,
/opt/vector-role/.tox/py37-ansible30/lib/python3.7/site-packages/paramiko/transport.py:253: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "class": algorithms.TripleDES,
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (298 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '776447634922.4519', 'results_file': '/root/.ansible_async/776447634922.4519', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
py39-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==24.10.0,ansible-core==2.15.13,attrs==25.3.0,bracex==2.5.post1,cffi==1.17.1,click==8.1.8,click-help-colors==0.9.4,cryptography==44.0.2,distro==1.9.0,enrich==1.2.7,importlib-resources==5.0.7,Jinja2==3.1.6,jmespath==1.0.1,jsonschema==4.23.0,jsonschema-specifications==2024.10.1,lxml==5.3.2,markdown-it-py==3.0.0,MarkupSafe==3.0.2,mdurl==0.1.2,molecule==6.0.3,molecule-podman==2.0.3,packaging==24.2,pluggy==1.5.0,pycparser==2.22,Pygments==2.19.1,PyYAML==6.0.2,referencing==0.36.2,resolvelib==1.0.1,rich==14.0.0,rpds-py==0.24.0,selinux==0.3.0,subprocess-tee==0.4.2,typing_extensions==4.13.1,wcmatch==10.0
py39-ansible210 run-test-pre: PYTHONHASHSEED='1755504438'
py39-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
WARNING  Driver podman does not provide a schema.
INFO     compatibility scenario test matrix: destroy, create, converge, destroy
INFO     Performing prerun with role_name_check=0...
ERROR    CompletedProcess(args=['ansible-galaxy', 'collection', 'list', '--format=json'], returncode=250, stdout='the full traceback was:\n\nTraceback (most recent call last):\n  File "/opt/vector-role/.tox/py39-ansible210/bin/ansible-galaxy", line 92, in <module>\n    mycli = getattr(__import__("ansible.cli.%s" % sub, fromlist=), myclass)\n  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible/cli/galaxy.py", line 24, in <module>\n    from ansible.galaxy.collection import (\n  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible/galaxy/collection/__init__.py", line 90, in <module>\n    from ansible.galaxy.collection.concrete_artifact_manager import (\n  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible/galaxy/collection/concrete_artifact_manager.py", line 30, in <module>\n    from ansible.galaxy.api import should_retry_error\nImportError: cannot import name \'should_retry_error\' from \'ansible.galaxy.api\' (/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible/galaxy/api.py)\n', stderr="ERROR! Unexpected Exception, this is probably a bug: cannot import name 'should_retry_error' from 'ansible.galaxy.api' (/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible/galaxy/api.py)\n")
Traceback (most recent call last):
  File "/opt/vector-role/.tox/py39-ansible210/bin/molecule", line 8, in <module>
    sys.exit(main())
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/core.py", line 1161, in __call__
    return self.main(*args, **kwargs)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/core.py", line 1082, in main
    rv = self.invoke(ctx)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/core.py", line 1697, in invoke
    return _process_result(sub_ctx.command.invoke(sub_ctx))
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/core.py", line 1443, in invoke
    return ctx.invoke(self.callback, **ctx.params)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/core.py", line 788, in invoke
    return __callback(*args, **kwargs)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/decorators.py", line 33, in new_func
    return f(get_current_context(), *args, **kwargs)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/command/test.py", line 113, in test
    base.execute_cmdline_scenarios(scenario_name, args, command_args, ansible_args)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/command/base.py", line 113, in execute_cmdline_scenarios
    scenario.config.runtime.prepare_environment(
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible_compat/runtime.py", line 726, in prepare_environment
    self.load_collections()
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible_compat/runtime.py", line 295, in load_collections
    raise RuntimeError(msg)
RuntimeError: Unable to list collections: CompletedProcess(args=['ansible-galaxy', 'collection', 'list', '--format=json'], returncode=250, stdout='the full traceback was:\n\nTraceback (most recent call last):\n  File "/opt/vector-role/.tox/py39-ansible210/bin/ansible-galaxy", line 92, in <module>\n    mycli = getattr(__import__("ansible.cli.%s" % sub, fromlist=[myclass]), myclass)\n  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible/cli/galaxy.py", line 24, in <module>\n    from ansible.galaxy.collection import (\n  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible/galaxy/collection/__init__.py", line 90, in <module>\n    from ansible.galaxy.collection.concrete_artifact_manager import (\n  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible/galaxy/collection/concrete_artifact_manager.py", line 30, in <module>\n    from ansible.galaxy.api import should_retry_error\nImportError: cannot import name \'should_retry_error\' from \'ansible.galaxy.api\' (/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible/galaxy/api.py)\n', stderr="ERROR! Unexpected Exception, this is probably a bug: cannot import name 'should_retry_error' from 'ansible.galaxy.api' (/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible/galaxy/api.py)\n")
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
py39-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==24.10.0,ansible-core==2.15.13,attrs==25.3.0,bracex==2.5.post1,cffi==1.17.1,click==8.1.8,click-help-colors==0.9.4,cryptography==44.0.2,distro==1.9.0,enrich==1.2.7,importlib-resources==5.0.7,Jinja2==3.1.6,jmespath==1.0.1,jsonschema==4.23.0,jsonschema-specifications==2024.10.1,lxml==5.3.2,markdown-it-py==3.0.0,MarkupSafe==3.0.2,mdurl==0.1.2,molecule==6.0.3,molecule-podman==2.0.3,packaging==24.2,pluggy==1.5.0,pycparser==2.22,Pygments==2.19.1,PyYAML==6.0.2,referencing==0.36.2,resolvelib==1.0.1,rich==14.0.0,rpds-py==0.24.0,selinux==0.3.0,subprocess-tee==0.4.2,typing_extensions==4.13.1,wcmatch==10.0
py39-ansible30 run-test-pre: PYTHONHASHSEED='1755504438'
py39-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
WARNING  Driver podman does not provide a schema.
INFO     compatibility scenario test matrix: destroy, create, converge, destroy
INFO     Performing prerun with role_name_check=0...
ERROR    CompletedProcess(args=['ansible-galaxy', 'collection', 'list', '--format=json'], returncode=250, stdout='the full traceback was:\n\nTraceback (most recent call last):\n  File "/opt/vector-role/.tox/py39-ansible30/bin/ansible-galaxy", line 92, in <module>\n    mycli = getattr(__import__("ansible.cli.%s" % sub, fromlist=), myclass)\n  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible/cli/galaxy.py", line 24, in <module>\n    from ansible.galaxy.collection import (\n  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible/galaxy/collection/__init__.py", line 90, in <module>\n    from ansible.galaxy.collection.concrete_artifact_manager import (\n  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible/galaxy/collection/concrete_artifact_manager.py", line 30, in <module>\n    from ansible.galaxy.api import should_retry_error\nImportError: cannot import name \'should_retry_error\' from \'ansible.galaxy.api\' (/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible/galaxy/api.py)\n', stderr="ERROR! Unexpected Exception, this is probably a bug: cannot import name 'should_retry_error' from 'ansible.galaxy.api' (/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible/galaxy/api.py)\n")
Traceback (most recent call last):
  File "/opt/vector-role/.tox/py39-ansible30/bin/molecule", line 8, in <module>
    sys.exit(main())
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 1161, in __call__
    return self.main(*args, **kwargs)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 1082, in main
    rv = self.invoke(ctx)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 1697, in invoke
    return _process_result(sub_ctx.command.invoke(sub_ctx))
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 1443, in invoke
    return ctx.invoke(self.callback, **ctx.params)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 788, in invoke
    return __callback(*args, **kwargs)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/decorators.py", line 33, in new_func
    return f(get_current_context(), *args, **kwargs)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/command/test.py", line 113, in test
    base.execute_cmdline_scenarios(scenario_name, args, command_args, ansible_args)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/command/base.py", line 113, in execute_cmdline_scenarios
    scenario.config.runtime.prepare_environment(
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible_compat/runtime.py", line 726, in prepare_environment
    self.load_collections()
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible_compat/runtime.py", line 295, in load_collections
    raise RuntimeError(msg)
RuntimeError: Unable to list collections: CompletedProcess(args=['ansible-galaxy', 'collection', 'list', '--format=json'], returncode=250, stdout='the full traceback was:\n\nTraceback (most recent call last):\n  File "/opt/vector-role/.tox/py39-ansible30/bin/ansible-galaxy", line 92, in <module>\n    mycli = getattr(__import__("ansible.cli.%s" % sub, fromlist=[myclass]), myclass)\n  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible/cli/galaxy.py", line 24, in <module>\n    from ansible.galaxy.collection import (\n  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible/galaxy/collection/__init__.py", line 90, in <module>\n    from ansible.galaxy.collection.concrete_artifact_manager import (\n  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible/galaxy/collection/concrete_artifact_manager.py", line 30, in <module>\n    from ansible.galaxy.api import should_retry_error\nImportError: cannot import name \'should_retry_error\' from \'ansible.galaxy.api\' (/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible/galaxy/api.py)\n', stderr="ERROR! Unexpected Exception, this is probably a bug: cannot import name 'should_retry_error' from 'ansible.galaxy.api' (/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible/galaxy/api.py)\n")
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
____________________________________________________________________________________________ summary ____________________________________________________________________________________________
  py37-ansible210: commands succeeded
  py37-ansible30: commands succeeded
ERROR:   py39-ansible210: commands failed
ERROR:   py39-ansible30: commands failed
```  

</details>


<details>
  <summary>tox compatibility ERR</summary>

  ```bash
[root@850df218c797 vector-role]# tox
py37-ansible50 installed: ansible==4.10.0,ansible-compat==1.0.0,ansible-core==2.11.12,arrow==1.2.3,bcrypt==4.2.1,binaryornot==0.4.4,cached-property==1.5.2,Cerberus==1.3.7,certifi==2025.1.31,cffi==1.15.1,chardet==5.2.0,charset-normalizer==3.4.1,click==8.1.8,click-help-colors==0.9.4,cookiecutter==2.6.0,cryptography==44.0.2,distro==1.9.0,enrich==1.2.7,idna==3.10,importlib-metadata==6.7.0,Jinja2==3.1.6,jmespath==1.0.1,lxml==5.3.2,markdown-it-py==2.2.0,MarkupSafe==2.1.5,mdurl==0.1.2,molecule==3.6.1,molecule-podman==1.1.0,packaging==24.0,paramiko==2.12.0,pluggy==1.2.0,pycparser==2.21,Pygments==2.17.2,PyNaCl==1.5.0,python-dateutil==2.9.0.post0,python-slugify==8.0.4,PyYAML==6.0.1,requests==2.31.0,resolvelib==0.5.4,rich==13.8.1,selinux==0.2.1,six==1.17.0,subprocess-tee==0.3.5,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.7,zipp==3.15.0
py37-ansible50 run-test-pre: PYTHONHASHSEED='595986026'
py37-ansible50 run-test: commands[0] | molecule test -s compatibility --destroy always
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the 
controller starting with Ansible 2.12. Current version: 3.7.10 (default, Jun 13
 2022, 19:37:24) [GCC 8.5.0 20210514 (Red Hat 8.5.0-10)]. This feature will be 
removed from ansible-core in version 2.12. Deprecation warnings can be disabled
 by setting deprecation_warnings=False in ansible.cfg.
/opt/vector-role/.tox/py37-ansible50/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. A future release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature
INFO     compatibility scenario test matrix: destroy, create, converge, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/b984a4/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/b984a4/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/b984a4/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /root/.ansible/roles/reivol.vector symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running compatibility > destroy
INFO     Sanity checks: 'podman'
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the 
controller starting with Ansible 2.12. Current version: 3.7.10 (default, Jun 13
 2022, 19:37:24) [GCC 8.5.0 20210514 (Red Hat 8.5.0-10)]. This feature will be 
removed from ansible-core in version 2.12. Deprecation warnings can be disabled
 by setting deprecation_warnings=False in ansible.cfg.
/opt/vector-role/.tox/py37-ansible50/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. A future release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the 
controller starting with Ansible 2.12. Current version: 3.7.10 (default, Jun 13
 2022, 19:37:24) [GCC 8.5.0 20210514 (Red Hat 8.5.0-10)]. This feature will be 
removed from ansible-core in version 2.12. Deprecation warnings can be disabled
 by setting deprecation_warnings=False in ansible.cfg.

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
/opt/vector-role/.tox/py37-ansible50/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. A future release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature
/opt/vector-role/.tox/py37-ansible50/lib/python3.7/site-packages/paramiko/pkey.py:82: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "cipher": algorithms.TripleDES,
/opt/vector-role/.tox/py37-ansible50/lib/python3.7/site-packages/paramiko/transport.py:253: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "class": algorithms.TripleDES,
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '897703193618.15515', 'results_file': '/root/.ansible_async/897703193618.15515', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running compatibility > create
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the 
controller starting with Ansible 2.12. Current version: 3.7.10 (default, Jun 13
 2022, 19:37:24) [GCC 8.5.0 20210514 (Red Hat 8.5.0-10)]. This feature will be 
removed from ansible-core in version 2.12. Deprecation warnings can be disabled
 by setting deprecation_warnings=False in ansible.cfg.

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
/opt/vector-role/.tox/py37-ansible50/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. A future release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature
/opt/vector-role/.tox/py37-ansible50/lib/python3.7/site-packages/paramiko/pkey.py:82: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "cipher": algorithms.TripleDES,
/opt/vector-role/.tox/py37-ansible50/lib/python3.7/site-packages/paramiko/transport.py:253: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "class": algorithms.TripleDES,
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="instance registry username: None specified") 

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/centos:7") 

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=instance)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=docker.io/pycontribs/centos:7) 

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="instance command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=instance: None specified) 

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item=instance)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running compatibility > converge
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the 
controller starting with Ansible 2.12. Current version: 3.7.10 (default, Jun 13
 2022, 19:37:24) [GCC 8.5.0 20210514 (Red Hat 8.5.0-10)]. This feature will be 
removed from ansible-core in version 2.12. Deprecation warnings can be disabled
 by setting deprecation_warnings=False in ansible.cfg.

PLAY [Converge] ****************************************************************

TASK [Include vector] **********************************************************
/opt/vector-role/.tox/py37-ansible50/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. A future release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature
/opt/vector-role/.tox/py37-ansible50/lib/python3.7/site-packages/paramiko/pkey.py:82: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "cipher": algorithms.TripleDES,
/opt/vector-role/.tox/py37-ansible50/lib/python3.7/site-packages/paramiko/transport.py:253: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "class": algorithms.TripleDES,

TASK [reivol.vector : VECTOR | Create dir] *************************************
changed: [instance]

TASK [reivol.vector : VECTOR | Get vector distrib] *****************************
changed: [instance]

TASK [reivol.vector : VECTOR | Unarchive vector] *******************************
changed: [instance]

TASK [reivol.vector : VECTOR | Copy bin file vector] ***************************
changed: [instance]

TASK [reivol.vector : VECTOR | Copy systemd service vector] ********************
changed: [instance]

TASK [reivol.vector : VECTOR | Create user vector] *****************************
changed: [instance]

TASK [reivol.vector : VECTOR | Create vector catalog] **************************
changed: [instance]

TASK [reivol.vector : VECTOR | Create vector config dir] ***********************
changed: [instance]

TASK [reivol.vector : VECTOR | Config vector j2 template] **********************
changed: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=9    changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running compatibility > destroy
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the 
controller starting with Ansible 2.12. Current version: 3.7.10 (default, Jun 13
 2022, 19:37:24) [GCC 8.5.0 20210514 (Red Hat 8.5.0-10)]. This feature will be 
removed from ansible-core in version 2.12. Deprecation warnings can be disabled
 by setting deprecation_warnings=False in ansible.cfg.

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
/opt/vector-role/.tox/py37-ansible50/lib/python3.7/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.7 is no longer supported by the Python core team and support for it is deprecated in cryptography. A future release of cryptography will remove support for Python 3.7.
  from cryptography.exceptions import InvalidSignature
/opt/vector-role/.tox/py37-ansible50/lib/python3.7/site-packages/paramiko/pkey.py:82: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "cipher": algorithms.TripleDES,
/opt/vector-role/.tox/py37-ansible50/lib/python3.7/site-packages/paramiko/transport.py:253: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
  "class": algorithms.TripleDES,
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (298 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '640748276159.17240', 'results_file': '/root/.ansible_async/640748276159.17240', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
py39-ansible50 installed: ansible==4.10.0,ansible-compat==2.2.7,ansible-core==2.11.12,arrow==1.3.0,attrs==25.3.0,binaryornot==0.4.4,certifi==2025.1.31,cffi==1.17.1,chardet==5.2.0,charset-normalizer==3.4.1,click==8.1.8,click-help-colors==0.9.4,cookiecutter==2.6.0,cryptography==44.0.2,distro==1.9.0,enrich==1.2.7,idna==3.10,Jinja2==3.1.6,jmespath==1.0.1,jsonschema==4.23.0,jsonschema-specifications==2024.10.1,lxml==5.3.2,markdown-it-py==3.0.0,MarkupSafe==3.0.2,mdurl==0.1.2,molecule==4.0.4,molecule-podman==2.0.3,packaging==24.2,pluggy==1.5.0,pycparser==2.22,Pygments==2.19.1,python-dateutil==2.9.0.post0,python-slugify==8.0.4,PyYAML==6.0.2,referencing==0.36.2,requests==2.32.3,resolvelib==0.5.4,rich==14.0.0,rpds-py==0.24.0,selinux==0.3.0,six==1.17.0,subprocess-tee==0.4.2,text-unidecode==1.3,types-python-dateutil==2.9.0.20241206,typing_extensions==4.13.1,urllib3==2.3.0
py39-ansible50 run-test-pre: PYTHONHASHSEED='595986026'
py39-ansible50 run-test: commands[0] | molecule test -s compatibility --destroy always
INFO     compatibility scenario test matrix: destroy, create, converge, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/f5bcd7/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/f5bcd7/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/f5bcd7/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /root/.cache/ansible-compat/f5bcd7/roles/reivol.vector symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running compatibility > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '739984656960.17383', 'results_file': '/root/.ansible_async/739984656960.17383', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running compatibility > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="instance registry username: None specified") 

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/centos:7") 

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=instance)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=docker.io/pycontribs/centos:7) 

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="instance command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=instance: None specified) 

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item=instance)

PLAY RECAP *********************************************************************
localhost                  : ok=9    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running compatibility > converge

PLAY [Converge] ****************************************************************

TASK [Include vector] **********************************************************

TASK [reivol.vector : VECTOR | Create dir] *************************************
changed: [instance]

TASK [reivol.vector : VECTOR | Get vector distrib] *****************************
changed: [instance]

TASK [reivol.vector : VECTOR | Unarchive vector] *******************************
changed: [instance]

TASK [reivol.vector : VECTOR | Copy bin file vector] ***************************
changed: [instance]

TASK [reivol.vector : VECTOR | Copy systemd service vector] ********************
changed: [instance]

TASK [reivol.vector : VECTOR | Create user vector] *****************************
changed: [instance]

TASK [reivol.vector : VECTOR | Create vector catalog] **************************
changed: [instance]

TASK [reivol.vector : VECTOR | Create vector config dir] ***********************
changed: [instance]

TASK [reivol.vector : VECTOR | Config vector j2 template] **********************
changed: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=9    changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running compatibility > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '440918403233.19084', 'results_file': '/root/.ansible_async/440918403233.19084', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
____________________________________________________________________________________________ summary ____________________________________________________________________________________________
  py37-ansible50: commands succeeded
  py39-ansible50: commands succeeded
  congratulations :)
```  

</details>


11. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

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
