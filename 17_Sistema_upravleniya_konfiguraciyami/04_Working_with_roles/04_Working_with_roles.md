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

9. Переработайте playbook на использование roles. Не забудьте про зависимости LightHouse и возможности совмещения `roles` с `tasks`.

- ansible-galaxy install -r requirements.yml -p roles

![изображение](https://github.com/user-attachments/assets/07b1ead9-19fa-44c4-845e-e6127232eaee)

- ansible-playbook -i inventory/prod.yml site.yml

![изображение](https://github.com/user-attachments/assets/9409863f-4a8e-4601-bc9d-6ee0d766948c)

10. Выложите playbook в репозиторий.
11. В ответе дайте ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
