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

![изображение](https://github.com/user-attachments/assets/bd59085c-c343-4a8a-965b-f4fcc903abb0)

* Найдите коммит, в котором была создана функция `func providerSource`, её определение в коде выглядит так: `func providerSource(...)` (вместо троеточия перечислены аргументы).

8c928e83589d90a031f811fae52a81be7153e82f

![изображение](https://github.com/user-attachments/assets/95418e19-9e6f-4c25-a9d2-a29244d6cdb6)

* Найдите все коммиты, в которых была изменена функция `globalPluginDirs`.

```bash
7c4aeac5f30aed09c5ef3198141b033eea9912be stacks: load credentials from config file on startup (#35952)
65c4ba736375607b6af6c035972f7f151232b6c6 Remove terraform binary
125eb51dc40b049b38bf2ed11c32c6f594c8ef96 Remove accidentally-committed binary
22c121df8631c4499d070329c9aa7f5b291494e1 Bump compatibility version to 1.3.0 for terraform core release (#30988)
7c7e5d8f0a6a50812e6e4db3016ebfd36fa5eaef Don't show data while input if sensitive
35a058fb3ddfae9cfee0b3893822c9a95b920f4c main: configure credentials from the CLI config file
c0b17610965450a89598da491ce9b6b5cbd6393f prevent log output during init
```

![изображение](https://github.com/user-attachments/assets/b3a88d15-b75b-44e3-b43f-8c5abdee20ae)


* Кто автор функции `synchronizedWriters`? 

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
