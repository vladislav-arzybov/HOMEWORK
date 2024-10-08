# Домашнее задание к занятию "`GitLab`" - `Арзыбов Владислав`

---

### Задание 1

**Что нужно сделать:**

1. Разверните GitLab локально, используя Vagrantfile и инструкцию, описанные в [этом репозитории](https://github.com/netology-code/sdvps-materials/tree/main/gitlab).

   ![изображение](https://github.com/user-attachments/assets/20e07892-5ba6-452d-bb2a-914611b66f05)

3. Создайте новый проект и пустой репозиторий в нём.

   ![изображение](https://github.com/user-attachments/assets/2a81b1bb-ae7e-4dba-8d02-f2a29d982023)

5. Зарегистрируйте gitlab-runner для этого проекта и запустите его в режиме Docker. Раннер можно регистрировать и запускать на той же виртуальной машине, на которой запущен GitLab.

   ![изображение](https://github.com/user-attachments/assets/0c3846ca-5042-464c-aca9-0b4107a952c4)

В качестве ответа в репозиторий шаблона с решением добавьте скриншоты с настройками раннера в проекте.

   ![изображение](https://github.com/user-attachments/assets/dd096769-c836-4a45-ac60-f138681a17dd)

   ![изображение](https://github.com/user-attachments/assets/d01f3315-2d77-46eb-adc7-0e4d9f9bad55)

   ![изображение](https://github.com/user-attachments/assets/453e7b0c-cca9-4390-afb9-404a1b99c2a5)


---

### Задание 2

**Что нужно сделать:**

1. Запушьте [репозиторий](https://github.com/netology-code/sdvps-materials/tree/main/gitlab) на GitLab, изменив origin. Это изучалось на занятии по Git.

   ![изображение](https://github.com/user-attachments/assets/4dfe1853-0e7e-4d64-afed-db26b7515f89)

   ![изображение](https://github.com/user-attachments/assets/f5e84a23-7a2d-4e57-8ec1-7ff926068302)

3. Создайте .gitlab-ci.yml, описав в нём все необходимые, на ваш взгляд, этапы.

В качестве ответа в шаблон с решением добавьте: 

   ![изображение](https://github.com/user-attachments/assets/787b2b69-42b9-4cf6-a377-77e9d4a267da)
   
 * файл gitlab-ci.yml для своего проекта или вставьте код в соответствующее поле в шаблоне;
     
      https://raw.githubusercontent.com/vladislav-arzybov/HOMEWORK/main/.gitlab-ci.yml_1
   
 * скриншоты с успешно собранными сборками.

   ![изображение](https://github.com/user-attachments/assets/6f59bc83-dfdc-4869-ab38-d484a29e1357)

   ![изображение](https://github.com/user-attachments/assets/cf9e1741-903b-481b-a05c-a57cb9872822)



  
---
## Дополнительные задания* (со звёздочкой)

Их выполнение необязательное и не влияет на получение зачёта по домашнему заданию. Можете их решить, если хотите лучше разобраться в материале.

---

### Задание 3*

Измените CI так, чтобы:

 - этап сборки запускался сразу, не дожидаясь результатов тестов;
 - тесты запускались только при изменении файлов с расширением *.go.

В качестве ответа добавьте в шаблон с решением файл gitlab-ci.yml своего проекта или вставьте код в соответсвующее поле в шаблоне.

   https://raw.githubusercontent.com/vladislav-arzybov/HOMEWORK/main/.gitlab-ci.yml_2

   ![изображение](https://github.com/user-attachments/assets/009804dd-c113-4753-9de2-837567afa98a)

