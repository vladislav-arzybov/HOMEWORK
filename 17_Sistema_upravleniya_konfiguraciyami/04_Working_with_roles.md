# Домашнее задание к занятию 4 «Работа с roles» - `Арзыбов Владислав`

## Подготовка к выполнению

1. * Необязательно. Познакомьтесь с [LightHouse](https://youtu.be/ymlrNlaHzIY?t=929).
2. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.

- git@github.com:vladislav-arzybov/vector-role.git
- git@github.com:vladislav-arzybov/lighthouse-role.git

3. Добавьте публичную часть своего ключа к своему профилю на GitHub.

## Основная часть

Ваша цель — разбить ваш playbook на отдельные roles. 

Задача — сделать roles для ClickHouse, Vector и LightHouse и написать playbook для использования этих ролей. 

Ожидаемый результат — существуют три ваших репозитория: два с roles и один с playbook.

**Что нужно сделать**

1. Создайте в старой версии playbook файл `requirements.yml` и заполните его содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.13"
       name: clickhouse 
   ```

2. При помощи `ansible-galaxy` скачайте себе эту роль.

![изображение](https://github.com/user-attachments/assets/81fc4e3b-42bc-4f5c-9b30-02f26c6309cf)

3. Создайте новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.

![изображение](https://github.com/user-attachments/assets/43afb532-e91e-40be-939c-a81a9b0d52d4)

4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Опишите в `README.md` обе роли и их параметры. Пример качественной документации ansible role [по ссылке](https://github.com/cloudalchemy/ansible-prometheus).
7. Повторите шаги 3–6 для LightHouse. Помните, что одна роль должна настраивать один продукт.

![изображение](https://github.com/user-attachments/assets/e473b03f-5fcc-4ddf-9ece-74599c426852)

8. Выложите все roles в репозитории. Проставьте теги, используя семантическую нумерацию. Добавьте roles в `requirements.yml` в playbook.

```
  - name: vector-role
    src: git@github.com:vladislav-arzybov/vector-role.git
    scm: git
    version: "1.0.0"
  - name: lighthouse-role
    src: git@github.com:vladislav-arzybov/lighthouse-role.git
    scm: git
    version: "1.0.0"
```

![изображение](https://github.com/user-attachments/assets/07b1ead9-19fa-44c4-845e-e6127232eaee)

9. Переработайте playbook на использование roles. Не забудьте про зависимости LightHouse и возможности совмещения `roles` с `tasks`.

<details>
  <summary>ansible-playbook_site.yml</summary>
```
reivol@Zabbix:~/GitHub/mnt-homeworks/08-ansible-02-playbook/playbooks$ ansible-playbook -i inventory/prod.yml site.yml

PLAY [Install Clickhouse] ***********************************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Include OS Family Specific Variables] ****************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : include_tasks] ***************************************************************************************************************************************************************
included: /home/reivol/GitHub/mnt-homeworks/08-ansible-02-playbook/playbooks/roles/clickhouse/tasks/precheck.yml for clickhouse-01

TASK [clickhouse : Requirements check | Checking sse4_2 support] ********************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Requirements check | Not supported distribution && release] ******************************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : include_tasks] ***************************************************************************************************************************************************************
included: /home/reivol/GitHub/mnt-homeworks/08-ansible-02-playbook/playbooks/roles/clickhouse/tasks/params.yml for clickhouse-01

TASK [clickhouse : Set clickhouse_service_enable] ***********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Set clickhouse_service_ensure] ***********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : include_tasks] ***************************************************************************************************************************************************************
included: /home/reivol/GitHub/mnt-homeworks/08-ansible-02-playbook/playbooks/roles/clickhouse/tasks/install/yum.yml for clickhouse-01

TASK [clickhouse : Install by YUM | Ensure clickhouse repo installed] ***************************************************************************************************************************
changed: [clickhouse-01]

TASK [clickhouse : Install by YUM | Ensure clickhouse package installed (latest)] ***************************************************************************************************************
changed: [clickhouse-01]

TASK [clickhouse : Install by YUM | Ensure clickhouse package installed (version latest)] *******************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : include_tasks] ***************************************************************************************************************************************************************
included: /home/reivol/GitHub/mnt-homeworks/08-ansible-02-playbook/playbooks/roles/clickhouse/tasks/configure/sys.yml for clickhouse-01

TASK [clickhouse : Check clickhouse config, data and logs] **************************************************************************************************************************************
ok: [clickhouse-01] => (item=/var/log/clickhouse-server)
changed: [clickhouse-01] => (item=/etc/clickhouse-server)
changed: [clickhouse-01] => (item=/var/lib/clickhouse/tmp/)
changed: [clickhouse-01] => (item=/var/lib/clickhouse/)

TASK [clickhouse : Config | Create config.d folder] *********************************************************************************************************************************************
changed: [clickhouse-01]

TASK [clickhouse : Config | Create users.d folder] **********************************************************************************************************************************************
changed: [clickhouse-01]

TASK [clickhouse : Config | Generate system config] *********************************************************************************************************************************************
changed: [clickhouse-01]

TASK [clickhouse : Config | Generate users config] **********************************************************************************************************************************************
changed: [clickhouse-01]

TASK [clickhouse : Config | Generate remote_servers config] *************************************************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Config | Generate macros config] *********************************************************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Config | Generate zookeeper servers config] **********************************************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Config | Fix interserver_http_port and intersever_https_port collision] ******************************************************************************************************
skipping: [clickhouse-01]

RUNNING HANDLER [clickhouse : Restart Clickhouse Service] ***************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : include_tasks] ***************************************************************************************************************************************************************
included: /home/reivol/GitHub/mnt-homeworks/08-ansible-02-playbook/playbooks/roles/clickhouse/tasks/service.yml for clickhouse-01

TASK [clickhouse : Ensure clickhouse-server.service is enabled: True and state: restarted] ******************************************************************************************************
changed: [clickhouse-01]

TASK [clickhouse : Wait for Clickhouse Server to Become Ready] **********************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : include_tasks] ***************************************************************************************************************************************************************
included: /home/reivol/GitHub/mnt-homeworks/08-ansible-02-playbook/playbooks/roles/clickhouse/tasks/configure/db.yml for clickhouse-01

TASK [clickhouse : Set ClickHose Connection String] *********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Gather list of existing databases] *******************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Config | Delete database config] *********************************************************************************************************************************************

TASK [clickhouse : Config | Create database config] *********************************************************************************************************************************************

TASK [clickhouse : include_tasks] ***************************************************************************************************************************************************************
included: /home/reivol/GitHub/mnt-homeworks/08-ansible-02-playbook/playbooks/roles/clickhouse/tasks/configure/dict.yml for clickhouse-01

TASK [clickhouse : Config | Generate dictionary config] *****************************************************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : include_tasks] ***************************************************************************************************************************************************************
skipping: [clickhouse-01]

PLAY [Install Vector] ***************************************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************************
ok: [vector-01]

TASK [vector-role : VECTOR | Create dir] ********************************************************************************************************************************************************
changed: [vector-01]

TASK [vector-role : VECTOR | Get vector distrib] ************************************************************************************************************************************************
changed: [vector-01]

TASK [vector-role : VECTOR | Unarchive vector] **************************************************************************************************************************************************
changed: [vector-01]

TASK [vector-role : VECTOR | Copy bin file vector] **********************************************************************************************************************************************
changed: [vector-01]

TASK [vector-role : VECTOR | Copy systemd service vector] ***************************************************************************************************************************************
changed: [vector-01]

TASK [vector-role : VECTOR | Create user vector] ************************************************************************************************************************************************
changed: [vector-01]

TASK [vector-role : VECTOR | Create vector catalog] *********************************************************************************************************************************************
changed: [vector-01]

TASK [vector-role : VECTOR | Create default vector config catalog and vector.toml] **************************************************************************************************************
changed: [vector-01]

TASK [vector-role : VECTOR | Config vector j2 template] *****************************************************************************************************************************************
changed: [vector-01]

RUNNING HANDLER [vector-role : Start vector service] ********************************************************************************************************************************************
changed: [vector-01]

PLAY [Install lighthouse] ***********************************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [LIGHTHOUSE | Install git] *****************************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [lighthouse-role : LIGHTHOUSE | Get distrib] ***********************************************************************************************************************************************
changed: [lighthouse-01]

TASK [lighthouse-role : NGINX | Install epel-release] *******************************************************************************************************************************************
changed: [lighthouse-01]

TASK [lighthouse-role : NGINX | Install nginx] **************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [lighthouse-role : NGINX | Configure nginx config for site] ********************************************************************************************************************************
changed: [lighthouse-01]

TASK [lighthouse-role : NGINX | Make config for lighthouse] *************************************************************************************************************************************
changed: [lighthouse-01]

RUNNING HANDLER [lighthouse-role : start nginx] *************************************************************************************************************************************************
changed: [lighthouse-01]

RUNNING HANDLER [lighthouse-role : restart nginx] ***********************************************************************************************************************************************
changed: [lighthouse-01]

PLAY RECAP **************************************************************************************************************************************************************************************
clickhouse-01              : ok=24   changed=8    unreachable=0    failed=0    skipped=10   rescued=0    ignored=0   
lighthouse-01              : ok=9    changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=11   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```  
</details>

![изображение](https://github.com/user-attachments/assets/9409863f-4a8e-4601-bc9d-6ee0d766948c)


11. Выложите playbook в репозиторий.
12. В ответе дайте ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
