# Домашнее задание к занятию «Управление доступом» - `Арзыбов Владислав`

### Цель задания

В тестовой среде Kubernetes нужно предоставить ограниченный доступ пользователю.

------

### Чеклист готовности к домашнему заданию

1. Установлено k8s-решение, например MicroK8S.
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым github-репозиторием.

------

### Инструменты / дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) RBAC.
2. [Пользователи и авторизация RBAC в Kubernetes](https://habr.com/ru/company/flant/blog/470503/).
3. [RBAC with Kubernetes in Minikube](https://medium.com/@HoussemDellai/rbac-with-kubernetes-in-minikube-4deed658ea7b).

------

### Задание 1. Создайте конфигурацию для подключения пользователя

1. Создайте и подпишите SSL-сертификат для подключения к кластеру.

#### Для удобства создаем новый каталог и копируем в него сертификаты k8s
- cp /var/snap/microk8s/current/certs/ca.crt .
- cp /var/snap/microk8s/current/certs/ca.key .

![изображение](https://github.com/user-attachments/assets/d0594922-acec-4f03-a56b-ef1072bb2da0)

#### Создаем и подписываем ключ для нового пользователя с использованием ранее скопированных сертификатов
- openssl genrsa -out arzybov_vs.key 2048
- openssl req -new -key arzybov_vs.key -out arzybov_vs.csr -subj "/CN=arzybov_vs/O=ops"
- openssl x509 -req -in arzybov_vs.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out arzybov_vs.crt -days 500

![изображение](https://github.com/user-attachments/assets/c712b06b-63ab-4c18-9809-f027ea6c345f)

2. Настройте конфигурационный файл kubectl для подключения.

#### Создаем пользователя arzybov_vs, присваиваем сертификат и ключ:
- kubectl config set-credentials arzybov_vs --client-certificate=arzybov_vs.crt --client-key=arzybov_vs.key --embed-certs=true

![изображение](https://github.com/user-attachments/assets/2176d42a-1f89-4218-a69f-8e8c50d44f49)

#### Создаем контекст для новго пользователя
- kubectl config set-context arzybov_vs --cluster=microk8s-cluster --user=arzybov_vs

![изображение](https://github.com/user-attachments/assets/fdf2a1e6-5d4a-4d07-9d12-ee3e7590499a)

#### Проверяем изменения в конфиге ~/.kube/config
- kubectl config view

![изображение](https://github.com/user-attachments/assets/2c85b269-8a04-4015-a367-74068955f361)

#### Включаем rbac в microk8s
- microk8s enable rbac

![изображение](https://github.com/user-attachments/assets/68219845-8031-40c7-ba74-2d678646ed2f)

#### Переклюаемся на нового пользователя, проверяем отсутствие прав на просмотр логов и конфигурации у ранее созданного pod nginx

![изображение](https://github.com/user-attachments/assets/e74391c3-79b2-43ba-a3de-df90ffa21a3a)

3. Создайте роли и все необходимые настройки для пользователя.

[role.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/09_Access_control/role.yml)

```
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: arzybov-role
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log"]
  verbs: ["get", "watch", "list"]
```

[role-binding.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/09_Access_control/role-binding.yml)

```
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: arzybov_role_binding
subjects:
- kind: User
  name: arzybov_vs
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: arzybov-role
  apiGroup: rbac.authorization.k8s.io
```

![изображение](https://github.com/user-attachments/assets/47c84fc6-2b34-4837-87c4-2cf8a5140bbd)

4. Предусмотрите права пользователя. Пользователь может просматривать логи подов и их конфигурацию (`kubectl logs pod <pod_id>`, `kubectl describe pod <pod_id>`).

#### Проверяем доступы после применения ролей

![изображение](https://github.com/user-attachments/assets/5c4e7e5f-3388-40e6-982c-615e1c954460)

Лишние доступы отсутствуют

![изображение](https://github.com/user-attachments/assets/438eebc5-1d61-4b6d-8c23-61b2b3f59b2b)

5. Предоставьте манифесты и скриншоты и/или вывод необходимых команд.

------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------

