# Домашнее задание к занятию «Инструменты Git» - `Арзыбов Владислав`

### Цель задания

В результате выполнения задания вы:

* научитесь работать с утилитами Git;
* потренируетесь решать типовые задачи, возникающие при работе в команде. 

### Инструкция к заданию

1. Склонируйте [репозиторий](https://github.com/hashicorp/terraform) с исходным кодом Terraform.
2. Создайте файл для ответов на задания в своём репозитории, после выполнения прикрепите ссылку на .md-файл с ответами в личном кабинете.
3. Любые вопросы по решению задач задавайте в чате учебной группы.

------

## Задание

В клонированном репозитории:

1. Найдите полный хеш и комментарий коммита, хеш которого начинается на `aefea`.

- aefead2207ef7e2aa5dc81a34aedf0cad4c32545

- Update CHANGELOG.md

![изображение](https://github.com/user-attachments/assets/87c083c6-63e0-4607-8e5f-a170cca31905)
   
2. Ответьте на вопросы.

* Какому тегу соответствует коммит `85024d3`? v0.12.23

![изображение](https://github.com/user-attachments/assets/f7a804ad-2d14-4984-b451-6022ad3a384b)

* Сколько родителей у коммита `b8d720`? Напишите их хеши. Два:

56cd7859e05c36c06b56d013b55a252d0bb7e158

9ea88f22fc6269854151c571162c5bcf958bee2b

![изображение](https://github.com/user-attachments/assets/36cd0327-a6ca-4a49-84a1-410573e8b9ed)


* Перечислите хеши и комментарии всех коммитов, которые были сделаны между тегами  v0.12.23 и v0.12.24.

Показать все коммиты без учета последнего v0.12.24: git log --pretty=oneline v0.12.23..v0.12.24^

```bash
b14b74c4939dcab573326f4e3ee2a62e23e12f89 [Website] vmc provider links
3f235065b9347a758efadc92295b540ee0a5e26e Update CHANGELOG.md
6ae64e247b332925b872447e9ce869657281c2bf registry: Fix panic when server is unreachable
5c619ca1baf2e21a155fcdb4c264cc9e24a2a353 website: Remove links to the getting started guide's old location
06275647e2b53d97d4f0a19a0fec11f6d69820b5 Update CHANGELOG.md
d5f9411f5108260320064349b757f55c09bc4b80 command: Fix bug when using terraform login on Windows
4b6d06cc5dcb78af637bbb19c198faff37a066ed Update CHANGELOG.md
dd01a35078f040ca984cdd349f18d0b67e486c35 Update CHANGELOG.md
225466bc3e5f35baa5d07197bbc079345b77525e Cleanup after v0.12.23 release
```

![изображение](https://github.com/user-attachments/assets/1b1cd622-5ebf-4cfe-86d3-bebb80c6bd6c)

* Найдите коммит, в котором была создана функция `func providerSource`, её определение в коде выглядит так: `func providerSource(...)` (вместо троеточия перечислены аргументы).

8c928e83589d90a031f811fae52a81be7153e82f

![изображение](https://github.com/user-attachments/assets/95418e19-9e6f-4c25-a9d2-a29244d6cdb6)

* Найдите все коммиты, в которых была изменена функция `GlobalPluginDirs`.

Найдем файл сожержащий упоминание `GlobalPluginDirs`, выполним команду: git grep "func GlobalPluginDirs"

![изображение](https://github.com/user-attachments/assets/0aeae03f-c214-49cc-863f-d33395c1e208)

Просмотрим историю изменений данного файла:

git log -L:'GlobalPluginDirs':internal/command/cliconfig/plugins.go --oneline -q

```bash
7c4aeac5f3 stacks: load credentials from config file on startup (#35952)
78b1220558 Remove config.go and update things using its aliases
52dbf94834 keep .terraform.d/plugins for discovery
41ab0aef7a Add missing OS_ARCH dir to global plugin paths
66ebff90cd move some more plugin search path logic to command
8364383c35 Push plugin discovery down into command package
```

![изображение](https://github.com/user-attachments/assets/5f013254-00c2-4d71-9938-016f6295e290)


* Кто автор функции `synchronizedWriters`? 

Выполним команду которая покажет изменения данной данной функции, в нашем случае выведет имя автора первого коммита в котором она была добавлена:

git log -S 'synchronizedWriters' --pretty=format:"%an" --reverse --date=short | head -n 1

Martin Atkins

![изображение](https://github.com/user-attachments/assets/3ac3071e-0954-41c5-8c01-1e61681600bc)

*В качестве решения ответьте на вопросы и опишите, как были получены эти ответы.*

---

### Правила приёма домашнего задания

В личном кабинете отправлена ссылка на .md-файл в вашем репозитории.

### Критерии оценки

Зачёт:

* выполнены все задания;
* ответы даны в развёрнутой форме;
* приложены соответствующие скриншоты и файлы проекта;
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку:

* задание выполнено частично или не выполнено вообще;
* в логике выполнения заданий есть противоречия и существенные недостатки.
