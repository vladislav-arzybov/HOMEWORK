# Домашнее задание к занятию 6 «Создание собственных модулей» - `Арзыбов Владислав`

## Подготовка к выполнению

1. Создайте пустой публичный репозиторий в своём любом проекте: `my_own_collection`.

- https://github.com/vladislav-arzybov/my_own_collection.git

2. Скачайте репозиторий Ansible: `git clone https://github.com/ansible/ansible.git` по любому, удобному вам пути.

![изображение](https://github.com/user-attachments/assets/762d74c3-ba45-450c-a9c1-1b51c99c5222)

3. Зайдите в директорию Ansible: `cd ansible`.

![изображение](https://github.com/user-attachments/assets/a087cb87-5466-47a0-999d-2f89a3daa2cc)

4. Создайте виртуальное окружение: `python3 -m venv venv`.

![изображение](https://github.com/user-attachments/assets/4f4121e1-64b5-4fa7-ab8d-fc340469dbc6)

5. Активируйте виртуальное окружение: `. venv/bin/activate`. Дальнейшие действия производятся только в виртуальном окружении.

![изображение](https://github.com/user-attachments/assets/d49ee989-1cd9-4b68-8eee-f2963833aec6)

6. Установите зависимости `pip install -r requirements.txt`.

![изображение](https://github.com/user-attachments/assets/38943086-6c80-445c-aa67-400c9678fe2f)

7. Запустите настройку окружения `. hacking/env-setup`.

![изображение](https://github.com/user-attachments/assets/479ae1c1-4f06-40bd-9cbf-045ae95ad17f)

8. Если все шаги прошли успешно — выйдите из виртуального окружения `deactivate`.

![изображение](https://github.com/user-attachments/assets/cc9198ab-e30f-43f9-a5fa-9580fc78f8d8)

9. Ваше окружение настроено. Чтобы запустить его, нужно находиться в директории `ansible` и выполнить конструкцию `. venv/bin/activate && . hacking/env-setup`.

![изображение](https://github.com/user-attachments/assets/821ac079-6e46-4937-abb5-fd4a20391b0b)



## Основная часть

Ваша цель — написать собственный module, который вы можете использовать в своей role через playbook. Всё это должно быть собрано в виде collection и отправлено в ваш репозиторий.

**Шаг 1.** В виртуальном окружении создайте новый `my_own_module.py` файл.

![изображение](https://github.com/user-attachments/assets/aed96e9e-78b3-457e-9c12-4d2d715661e6)

**Шаг 2.** Наполните его содержимым:

```python
#!/usr/bin/python

# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: my_test

short_description: This is my test module

# If this is part of a collection, you need to use semantic versioning,
# i.e. the version is of the form "2.5.0" and not "2.4".
version_added: "1.0.0"

description: This is my longer description explaining my test module.

options:
    name:
        description: This is the message to send to the test module.
        required: true
        type: str
    new:
        description:
            - Control to demo if the result of this module is changed or not.
            - Parameter description can be a list as well.
        required: false
        type: bool
# Specify this value according to your collection
# in format of namespace.collection.doc_fragment_name
extends_documentation_fragment:
    - my_namespace.my_collection.my_doc_fragment_name

author:
    - Your Name (@yourGitHubHandle)
'''

EXAMPLES = r'''
# Pass in a message
- name: Test with a message
  my_namespace.my_collection.my_test:
    name: hello world

# pass in a message and have changed true
- name: Test with a message and changed output
  my_namespace.my_collection.my_test:
    name: hello world
    new: true

# fail the module
- name: Test failure of the module
  my_namespace.my_collection.my_test:
    name: fail me
'''

RETURN = r'''
# These are examples of possible return values, and in general should use other names for return values.
original_message:
    description: The original name param that was passed in.
    type: str
    returned: always
    sample: 'hello world'
message:
    description: The output message that the test module generates.
    type: str
    returned: always
    sample: 'goodbye'
'''

from ansible.module_utils.basic import AnsibleModule


def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        name=dict(type='str', required=True),
        new=dict(type='bool', required=False, default=False)
    )

    # seed the result dict in the object
    # we primarily care about changed and state
    # changed is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(
        changed=False,
        original_message='',
        message=''
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        module.exit_json(**result)

    # manipulate or modify the state as needed (this is going to be the
    # part where your module will do what it needs to do)
    result['original_message'] = module.params['name']
    result['message'] = 'goodbye'

    # use whatever logic you need to determine whether or not this module
    # made any modifications to your target
    if module.params['new']:
        result['changed'] = True

    # during the execution of the module, if there is an exception or a
    # conditional state that effectively causes a failure, run
    # AnsibleModule.fail_json() to pass in the message and the result
    if module.params['name'] == 'fail me':
        module.fail_json(msg='You requested this to fail', **result)

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
```
Или возьмите это наполнение [из статьи](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html#creating-a-module).

**Шаг 3.** Заполните файл в соответствии с требованиями Ansible так, чтобы он выполнял основную задачу: module должен создавать текстовый файл на удалённом хосте по пути, определённом в параметре `path`, с содержимым, определённым в параметре `content`.

**Шаг 4.** Проверьте module на исполняемость локально.

Для проверки через python создадим файл payload.json со всеми необходимыми входящими аргументами:

```
{
    "ANSIBLE_MODULE_ARGS": {
        "path": "test_file.txt",
        "content": "Hello!"
    }
}
```

Файл test_file.txt был спешно создан с содержимым ```Hello!```, при повторном запуске изменений произведено не было.

![изображение](https://github.com/user-attachments/assets/e81aad48-fb6b-41bd-ad37-203ee8d6d96e)

**Шаг 5.** Напишите single task playbook и используйте module в нём.

```
---
- name: Test my_own_module
  hosts: localhost
  tasks:
    - name: Call my_own_module
      my_own_module:
        path: "./test_file.txt"
        content: "Hello!"
```

- ansible-playbook site.yml -v

![изображение](https://github.com/user-attachments/assets/d3d2000b-b075-4cdd-a8af-588fea4a7c2c)

**Шаг 6.** Проверьте через playbook на идемпотентность.

- ansible-playbook site.yml --diff

![изображение](https://github.com/user-attachments/assets/1da748cd-9072-411c-a768-0c8e20bf883d)

**Шаг 7.** Выйдите из виртуального окружения.

![изображение](https://github.com/user-attachments/assets/f4ffa90a-0b6f-4c5c-933f-9a39a525dbc2)

**Шаг 8.** Инициализируйте новую collection: `ansible-galaxy collection init my_own_namespace.yandex_cloud_elk`.

![изображение](https://github.com/user-attachments/assets/1f7d7635-4a8f-4574-bf32-0c4224a54319)

**Шаг 9.** В эту collection перенесите свой module в соответствующую директорию.

![изображение](https://github.com/user-attachments/assets/4b6304ad-b041-494b-b4fd-632f6224cdec)

**Шаг 10.** Single task playbook преобразуйте в single task role и перенесите в collection. У role должны быть default всех параметров module.

![изображение](https://github.com/user-attachments/assets/880a6d8d-a363-429a-b78c-7bbc37041c7f)

**Шаг 11.** Создайте playbook для использования этой role.

```
---
- name: Test my_own_module
  hosts: localhost
  roles:
    - my_own_role
```

**Шаг 12.** Заполните всю документацию по collection, выложите в свой репозиторий, поставьте тег `1.0.0` на этот коммит.

[my_own_collection](https://github.com/vladislav-arzybov/my_own_collection/tree/main/yandex_cloud_elk)

**Шаг 13.** Создайте .tar.gz этой collection: `ansible-galaxy collection build` в корневой директории collection.

![изображение](https://github.com/user-attachments/assets/37fe617d-a767-4a29-b1d2-a0caaefdd53c)

**Шаг 14.** Создайте ещё одну директорию любого наименования, перенесите туда single task playbook и архив c collection.

![изображение](https://github.com/user-attachments/assets/90bb8cff-1d30-4e07-bf67-a86044eb56b9)

**Шаг 15.** Установите collection из локального архива: `ansible-galaxy collection install <archivename>.tar.gz`.

![изображение](https://github.com/user-attachments/assets/5d50873a-b87b-46ca-bca8-a5b27eb4a6f1)

**Шаг 16.** Запустите playbook, убедитесь, что он работает.

```
---
- name: Test my_own_module
  hosts: localhost
  collections:
    - my_own_namespace.yandex_cloud_elk
  roles:
    - my_own_role
```

или

```
---
- name: Test my_own_module
  hosts: localhost
  roles:
    - my_own_namespace.yandex_cloud_elk.my_own_role
```

![изображение](https://github.com/user-attachments/assets/d4d3186a-1352-4f71-810f-c9e744a87e68)

Повторный запуск для проверки идемпотентности:

![изображение](https://github.com/user-attachments/assets/87c89b84-d8bc-494d-9ed4-fe3882d2f359)

Проверяем что файл создан:

![изображение](https://github.com/user-attachments/assets/33ab0e56-bc91-4c5f-aace-402d2cb71a1e)

**Шаг 17.** В ответ необходимо прислать ссылки на collection и tar.gz архив, а также скриншоты выполнения пунктов 4, 6, 15 и 16.

[my_own_collection](https://github.com/vladislav-arzybov/my_own_collection/tree/main/yandex_cloud_elk)

[my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/17_Sistema_upravleniya_konfiguraciyami/my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz)

### Если передать другой контент, то файл в итоге его получает?

Запускаем плейбук, создается файл с содержимым указанным в content из default переменных: 

![изображение](https://github.com/user-attachments/assets/7d4404ac-eddf-4886-911d-f92941c157db)

Меняем значение переменной в роли на Test2:

![изображение](https://github.com/user-attachments/assets/419a9887-41c6-498d-9c9c-f97133f6e96f)

Повторно выполняем запуск плейбука (полный скрин окна с логом выполнения первого создания файла):

![изображение](https://github.com/user-attachments/assets/9e42e1e4-3382-4370-ae61-74db3c80cc4a)

Содержимое файла меняется на то что было указано в content из default переменных. Выполнен повторный запуск без внесения изменний, плейбук идемпотентен.

Дополнительно: Изменения также будут внесены в случае если перед повторным запуском плейбука кто-то внёс изменение в содержимое файла.

![изображение](https://github.com/user-attachments/assets/b77ff635-9918-4f7f-9bbd-c4abd4b9402f)



## Необязательная часть

1. Реализуйте свой модуль для создания хостов в Yandex Cloud.
2. Модуль может и должен иметь зависимость от `yc`, основной функционал: создание ВМ с нужным сайзингом на основе нужной ОС. Дополнительные модули по созданию кластеров ClickHouse, MySQL и прочего реализовывать не надо, достаточно простейшего создания ВМ.
3. Модуль может формировать динамическое inventory, но эта часть не является обязательной, достаточно, чтобы он делал хосты с указанной спецификацией в YAML.
4. Протестируйте модуль на идемпотентность, исполнимость. При успехе добавьте этот модуль в свою коллекцию.
5. Измените playbook так, чтобы он умел создавать инфраструктуру под inventory, а после устанавливал весь ваш стек Observability на нужные хосты и настраивал его.
6. В итоге ваша коллекция обязательно должна содержать: clickhouse-role (если есть своя), lighthouse-role, vector-role, два модуля: my_own_module и модуль управления Yandex Cloud хостами и playbook, который демонстрирует создание Observability стека.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
