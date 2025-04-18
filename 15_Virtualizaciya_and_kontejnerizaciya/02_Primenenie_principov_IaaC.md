# Домашнее задание к занятию 2. «Применение принципов IaaC в работе с виртуальными машинами» - `Арзыбов Владислав`


---

### Цели задания

1. Научиться создвать виртуальные машины в Virtualbox с помощью Vagrant.
2. Научиться базовому использованию packer в yandex cloud.

   
## Задача 1
Установите на личный Linux-компьютер или учебную **локальную** ВМ с Linux следующие сервисы(желательно ОС ubuntu 20.04):

- [VirtualBox](https://www.virtualbox.org/),

![изображение](https://github.com/user-attachments/assets/020c3b1d-9207-48c6-99ff-0357ec8e3a1d)

- [Vagrant](https://github.com/netology-code/devops-materials), рекомендуем версию 2.3.4

![изображение](https://github.com/user-attachments/assets/957ed402-a431-43a0-88ed-538c32d8b199)

- [Packer](https://github.com/netology-code/devops-materials/blob/master/README.md) версии 1.9.х + плагин от Яндекс Облако по [инструкции](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/packer-quickstart)

![изображение](https://github.com/user-attachments/assets/5ee9e296-1654-4bf4-bc66-1d48210d6a3d)

- [уandex cloud cli](https://cloud.yandex.com/ru/docs/cli/quickstart) Так же инициализируйте профиль с помощью ```yc init``` .

![изображение](https://github.com/user-attachments/assets/9cf616ac-454c-459f-8a2e-7934e8e449c8)

![изображение](https://github.com/user-attachments/assets/4aaed2a6-88fd-4682-829b-783612f7e12a)


Примечание: Облачная ВМ с Linux в данной задаче не подойдёт из-за ограничений облачного провайдера. У вас просто не установится virtualbox.

## Задача 2

1. Убедитесь, что у вас есть ssh ключ в ОС или создайте его с помощью команды ```ssh-keygen -t ed25519```
2. Создайте виртуальную машину Virtualbox с помощью Vagrant и  [Vagrantfile](https://github.com/netology-code/virtd-homeworks/blob/shvirtd-1/05-virt-02-iaac/src/Vagrantfile) в директории src.

![изображение](https://github.com/user-attachments/assets/cad16650-28bb-462f-a0f6-5e1fe86c7ecf)

![изображение](https://github.com/user-attachments/assets/1f41584f-ad08-470c-a995-b1def2e1bb83)

4. Зайдите внутрь ВМ и убедитесь, что Docker установлен с помощью команды:
```
docker version && docker compose version
```

![изображение](https://github.com/user-attachments/assets/a7b8a6f4-d0d1-43ae-a0e0-f54ae5bf760f)

![изображение](https://github.com/user-attachments/assets/cb734eae-6cdc-4111-8c27-0377b3e14cae)

![изображение](https://github.com/user-attachments/assets/6720bf58-c5d4-4253-bf2a-29269dbca70e)

3. Если Vagrant выдаёт ошибку (блокировка трафика):
```
URL: ["https://vagrantcloud.com/bento/ubuntu-20.04"]     
Error: The requested URL returned error: 404:
```

Выполните следующие действия:

- Скачайте с [сайта](https://app.vagrantup.com/bento/boxes/ubuntu-20.04) файл-образ "bento/ubuntu-20.04".
- Добавьте его в список образов Vagrant: "vagrant box add bento/ubuntu-20.04 <путь к файлу>".

![изображение](https://github.com/user-attachments/assets/91dccdc6-dc32-4883-b0e4-8b2724ac2151)


**Важно:**    
- Если ваша хостовая рабочая станция - это windows ОС, то у вас могут возникнуть проблемы со вложенной виртуализацией. Ознакомиться со cпособами решения можно [по ссылке](https://www.comss.ru/page.php?id=7726).

- Если вы устанавливали hyper-v или docker desktop, то  все равно может возникать ошибка:  
`Stderr: VBoxManage: error: AMD-V VT-X is not available (VERR_SVM_NO_SVM)`   
 Попробуйте в этом случае выполнить в Windows от администратора команду `bcdedit /set hypervisorlaunchtype off` и перезагрузиться.

- Если ваша рабочая станция в меру различных факторов не может запустить вложенную виртуализацию - допускается неполное выполнение(до ошибки запуска ВМ)

## Задача 3

1. Отредактируйте файл    [mydebian.json.pkr.hcl](https://github.com/netology-code/virtd-homeworks/blob/shvirtd-1/05-virt-02-iaac/src/mydebian.json.pkr.hcl)  или [mydebian.jsonl](https://github.com/netology-code/virtd-homeworks/blob/shvirtd-1/05-virt-02-iaac/src/mydebian.json) в директории src (packer умеет и в json, и в hcl форматы):
   - добавьте в скрипт установку docker. Возьмите скрипт установки для debian из  [документации](https://docs.docker.com/engine/install/debian/)  к docker, 
   - дополнительно установите в данном образе htop и tmux.(не забудьте про ключ автоматического подтверждения установки для apt)

![изображение](https://github.com/user-attachments/assets/14382eba-4fd5-4903-8636-374f8491971b)

![изображение](https://github.com/user-attachments/assets/5bfb461f-2345-434e-b5af-eddb2269599f)

![изображение](https://github.com/user-attachments/assets/4cbacf4c-c73a-449a-8d33-52d9e02d1758)

2. Найдите свой образ в web консоли yandex_cloud

![изображение](https://github.com/user-attachments/assets/2fa27ebb-963c-4f62-a617-612a66d5eb01)

3. Необязательное задание(*): найдите в документации yandex cloud как найти свой образ с помощью утилиты командной строки "yc cli".

![изображение](https://github.com/user-attachments/assets/eb284e9e-eeef-4766-9765-44e375758783)

4. Создайте новую ВМ (минимальные параметры) в облаке, используя данный образ.

![изображение](https://github.com/user-attachments/assets/930aaef4-68d2-4c1a-97b9-72001b8b6210)

5. Подключитесь по ssh и убедитесь в наличии установленного docker.

![изображение](https://github.com/user-attachments/assets/c3d80bc1-8bab-4394-b0ae-565b181ab424)

6. Удалите ВМ и образ.

![изображение](https://github.com/user-attachments/assets/5dc52888-d9ca-4c3f-b5f1-0178736b7f6f)

7. **ВНИМАНИЕ!** Никогда не выкладываете oauth token от облака в git-репозиторий! Утечка секретного токена может привести к финансовым потерям. После выполнения задания обязательно удалите секретные данные из файла mydebian.json и mydebian.json.pkr.hcl. (замените содержимое токена на  "ххххх")
8. В качестве ответа на задание  загрузите результирующий файл в ваш ЛК.

Мой 
[mydebian.json](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/15_Virtualizaciya_and_kontejnerizaciya/mydebian.json)
