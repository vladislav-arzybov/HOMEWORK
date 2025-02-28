# Домашнее задание к занятию «Введение в Terraform» - `Арзыбов Владислав`

### Цели задания

1. Установить и настроить Terrafrom.
2. Научиться использовать готовый код.

------

### Чек-лист готовности к домашнему заданию

1. Скачайте и установите **Terraform** версии >=1.8.4 . Приложите скриншот вывода команды ```terraform --version```.

![изображение](https://github.com/user-attachments/assets/ac6426e1-1ddf-415f-b017-17f0776144a7)

2. Скачайте на свой ПК этот git-репозиторий. Исходный код для выполнения задания расположен в директории **01/src**.

![изображение](https://github.com/user-attachments/assets/b44ca655-0bdb-4cb8-b1ee-e129258f497e)

3. Убедитесь, что в вашей ОС установлен docker.

![изображение](https://github.com/user-attachments/assets/289ca7b7-cbd6-429f-b235-13f73971eb4d)



------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. Репозиторий с ссылкой на зеркало для установки и настройки Terraform: [ссылка](https://github.com/netology-code/devops-materials).
2. Установка docker: [ссылка](https://docs.docker.com/engine/install/ubuntu/). 
------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
------

### Задание 1

1. Перейдите в каталог [**src**](https://github.com/netology-code/ter-homeworks/tree/main/01/src). Скачайте все необходимые зависимости, использованные в проекте.

![изображение](https://github.com/user-attachments/assets/9bdea9d5-5038-4a33-821d-ccc619139078)

2. Изучите файл **.gitignore**. В каком terraform-файле, согласно этому .gitignore, допустимо сохранить личную, секретную информацию?(логины,пароли,ключи,токены итд)

- В personal.auto.tfvars

3. Выполните код проекта. Найдите  в state-файле секретное содержимое созданного ресурса **random_password**, пришлите в качестве ответа конкретный ключ и его значение.

- result": "JF6KHG2XV2iDhdfX

4. Раскомментируйте блок кода, примерно расположенный на строчках 29–42 файла **main.tf**.
Выполните команду ```terraform validate```. Объясните, в чём заключаются намеренно допущенные ошибки. Исправьте их.

![изображение](https://github.com/user-attachments/assets/6a7c18b8-dc87-4e04-839a-2ce2b5523d27)

- All resource blocks must have 2 labels (type, name). - В блоках resource должен быть указан не только тип "docker_image", но и название "nginx"
- A name must start with a letter or underscore and may contain only letters, digits, underscores, and dashes. - Имя должно начинаться с буквы или символа подчеркивания и может содержать только буквы, цифры, знаки подчеркивания и тире, в данном случае необходимо заменить "1nginx" на "nginx"

![изображение](https://github.com/user-attachments/assets/3a924174-8be9-4332-87ea-c91cb81436d5)

- A managed resource "random_password" "random_string_FAKE" has not been declared in the root module. - Ресурс "random_password" "random_string_FAKE" ранее не был объявлен, необходимо заменить "random_string_FAKE" на "random_string"

![изображение](https://github.com/user-attachments/assets/fae990f3-1a5a-498f-9144-b53fd9863c44)

- This object has no argument, nested block, or exported attribute named "resulT". Did you mean "result"? - У этого объекта нет аргумента, вложенного блока или экспортируемого атрибута с именем "resulT", необходимо заменить на "result"

![изображение](https://github.com/user-attachments/assets/31e958b3-610e-4bb5-82b4-de004e420b27)

5. Выполните код. В качестве ответа приложите: исправленный фрагмент кода и вывод команды ```docker ps```.

```
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "example_${random_password.random_string.result}"
```

![изображение](https://github.com/user-attachments/assets/87d77b50-cdfa-4fb8-a510-5bb1958fec78)

6. Замените имя docker-контейнера в блоке кода на ```hello_world```. Не перепутайте имя контейнера и имя образа. Мы всё ещё продолжаем использовать name = "nginx:latest". Выполните команду ```terraform apply -auto-approve```.
Объясните своими словами, в чём может быть опасность применения ключа  ```-auto-approve```. Догадайтесь или нагуглите зачем может пригодиться данный ключ? В качестве ответа дополнительно приложите вывод команды ```docker ps```.

- В отличии от выполнения обычной команды ```terraform apply``` команда с ключем ```-auto-approve``` не требует подтверждения и ввода слова ```yes``` от пользователя, её применение может быть обоснованно в случае автоматизации процесса ручного развертывания, а также в средах тестирования и разработки, где поломка ранее созданной инфраструктуры не так критична.

```
resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "hello_world"
```

![изображение](https://github.com/user-attachments/assets/d97a55c8-50c1-46cd-9871-727e66667eda)

7. Уничтожьте созданные ресурсы с помощью **terraform**. Убедитесь, что все ресурсы удалены. Приложите содержимое файла **terraform.tfstate**.

![изображение](https://github.com/user-attachments/assets/9d2d130a-3c6e-46b7-b893-d6fcd42b5a32)

[terraform.tfstate](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/16_Oblachnaya_infrastruktura_Terraform/terraform.tfstate)
  
8. Объясните, почему при этом не был удалён docker-образ **nginx:latest**. Ответ **ОБЯЗАТЕЛЬНО НАЙДИТЕ В ПРЕДОСТАВЛЕННОМ КОДЕ**, а затем **ОБЯЗАТЕЛЬНО ПОДКРЕПИТЕ** строчкой из документации [**terraform провайдера docker**](https://docs.comcloud.xyz/providers/kreuzwerker/docker/latest/docs).  (ищите в классификаторе resource docker_image )

- При использовании аргумента "keep_locally = true" образ не будет удален при операции уничтожения, для этого необходимо указать false, тогда образ будет удален из локального хранилища docker при выполнении terraform destroy.


------

## Дополнительное задание (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.** Они помогут глубже разобраться в материале.   
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 

### Задание 2*

1. Создайте в облаке ВМ. Сделайте это через web-консоль, чтобы не слить по незнанию токен от облака в github(это тема следующей лекции). Если хотите - попробуйте сделать это через terraform, прочитав документацию yandex cloud. Используйте файл ```personal.auto.tfvars``` и гитигнор или иной, безопасный способ передачи токена!
2. Подключитесь к ВМ по ssh и установите стек docker.
3. Найдите в документации docker provider способ настроить подключение terraform на вашей рабочей станции к remote docker context вашей ВМ через ssh.
4. Используя terraform и  remote docker context, скачайте и запустите на вашей ВМ контейнер ```mysql:8``` на порту ```127.0.0.1:3306```, передайте ENV-переменные. Сгенерируйте разные пароли через random_password и передайте их в контейнер, используя интерполяцию из примера с nginx.(```name  = "example_${random_password.random_string.result}"```  , двойные кавычки и фигурные скобки обязательны!) 
```
    environment:
      - "MYSQL_ROOT_PASSWORD=${...}"
      - MYSQL_DATABASE=wordpress
      - MYSQL_USER=wordpress
      - "MYSQL_PASSWORD=${...}"
      - MYSQL_ROOT_HOST="%"
```

6. Зайдите на вашу ВМ , подключитесь к контейнеру и проверьте наличие секретных env-переменных с помощью команды ```env```. Запишите ваш финальный код в репозиторий.

### Задание 3*
1. Установите [opentofu](https://opentofu.org/)(fork terraform с лицензией Mozilla Public License, version 2.0) любой версии
2. Попробуйте выполнить тот же код с помощью ```tofu apply```, а не terraform apply.
------

### Правила приёма работы

Домашняя работа оформляется в отдельном GitHub-репозитории в файле README.md.   
Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 
