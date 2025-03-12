# Домашнее задание к занятию «Использование Terraform в команде» - `Арзыбов Владислав`

### Цели задания

1. Научиться использовать remote state с блокировками.
2. Освоить приёмы командной работы.


### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Любые ВМ, использованные при выполнении задания, должны быть прерываемыми, для экономии средств.

------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
Убедитесь что ваша версия **Terraform** ~>1.8.4
Пишем красивый код, хардкод значения не допустимы!

------
### Задание 0
1. Прочтите статью: https://neprivet.com/
2. Пожалуйста, распространите данную идею в своем коллективе.

------

### Задание 1

1. Возьмите код:
- из [ДЗ к лекции 4](https://github.com/netology-code/ter-homeworks/tree/main/04/src),
- из [демо к лекции 4](https://github.com/netology-code/ter-homeworks/tree/main/04/demonstration1).
2. Проверьте код с помощью tflint и checkov. Вам не нужно инициализировать этот проект.
3. Перечислите, какие **типы** ошибок обнаружены в проекте (без дублей).

#### tflint: docker run --rm -v $(pwd):/data -t ghcr.io/terraform-linters/tflint

- Warning: Missing version constraint for provider "yandex" in `required_providers` (terraform_required_providers) - Отсутствует ограничение версии для провайдера в разделе провайдеры, required_providers.
- Warning: [Fixable] variable "vms_ssh_root_key" is declared but not used (terraform_unused_declarations) - Переменная "имя_переменной" объявлена, но не используется.
- Warning: Module source "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main" uses a default branch as ref (main) (terraform_module_pinned_source) - Исходный код модуля "git::https://..." использует в качестве ссылки ветку по умолчанию, main.
- Warning: Missing version constraint for provider "template" in `required_providers` (terraform_required_providers) - Отсутствует ограничение версии для провайдера в "шаблоне template".



![изображение](https://github.com/user-attachments/assets/35ac042f-9281-4d48-acd3-e975e48cd9db)

#### checkov: docker run --rm --tty --volume $(pwd):/tf --workdir /tf bridgecrew/checkov --download-external-modules true --directory /tf

- Check: CKV_YC_4: "Ensure compute instance does not have serial console enabled." - Убедитесь, что у экземпляра не включена последовательная консоль.
- Check: CKV_YC_11: "Ensure security group is assigned to network interface." - Убедитесь, что сетевому интерфейсу назначена группа безопасности
- Check: CKV_YC_2: "Ensure compute instance does not have public IP." - Убедитесь, что экземпляр не имеет внешнего IP-адреса.
- Check: CKV_TF_1: "Ensure Terraform module sources use a commit hash" - Убедитесь, что в исходных кодах модуля Terraform используется хэш фиксации.
- Check: CKV_TF_2: "Ensure Terraform module sources use a tag with a version number" - Убедитесь, что в исходных текстах модуля Terraform используется тег с номером версии.


------

### Задание 2

1. Возьмите ваш GitHub-репозиторий с **выполненным ДЗ 4** в ветке 'terraform-04' и сделайте из него ветку 'terraform-05'.

![изображение](https://github.com/user-attachments/assets/85c3ae1e-ccee-40db-ac82-4e44a271b9d3)

3. Повторите демонстрацию лекции: настройте YDB, S3 bucket, yandex service account, права доступа и мигрируйте state проекта в S3 с блокировками. Предоставьте скриншоты процесса в качестве ответа.

Создадим сервисный аккаунт в Identity and Access Management

![изображение](https://github.com/user-attachments/assets/fd5c8644-370f-48f9-8af0-b46b8abf541d)

Создаем ключ в настройках сервисного аккаунта

![изображение](https://github.com/user-attachments/assets/04861a6e-a2ff-42d8-9e12-c8b7d3978b5e)

Создаем бакет в Object Storage

![изображение](https://github.com/user-attachments/assets/6ff2672c-4ff2-444d-a36b-cabb8b3131d9)

Выбираем редактировать ACL, в поиске находим созданный сервисный аккаунт, добавить, сохранить.

![изображение](https://github.com/user-attachments/assets/110de4f2-ca17-45ee-a2b1-7d0badcae48f)

Создаем базу данных YDB размером 1Гб в Managed Service for YDB

![изображение](https://github.com/user-attachments/assets/8c5946bb-59e4-46f1-974e-3c845fd72b29)

Переходим в пункт Навигация, создаем таблицу, Документная таблица. Имя колонки: LockID, Тип: string, Ключ партицирования - ок.

![изображение](https://github.com/user-attachments/assets/a280155c-7a56-4976-9571-27f3f509648d)

![изображение](https://github.com/user-attachments/assets/d977686f-2da1-4ce0-a00a-bb0595c17637)

Во вкладке Обзор копируем значение Document API эндпоинт и подставляем в dynamodb, настраиваем конфиг backend "s3"

```
terraform {
  required_version = "1.8.4"
  backend "s3" {
    bucket     = "reivol" #FIO-netology-tfstate
    region="ru-central1"
    key = "terraform.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # Необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.
  endpoints ={
    dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/....."
    s3 = "https://storage.yandexcloud.net"
  }
    dynamodb_table              = "table_name"  # Название таблицы в БД
  }
}
```


5. Закоммитьте в ветку 'terraform-05' все изменения.
6. Откройте в проекте terraform console, а в другом окне из этой же директории попробуйте запустить terraform apply.
7. Пришлите ответ об ошибке доступа к state.
8. Принудительно разблокируйте state. Пришлите команду и вывод.


------
### Задание 3  

1. Сделайте в GitHub из ветки 'terraform-05' новую ветку 'terraform-hotfix'.
2. Проверье код с помощью tflint и checkov, исправьте все предупреждения и ошибки в 'terraform-hotfix', сделайте коммит.
3. Откройте новый pull request 'terraform-hotfix' --> 'terraform-05'. 
4. Вставьте в комментарий PR результат анализа tflint и checkov, план изменений инфраструктуры из вывода команды terraform plan.
5. Пришлите ссылку на PR для ревью. Вливать код в 'terraform-05' не нужно.

------
### Задание 4

1. Напишите переменные с валидацией и протестируйте их, заполнив default верными и неверными значениями. Предоставьте скриншоты проверок из terraform console. 

- type=string, description="ip-адрес" — проверка, что значение переменной содержит верный IP-адрес с помощью функций cidrhost() или regex(). Тесты:  "192.168.0.1" и "1920.1680.0.1";
- type=list(string), description="список ip-адресов" — проверка, что все адреса верны. Тесты:  ["192.168.0.1", "1.1.1.1", "127.0.0.1"] и ["192.168.0.1", "1.1.1.1", "1270.0.0.1"].

## Дополнительные задания (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.** Их выполнение поможет глубже разобраться в материале.   
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 
------
### Задание 5*
1. Напишите переменные с валидацией:
- type=string, description="любая строка" — проверка, что строка не содержит символов верхнего регистра;
- type=object — проверка, что одно из значений равно true, а второе false, т. е. не допускается false false и true true:
```
variable "in_the_end_there_can_be_only_one" {
    description="Who is better Connor or Duncan?"
    type = object({
        Dunkan = optional(bool)
        Connor = optional(bool)
    })

    default = {
        Dunkan = true
        Connor = false
    }

    validation {
        error_message = "There can be only one MacLeod"
        condition = <проверка>
    }
}
```
------
### Задание 6*

1. Настройте любую известную вам CI/CD-систему. Если вы ещё не знакомы с CI/CD-системами, настоятельно рекомендуем вернуться к этому заданию после изучения Jenkins/Teamcity/Gitlab.
2. Скачайте с её помощью ваш репозиторий с кодом и инициализируйте инфраструктуру.
3. Уничтожьте инфраструктуру тем же способом.


------
### Задание 7*
1. Настройте отдельный terraform root модуль, который будет создавать YDB, s3 bucket для tfstate и сервисный аккаунт с необходимыми правами. 

### Правила приёма работы

Ответы на задания и необходимые скриншоты оформите в md-файле в ветке terraform-05.

В качестве результата прикрепите ссылку на ветку terraform-05 в вашем репозитории.

**Важно.** Удалите все созданные ресурсы.

### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 




