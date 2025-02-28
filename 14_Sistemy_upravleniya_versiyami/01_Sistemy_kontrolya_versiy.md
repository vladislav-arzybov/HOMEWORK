# Домашнее задание к занятию «Системы контроля версий» - `Арзыбов Владислав`

### Цель задания

В результате выполнения задания вы: 

* научитесь подготоваливать новый репозиторий к работе;
* сохранять, перемещать и удалять файлы в системе контроля версий.  


### Чеклист готовности к домашнему заданию

1. Установлена консольная утилита для работы с Git.


### Инструкция к заданию

1. Домашнее задание выполните в GitHub-репозитории. 
2. В личном кабинете отправьте на проверку ссылку на ваш репозиторий с домашним заданием.
3. Любые вопросы по решению задач задавайте в чате учебной группы.


### Дополнительные материалы для выполнения задания

1. [GitHub](https://github.com/).
2. [Инструкция по установке Git](https://git-scm.com/downloads).
3. [Книга про  Git на русском языке](https://git-scm.com/book/ru/v2/) - рекомендуем к обязательному изучению главы 1-7.
   
   
------

## Задание 1. Создать и настроить репозиторий для дальнейшей работы на курсе

В рамках курса вы будете писать скрипты и создавать конфигурации для различных систем, которые необходимо сохранять для будущего использования. 
Сначала надо создать и настроить локальный репозиторий, после чего добавить удалённый репозиторий на GitHub.

### Создание репозитория и первого коммита

1. Зарегистрируйте аккаунт на [https://github.com/](https://github.com/). Если предпочитаете другое хранилище для репозитория, можно использовать его.
2. Создайте публичный репозиторий, который будете использовать дальше на протяжении всего курса, желательное с названием `devops-netology`.
   Обязательно поставьте галочку `Initialize this repository with a README`. 
   
    ![Диалог создания репозитория](img/github-new-repo-1.jpg)
    
3. Создайте [авторизационный токен](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) для клонирования репозитория.
4. Склонируйте репозиторий, используя протокол HTTPS (`git clone ...`).
 
    ![Клонирование репозитория](img/github-clone-repo-https.jpg)
    
5. Перейдите в каталог с клоном репозитория (`cd devops-netology`).
6. Произведите первоначальную настройку Git, указав своё настоящее имя, чтобы нам было проще общаться, и email (`git config --global user.name` и `git config --global user.email johndoe@example.com`).

- git config --global user.name vladislav-arzybov
- git config --global user.email reivol@mail.ru
   
7. Выполните команду `git status` и запомните результат.

![изображение](https://github.com/user-attachments/assets/c5d1dba8-0472-4ea0-b2f3-f2df05b25fce)
   
8. Отредактируйте файл `README.md` любым удобным способом, тем самым переведя файл в состояние `Modified`.
9. Ещё раз выполните `git status` и продолжайте проверять вывод этой команды после каждого следующего шага.

![изображение](https://github.com/user-attachments/assets/693a3b7d-92a1-438b-bc56-917e4d98e795)

10. Теперь посмотрите изменения в файле `README.md`, выполнив команды `git diff` и `git diff --staged`.

![изображение](https://github.com/user-attachments/assets/c7bcf66f-5502-41d4-a719-4e3b358cd514)

11. Переведите файл в состояние `staged` (или, как говорят, просто добавьте файл в коммит) командой `git add README.md`.

![изображение](https://github.com/user-attachments/assets/bb6c7079-e575-4101-a5ff-acc5451bd300)

12. И ещё раз выполните команды `git diff` и `git diff --staged`. Поиграйте с изменениями и этими командами, чтобы чётко понять, что и когда они отображают.

![изображение](https://github.com/user-attachments/assets/7a4111b3-ee95-4948-9602-28f9ebf973f6)

13. Теперь можно сделать коммит `git commit -m 'First commit'`.

![изображение](https://github.com/user-attachments/assets/7362a8ea-0064-4318-a4fd-55e405058445)

14. И ещё раз посмотреть выводы команд `git status`, `git diff` и `git diff --staged`.

![изображение](https://github.com/user-attachments/assets/253abb9f-d698-49e4-bed3-27bf07ca6484)


### Создание файлов `.gitignore` и второго коммита

1. Создайте файл `.gitignore` (обратите внимание на точку в начале файла), проверьте его статус сразу после создания.

![изображение](https://github.com/user-attachments/assets/84024e5f-47ca-48e2-aac1-a935bdd73627)
   
2. Добавьте файл `.gitignore` в следующий коммит (`git add...`).

![изображение](https://github.com/user-attachments/assets/a2dc77e8-7ebc-4308-9bb0-b56133bcbb8f)

3. На одном из следующих блоков вы будете изучать `Terraform`, давайте сразу создадим соотвествующий каталог `terraform` и внутри этого каталога — файл `.gitignore` по примеру: https://github.com/github/gitignore/blob/master/Terraform.gitignore.

![изображение](https://github.com/user-attachments/assets/a00f4d6b-3241-4b39-b33a-91ef6a173425)

4. В файле `README.md` опишите своими словами, какие файлы будут проигнорированы в будущем благодаря добавленному `.gitignore`.

![изображение](https://github.com/user-attachments/assets/84247ae5-0a6a-47cc-80ff-39bcd53cfc3a)

5. Закоммитьте все новые и изменённые файлы. Комментарий к коммиту должен быть `Added gitignore`.

![изображение](https://github.com/user-attachments/assets/e11b9f01-1c31-480e-bcdf-e2a41f4ce5e9)

### Эксперимент с удалением и перемещением файлов (третий и четвёртый коммит)

1. Создайте файлы `will_be_deleted.txt` (с текстом `will_be_deleted`) и `will_be_moved.txt` (с текстом `will_be_moved`) и закоммите их с комментарием `Prepare to delete and move`.

![изображение](https://github.com/user-attachments/assets/fa898cb3-9f41-4403-9dd1-962d9c1848de)

2. В случае необходимости обратитесь к [официальной документации](https://git-scm.com/book/ru/v2/Основы-Git-Запись-изменений-в-репозиторий) — здесь подробно описано, как выполнить следующие шаги. 
3. Удалите файл `will_be_deleted.txt` с диска и из репозитория.

![изображение](https://github.com/user-attachments/assets/cb8519ba-d9a5-40c7-8627-196a97a42d0d)
   
4. Переименуйте (переместите) файл `will_be_moved.txt` на диске и в репозитории, чтобы он стал называться `has_been_moved.txt`.

![изображение](https://github.com/user-attachments/assets/16fcf05a-e126-4878-b44f-6bf0da8bc3a1)

5. Закоммитьте результат работы с комментарием `Moved and deleted`.

![изображение](https://github.com/user-attachments/assets/92da5a99-0ff9-42fc-8e3f-3526d967832b)


### Проверка изменения

1. В результате предыдущих шагов в репозитории должно быть как минимум пять коммитов (если вы сделали ещё промежуточные — нет проблем):
    * `Initial Commit` — созданный GitHub при инициализации репозитория. 
    * `First commit` — созданный после изменения файла `README.md`.
    * `Added gitignore` — после добавления `.gitignore`.
    * `Prepare to delete and move` — после добавления двух временных файлов.
    * `Moved and deleted` — после удаления и перемещения временных файлов. 
2. Проверьте это, используя комманду `git log`. Подробно о формате вывода этой команды мы поговорим на следующем занятии, но посмотреть, что она отображает, можно уже сейчас.

![изображение](https://github.com/user-attachments/assets/ea949c79-aedb-41a0-9143-dcc1b46d8bcd)


### Отправка изменений в репозиторий

Выполните команду `git push`, если Git запросит логин и пароль — введите ваши логин и пароль от GitHub. 

![изображение](https://github.com/user-attachments/assets/af1928ed-e959-4d8b-bbf5-9e3bbed9e0ed)


В качестве результата отправьте ссылку на репозиторий. 

----

### Правила приёма домашнего задания

В личном кабинете отправлена ссылка на ваш репозиторий.

https://github.com/vladislav-arzybov/devops-netology

### Критерии оценки

Зачёт:

* выполнены все задания;
* ответы даны в развёрнутой форме;
* приложены соответствующие скриншоты и файлы проекта;
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку:

* задание выполнено частично или не выполнено вообще;
* в логике выполнения заданий есть противоречия и существенные недостатки. 
