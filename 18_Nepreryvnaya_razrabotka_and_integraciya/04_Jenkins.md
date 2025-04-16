# Домашнее задание к занятию 10 «Jenkins» - `Арзыбов Владислав`

## Подготовка к выполнению

1. Создать два VM: для jenkins-master и jenkins-agent.

![изображение](https://github.com/user-attachments/assets/9957ec37-7bc7-41fe-a00c-a0b91b8cb7bd)
  
2. Установить Jenkins при помощи playbook.

![изображение](https://github.com/user-attachments/assets/8bf892df-cd79-489a-9176-e5b987761fb4)

3. Запустить и проверить работоспособность.

![изображение](https://github.com/user-attachments/assets/51e5186c-4231-49e4-b5fd-3e289a1ae0b6)

4. Сделать первоначальную настройку.

![изображение](https://github.com/user-attachments/assets/b2965aea-b72f-48bc-a169-6bd34cefeade)


## Основная часть

1. Сделать Freestyle Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.

<details>
  <summary>Freestyle Job</summary>

![изображение](https://github.com/user-attachments/assets/6a93b04f-706d-45e0-bd22-b203c779c026)

![изображение](https://github.com/user-attachments/assets/a68b667d-dd14-461b-a438-81b5abdc5b22)

![изображение](https://github.com/user-attachments/assets/856db3da-e2a2-42ee-8315-cbdca36db809)

![изображение](https://github.com/user-attachments/assets/722d0c0c-84ac-420e-9427-95c592046bda)

![изображение](https://github.com/user-attachments/assets/a0ba9f03-3e4f-43ba-8c2a-6a3cc6fe1b25)

</details>



<details>
  <summary>Freestyle Job build log</summary>

  ```bash
Started by user ReiVol
Running as SYSTEM
Building remotely on agent (linux ansible) in workspace /opt/jenkins_agent/workspace/Freestyle_Job
The recommended git tool is: NONE
No credentials specified
 > git rev-parse --resolve-git-dir /opt/jenkins_agent/workspace/Freestyle_Job/.git # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url https://github.com/vladislav-arzybov/vector-role.git # timeout=10
Fetching upstream changes from https://github.com/vladislav-arzybov/vector-role.git
 > git --version # timeout=10
 > git --version # 'git version 2.47.1'
 > git fetch --tags --force --progress -- https://github.com/vladislav-arzybov/vector-role.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
Checking out Revision e1488f4f5562b3825e3a43d28def312b4625616b (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f e1488f4f5562b3825e3a43d28def312b4625616b # timeout=10
Commit message: "tox"
First time build. Skipping changelog.
[Freestyle_Job] $ /bin/sh -xe /tmp/jenkins12191725504154432845.sh
+ molecule test
WARNING  Driver docker does not provide a schema.
INFO     default scenario test matrix: dependency, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
WARNING  Another version of 'ansible.posix' 1.1.1 was found installed in /usr/local/lib/python3.9/site-packages/ansible_collections, only the first one will be used, 2.0.0 (/home/jenkins/.ansible/collections/ansible_collections).
WARNING  Another version of 'community.docker' 1.2.2 was found installed in /usr/local/lib/python3.9/site-packages/ansible_collections, only the first one will be used, 4.5.2 (/home/jenkins/.ansible/collections/ansible_collections).
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

playbook: /opt/jenkins_agent/workspace/Freestyle_Job/molecule/default/converge.yml
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
changed: [localhost] => (item=ubuntu)
changed: [localhost] => (item=oraclelinux8)

PLAY RECAP *********************************************************************
localhost                  : ok=6    changed=2    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Include vector] **********************************************************

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
changed: [oraclelinux8]
changed: [ubuntu]

TASK [reivol.vector : VECTOR | Copy systemd service vector] ********************
changed: [oraclelinux8]
changed: [ubuntu]

TASK [reivol.vector : VECTOR | Create user vector] *****************************
changed: [oraclelinux8]
changed: [ubuntu]

TASK [reivol.vector : VECTOR | Create vector catalog] **************************
changed: [oraclelinux8]
changed: [ubuntu]

TASK [reivol.vector : VECTOR | Create vector config dir] ***********************
changed: [oraclelinux8]
changed: [ubuntu]

TASK [reivol.vector : VECTOR | Config vector j2 template] **********************
changed: [oraclelinux8]
changed: [ubuntu]

PLAY RECAP *********************************************************************
oraclelinux8               : ok=9    changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=9    changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running default > idempotence

PLAY [Converge] ****************************************************************

TASK [Include vector] **********************************************************

TASK [reivol.vector : VECTOR | Create dir] *************************************
ok: [oraclelinux8]
ok: [ubuntu]

TASK [reivol.vector : VECTOR | Get vector distrib] *****************************
ok: [ubuntu]
ok: [oraclelinux8]

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
oraclelinux8               : ok=9    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=9    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running default > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running default > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Ansible check file exists.] **********************************************
ok: [oraclelinux8]
ok: [ubuntu]

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
ok: [oraclelinux8]
ok: [ubuntu]

TASK [debug] *******************************************************************
ok: [oraclelinux8] => {
    "service_status.status.ActiveState": "inactive"
}
ok: [ubuntu] => {
    "service_status.status.ActiveState": "inactive"
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
changed: [localhost] => (item=ubuntu)
changed: [localhost] => (item=oraclelinux8)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
Finished: SUCCESS

```  

</details>

3. Сделать Declarative Pipeline Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
4. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`.
5. Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.
6. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](https://github.com/netology-code/mnt-homeworks/blob/MNT-video/09-ci-04-jenkins/pipeline).
7. Внести необходимые изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен параметр при запуске джобы (prod_run = True). По умолчанию параметр имеет значение False и запускает прогон с флагами `--check --diff`.
8. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл `ScriptedJenkinsfile`.
9. Отправить ссылку на репозиторий с ролью и Declarative Pipeline и Scripted Pipeline.
10. Сопроводите процесс настройки скриншотами для каждого пункта задания!!

## Необязательная часть

1. Создать скрипт на groovy, который будет собирать все Job, завершившиеся хотя бы раз неуспешно. Добавить скрипт в репозиторий с решением и названием `AllJobFailure.groovy`.
2. Создать Scripted Pipeline так, чтобы он мог сначала запустить через Yandex Cloud CLI необходимое количество инстансов, прописать их в инвентори плейбука и после этого запускать плейбук. Мы должны при нажатии кнопки получить готовую к использованию систему.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
