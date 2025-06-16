# Домашнее задание к занятию «Kubernetes. Причины появления. Команда kubectl» - `Арзыбов Владислав`

### Цель задания

Для экспериментов и валидации ваших решений вам нужно подготовить тестовую среду для работы с Kubernetes. Оптимальное решение — развернуть на рабочей машине или на отдельной виртуальной машине MicroK8S.

------

### Чеклист готовности к домашнему заданию

1. Личный компьютер с ОС Linux или MacOS 

или

2. ВМ c ОС Linux в облаке либо ВМ на локальной машине для установки MicroK8S  

------

### Инструкция к заданию

1. Установка MicroK8S:
    - sudo apt update,
    - sudo apt install snapd,
    - sudo snap install microk8s --classic,
    - добавить локального пользователя в группу `sudo usermod -a -G microk8s $USER`,
    - изменить права на папку с конфигурацией `sudo chown -f -R $USER ~/.kube`.

2. Полезные команды:
    - проверить статус `microk8s status --wait-ready`;
    - подключиться к microK8s и получить информацию можно через команду `microk8s command`, например, `microk8s kubectl get nodes`;
    - включить addon можно через команду `microk8s enable`; 
    - список addon `microk8s status`;
    - вывод конфигурации `microk8s config`;
    - проброс порта для подключения локально `microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443`.

3. Настройка внешнего подключения:
    - отредактировать файл /var/snap/microk8s/current/certs/csr.conf.template
    ```shell
    # [ alt_names ]
    # Add
    # IP.4 = 123.45.67.89
    ```
    - обновить сертификаты `sudo microk8s refresh-certs --cert front-proxy-client.crt`.

4. Установка kubectl:
    - curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl;
    - chmod +x ./kubectl;
    - sudo mv ./kubectl /usr/local/bin/kubectl;
    - настройка автодополнения в текущую сессию `bash source <(kubectl completion bash)`;
    - добавление автодополнения в командную оболочку bash `echo "source <(kubectl completion bash)" >> ~/.bashrc`.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://microk8s.io/docs/getting-started) по установке MicroK8S.
2. [Инструкция](https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet/#bash) по установке автодополнения **kubectl**.
3. [Шпаргалка](https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet/) по **kubectl**.

------

### Задание 1. Установка MicroK8S

1. Установить MicroK8S на локальную машину или на удалённую виртуальную машину.

    - sudo apt update,
    - sudo apt install snapd,
    - sudo snap install microk8s --classic,
    - sudo usermod -a -G microk8s $USER
    - mkdir -p ~/.kube
    - chmod 0700 ~/.kube
    - sudo chown -f -R $USER ~/.kube

#### microk8s status --wait-ready
  
![изображение](https://github.com/user-attachments/assets/0546f3d6-d7a7-499c-b46b-add22f2f60ed)


2. Установить dashboard.

    - microk8s enable dashboard

![изображение](https://github.com/user-attachments/assets/1198d4c8-04d7-4f88-b40a-a30c514b1ff9)

3. Сгенерировать сертификат для подключения к внешнему ip-адресу.

    - nano /var/snap/microk8s/current/certs/csr.conf.template
    - sudo microk8s refresh-certs --cert front-proxy-client.crt

![изображение](https://github.com/user-attachments/assets/6460cd62-c157-4b86-90f1-c39b0354f6e4)


------

### Задание 2. Установка и настройка локального kubectl
1. Установить на локальную машину kubectl.

    - curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
    - chmod +x ./kubectl
    - sudo mv ./kubectl /usr/local/bin/kubectl

#### kubectl version

![изображение](https://github.com/user-attachments/assets/d20bf590-85f4-4a05-9f9a-dbe176e60639)

2. Настроить локально подключение к кластеру.

    - microk8s config > ~/.kube/config

#### kubectl version

![изображение](https://github.com/user-attachments/assets/bc34085f-ba34-4197-8328-7273ce8bfd69)

#### kubectl get nodes

![изображение](https://github.com/user-attachments/assets/6a3ae822-ac9e-4a47-ac15-73567ae338f0)


3. Подключиться к дашборду с помощью port-forward.

![изображение](https://github.com/user-attachments/assets/cb0c34fe-f1cd-4592-adaa-9306b4ad8795)

    - cd ~/.kube/
    - nano sa-dash.yml

```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kube-system
```

    - kubectl apply -f sa-dash.yml
    - kubectl -n kube-system create token admin-user
    
![изображение](https://github.com/user-attachments/assets/4f510603-ef6a-44e4-9dd4-9942fbf7505f)

https://localhost:10443/#/login

![изображение](https://github.com/user-attachments/assets/054c9697-279a-4f0a-a54a-bf38bd73f9d5)


------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода команд `kubectl get nodes` и скриншот дашборда.

