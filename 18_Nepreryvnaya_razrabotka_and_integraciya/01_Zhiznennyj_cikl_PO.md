# Домашнее задание к занятию 7 «Жизненный цикл ПО» - `Арзыбов Владислав`

## Подготовка к выполнению

1. Получить бесплатную версию Jira - https://www.atlassian.com/ru/software/jira/work-management/free (скопируйте ссылку в адресную строку). Вы можете воспользоваться любым(в том числе бесплатным vpn сервисом) если сайт у вас недоступен. Кроме того вы можете скачать [docker образ](https://hub.docker.com/r/atlassian/jira-software/#) и запустить на своем хосте self-managed версию jira.
2. Настроить её для своей команды разработки.
3. Создать доски Kanban и Scrum.
4. [Дополнительные инструкции от разработчика Jira](https://support.atlassian.com/jira-cloud-administration/docs/import-and-export-issue-workflows/).

## Основная часть

Необходимо создать собственные workflow для двух типов задач: bug и остальные типы задач. Задачи типа bug должны проходить жизненный цикл:

1. Open -> On reproduce.
2. On reproduce -> Open, Done reproduce.
3. Done reproduce -> On fix.
4. On fix -> On reproduce, Done fix.
5. Done fix -> On test.
6. On test -> On fix, Done.
7. Done -> Closed, Open.

![изображение](https://github.com/user-attachments/assets/f2ad46fd-7ba5-4095-946a-d31d2c4051eb)


Остальные задачи должны проходить по упрощённому workflow:

1. Open -> On develop.
2. On develop -> Open, Done develop.
3. Done develop -> On test.
4. On test -> On develop, Done.
5. Done -> Closed, Open.

![изображение](https://github.com/user-attachments/assets/0318293b-96a3-4986-8a25-48b966404c15)



![изображение](https://github.com/user-attachments/assets/abae5ec6-c4ba-402a-9441-e2a2d6d10f44)

![изображение](https://github.com/user-attachments/assets/9bbc597e-3e71-4c0d-83f0-a9421f548832)


**Что нужно сделать**

1. Создайте задачу с типом bug, попытайтесь провести его по всему workflow до Done.

![изображение](https://github.com/user-attachments/assets/82343b3b-3e58-42cf-992a-5e91c080f112)

1. Создайте задачу с типом epic, к ней привяжите несколько задач с типом task, проведите их по всему workflow до Done.

![изображение](https://github.com/user-attachments/assets/f4fa3c36-a979-48b1-bbfc-d535015b10a4)

![изображение](https://github.com/user-attachments/assets/a15f78d5-d4b9-4743-a0d0-23a5754b1574)

1. При проведении обеих задач по статусам используйте kanban. 
1. Верните задачи в статус Open.

![изображение](https://github.com/user-attachments/assets/f965faa9-59ce-417f-8f53-15c6bcf7199d)

1. Перейдите в Scrum, запланируйте новый спринт, состоящий из задач эпика и одного бага, стартуйте спринт, проведите задачи до состояния Closed. Закройте спринт.

![изображение](https://github.com/user-attachments/assets/0911fd8f-d48f-4cef-a9ff-07bbfe1c550e)

![изображение](https://github.com/user-attachments/assets/11a53941-62db-492e-97d4-60c81d96bc83)

![изображение](https://github.com/user-attachments/assets/cf9b2285-71c4-4609-a073-c54c81a54a67)

3. Если всё отработалось в рамках ожидания — выгрузите схемы workflow для импорта в XML. Файлы с workflow и скриншоты workflow приложите к решению задания.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
