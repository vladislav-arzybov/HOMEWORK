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

```groovy
pipeline{
    agent {
  label 'ansible'
    }
    stages {
        stage('Clear_Start') {
            steps {
                deleteDir()
            }
        }
        stage('Git') {
            steps {
                git branch: 'main', url: 'https://github.com/vladislav-arzybov/vector-role.git'
            }
        }
                stage('Test') {
            steps {
                sh 'molecule test'
            }
        }
                stage('Clear_Final') {
            steps {
                deleteDir()
            }
        }
    }
}
```

![изображение](https://github.com/user-attachments/assets/5b1fe6b6-80db-4030-9413-7ea47250042f)

![изображение](https://github.com/user-attachments/assets/0db1d25d-e0d8-4bcf-8038-f4017a480e48)


<details>
  <summary>Declarative Pipeline Job build log</summary>

  ```bash
Started by user ReiVol
[Pipeline] Start of Pipeline
[Pipeline] node
Running on agent in /opt/jenkins_agent/workspace/Declarative_Pipeline_Job
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Clear_Start)
[Pipeline] deleteDir
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Git)
[Pipeline] git
The recommended git tool is: NONE
No credentials specified
Cloning the remote Git repository
Avoid second fetch
Checking out Revision e1488f4f5562b3825e3a43d28def312b4625616b (refs/remotes/origin/main)
Commit message: "tox"
First time build. Skipping changelog.
Cloning repository https://github.com/vladislav-arzybov/vector-role.git
 > git init /opt/jenkins_agent/workspace/Declarative_Pipeline_Job # timeout=10
Fetching upstream changes from https://github.com/vladislav-arzybov/vector-role.git
 > git --version # timeout=10
 > git --version # 'git version 2.47.1'
 > git fetch --tags --force --progress -- https://github.com/vladislav-arzybov/vector-role.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git config remote.origin.url https://github.com/vladislav-arzybov/vector-role.git # timeout=10
 > git config --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
 > git config core.sparsecheckout # timeout=10
 > git checkout -f e1488f4f5562b3825e3a43d28def312b4625616b # timeout=10
 > git branch -a -v --no-abbrev # timeout=10
 > git checkout -b main e1488f4f5562b3825e3a43d28def312b4625616b # timeout=10
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Test)
[Pipeline] sh
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

playbook: /opt/jenkins_agent/workspace/Declarative_Pipeline_Job/molecule/default/converge.yml
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

TASK [reivol.vector : VECTOR | Create dir] *************************************
changed: [ubuntu]
changed: [oraclelinux8]

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
changed: [oraclelinux8]
changed: [ubuntu]

TASK [reivol.vector : VECTOR | Create user vector] *****************************
changed: [oraclelinux8]
changed: [ubuntu]

TASK [reivol.vector : VECTOR | Create vector catalog] **************************
changed: [oraclelinux8]
changed: [ubuntu]

TASK [reivol.vector : VECTOR | Create vector config dir] ***********************
changed: [ubuntu]
changed: [oraclelinux8]

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
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=ubuntu)
changed: [localhost] => (item=oraclelinux8)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Clear_Final)
[Pipeline] deleteDir
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
```  

</details>
  
5. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`.

[Jenkinsfile](https://github.com/vladislav-arzybov/vector-role/blob/main/Jenkinsfile)

7. Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.

<details>
  <summary>Multibranch Pipeline</summary>

![изображение](https://github.com/user-attachments/assets/caafdd07-6c80-46dc-a737-800c3ed29c22)

![изображение](https://github.com/user-attachments/assets/ba91d92b-a655-439f-b6b8-f40b9d4a9ca0)

![изображение](https://github.com/user-attachments/assets/7b8361de-cbaa-4e39-8007-c977e183ce82)

![изображение](https://github.com/user-attachments/assets/49e33a4f-905c-441d-98ff-e4a099b55de6)

</details>

<details>
  <summary>Multibranch Pipeline build log</summary>

  ```bash
Branch indexing
 > git rev-parse --resolve-git-dir /var/lib/jenkins/caches/git-c98f5ca7351dcde42436d885864b3eda/.git # timeout=10
Setting origin to https://github.com/vladislav-arzybov/vector-role.git
 > git config remote.origin.url https://github.com/vladislav-arzybov/vector-role.git # timeout=10
Fetching origin...
Fetching upstream changes from origin
 > git --version # timeout=10
 > git --version # 'git version 2.47.1'
 > git config --get remote.origin.url # timeout=10
 > git fetch --tags --force --progress -- origin +refs/heads/*:refs/remotes/origin/* # timeout=10
Seen branch in repository origin/main
Seen 1 remote branch
Obtained Jenkinsfile from ee1edef52737966e8410baf53ba4fcae3aae35c4
[Pipeline] Start of Pipeline
[Pipeline] node
Running on agent in /opt/jenkins_agent/workspace/Multibranch_Pipeline_main
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Declarative: Checkout SCM)
[Pipeline] checkout
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
No credentials specified
Cloning the remote Git repository
Cloning with configured refspecs honoured and without tags
Avoid second fetch
Checking out Revision ee1edef52737966e8410baf53ba4fcae3aae35c4 (main)
Commit message: "Create Jenkinsfile"
First time build. Skipping changelog.
Cloning repository https://github.com/vladislav-arzybov/vector-role.git
 > git init /opt/jenkins_agent/workspace/Multibranch_Pipeline_main # timeout=10
Fetching upstream changes from https://github.com/vladislav-arzybov/vector-role.git
 > git --version # timeout=10
 > git --version # 'git version 2.47.1'
 > git fetch --no-tags --force --progress -- https://github.com/vladislav-arzybov/vector-role.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git config remote.origin.url https://github.com/vladislav-arzybov/vector-role.git # timeout=10
 > git config --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git config core.sparsecheckout # timeout=10
 > git checkout -f ee1edef52737966e8410baf53ba4fcae3aae35c4 # timeout=10
[Pipeline] }
[Pipeline] // stage
[Pipeline] withEnv
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Clear_Start)
[Pipeline] deleteDir
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Git)
[Pipeline] git
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
No credentials specified
Cloning the remote Git repository
Cloning repository https://github.com/vladislav-arzybov/vector-role.git
 > git init /opt/jenkins_agent/workspace/Multibranch_Pipeline_main # timeout=10
Fetching upstream changes from https://github.com/vladislav-arzybov/vector-role.git
 > git --version # timeout=10
 > git --version # 'git version 2.47.1'
 > git fetch --tags --force --progress -- https://github.com/vladislav-arzybov/vector-role.git +refs/heads/*:refs/remotes/origin/* # timeout=10
Avoid second fetch
Checking out Revision ee1edef52737966e8410baf53ba4fcae3aae35c4 (refs/remotes/origin/main)
Commit message: "Create Jenkinsfile"
 > git config remote.origin.url https://github.com/vladislav-arzybov/vector-role.git # timeout=10
 > git config --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
 > git config core.sparsecheckout # timeout=10
 > git checkout -f ee1edef52737966e8410baf53ba4fcae3aae35c4 # timeout=10
 > git branch -a -v --no-abbrev # timeout=10
 > git checkout -b main ee1edef52737966e8410baf53ba4fcae3aae35c4 # timeout=10
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Test)
[Pipeline] sh
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

playbook: /opt/jenkins_agent/workspace/Multibranch_Pipeline_main/molecule/default/converge.yml
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

TASK [reivol.vector : VECTOR | Create dir] *************************************
changed: [oraclelinux8]
changed: [ubuntu]

TASK [reivol.vector : VECTOR | Get vector distrib] *****************************
changed: [ubuntu]
changed: [oraclelinux8]

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
changed: [ubuntu]
changed: [oraclelinux8]

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
ok: [oraclelinux8]
ok: [ubuntu]

TASK [reivol.vector : VECTOR | Unarchive vector] *******************************
ok: [oraclelinux8]
ok: [ubuntu]

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
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Clear_Final)
[Pipeline] deleteDir
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
```  

</details>

9. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](https://github.com/netology-code/mnt-homeworks/blob/MNT-video/09-ci-04-jenkins/pipeline).

```
node("linux"){
    stage("Git checkout"){
        git branch: 'master', url: 'https://github.com/aragastmatb/example-playbook.git'
    }
    stage("Sample define secret_check"){
        secret_check=true
    }
    stage("Run playbook"){
        if (params.prod_run){
            sh 'ansible-playbook site.yml -i inventory/prod.yml'
        }
        else{
            sh 'ansible-playbook site.yml -i inventory/prod.yml --check --diff'
        }
        
    }
}
```

11. Внести необходимые изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен параметр при запуске джобы (prod_run = True). По умолчанию параметр имеет значение False и запускает прогон с флагами `--check --diff`.

![изображение](https://github.com/user-attachments/assets/47b36541-c09a-42bf-bd3f-52bdc2cd8339)

![изображение](https://github.com/user-attachments/assets/9f6d24d2-8a00-452c-b98f-37edc2c79568)

<details>
  <summary>Scripted Pipeline prod_run = False </summary>
```
Started by user ReiVol
[Pipeline] Start of Pipeline
[Pipeline] node
Running on agent in /opt/jenkins_agent/workspace/Scripted_Pipeline
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Git checkout)
[Pipeline] git
The recommended git tool is: NONE
No credentials specified
Fetching changes from the remote Git repository
 > git rev-parse --resolve-git-dir /opt/jenkins_agent/workspace/Scripted_Pipeline/.git # timeout=10
 > git config remote.origin.url https://github.com/aragastmatb/example-playbook.git # timeout=10
Fetching upstream changes from https://github.com/aragastmatb/example-playbook.git
 > git --version # timeout=10
 > git --version # 'git version 2.47.1'
 > git fetch --tags --force --progress -- https://github.com/aragastmatb/example-playbook.git +refs/heads/*:refs/remotes/origin/* # timeout=10
Checking out Revision 20bd8d945340bb742acdd9e8c1a8fb5b73cc1700 (refs/remotes/origin/master)
Commit message: "Merge branch 'master' of https://github.com/aragastmatb/example-playbook"
 > git rev-parse refs/remotes/origin/master^{commit} # timeout=10
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 20bd8d945340bb742acdd9e8c1a8fb5b73cc1700 # timeout=10
 > git branch -a -v --no-abbrev # timeout=10
 > git branch -D master # timeout=10
 > git checkout -b master 20bd8d945340bb742acdd9e8c1a8fb5b73cc1700 # timeout=10
 > git rev-list --no-walk 20bd8d945340bb742acdd9e8c1a8fb5b73cc1700 # timeout=10
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Sample define secret_check)
Did you forget the `def` keyword? WorkflowScript seems to be setting a field named secret_check (to a value of type Boolean) which could lead to memory leaks or other issues.
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Run playbook)
[Pipeline] sh
+ ansible-playbook site.yml -i inventory/prod.yml --check --diff

PLAY [Install Java] ************************************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [java : Upload .tar.gz file containing binaries from local storage] *******
skipping: [localhost]

TASK [java : Upload .tar.gz file conaining binaries from remote storage] *******
ok: [localhost]

TASK [java : Ensure installation dir exists] ***********************************
ok: [localhost]

TASK [java : Extract java in the installation directory] ***********************
skipping: [localhost]

TASK [java : Export environment variables] *************************************
ok: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=4    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   

[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
```
</details>  

<details>
  <summary>Scripted Pipeline prod_run = True </summary>

```
Started by user ReiVol
[Pipeline] Start of Pipeline
[Pipeline] node
Running on agent in /opt/jenkins_agent/workspace/Scripted_Pipeline
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Git checkout)
[Pipeline] git
The recommended git tool is: NONE
No credentials specified
Fetching changes from the remote Git repository
Checking out Revision 20bd8d945340bb742acdd9e8c1a8fb5b73cc1700 (refs/remotes/origin/master)
Commit message: "Merge branch 'master' of https://github.com/aragastmatb/example-playbook"
 > git rev-parse --resolve-git-dir /opt/jenkins_agent/workspace/Scripted_Pipeline/.git # timeout=10
 > git config remote.origin.url https://github.com/aragastmatb/example-playbook.git # timeout=10
Fetching upstream changes from https://github.com/aragastmatb/example-playbook.git
 > git --version # timeout=10
 > git --version # 'git version 2.47.1'
 > git fetch --tags --force --progress -- https://github.com/aragastmatb/example-playbook.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/master^{commit} # timeout=10
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 20bd8d945340bb742acdd9e8c1a8fb5b73cc1700 # timeout=10
 > git branch -a -v --no-abbrev # timeout=10
 > git branch -D master # timeout=10
 > git checkout -b master 20bd8d945340bb742acdd9e8c1a8fb5b73cc1700 # timeout=10
 > git rev-list --no-walk 20bd8d945340bb742acdd9e8c1a8fb5b73cc1700 # timeout=10
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Sample define secret_check)
Did you forget the `def` keyword? WorkflowScript seems to be setting a field named secret_check (to a value of type Boolean) which could lead to memory leaks or other issues.
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Run playbook)
[Pipeline] sh
+ ansible-playbook site.yml -i inventory/prod.yml

PLAY [Install Java] ************************************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [java : Upload .tar.gz file containing binaries from local storage] *******
skipping: [localhost]

TASK [java : Upload .tar.gz file conaining binaries from remote storage] *******
ok: [localhost]

TASK [java : Ensure installation dir exists] ***********************************
ok: [localhost]

TASK [java : Extract java in the installation directory] ***********************
skipping: [localhost]

TASK [java : Export environment variables] *************************************
ok: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=4    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   

[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
```

</details>  



12. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл `ScriptedJenkinsfile`.

[ScriptedJenkinsfile](https://github.com/vladislav-arzybov/vector-role/blob/main/ScriptedJenkinsfile)

13. Отправить ссылку на репозиторий с ролью и Declarative Pipeline и Scripted Pipeline.

[vector-role](https://github.com/vladislav-arzybov/vector-role.git)

15. Сопроводите процесс настройки скриншотами для каждого пункта задания!!

## Необязательная часть

1. Создать скрипт на groovy, который будет собирать все Job, завершившиеся хотя бы раз неуспешно. Добавить скрипт в репозиторий с решением и названием `AllJobFailure.groovy`.
2. Создать Scripted Pipeline так, чтобы он мог сначала запустить через Yandex Cloud CLI необходимое количество инстансов, прописать их в инвентори плейбука и после этого запускать плейбук. Мы должны при нажатии кнопки получить готовую к использованию систему.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
