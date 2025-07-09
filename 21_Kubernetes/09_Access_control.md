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

![изображение](https://github.com/user-attachments/assets/fdee25a5-fa62-4997-bc39-b70e08557208)

5. Создайте роли и все необходимые настройки для пользователя.
6. Предусмотрите права пользователя. Пользователь может просматривать логи подов и их конфигурацию (`kubectl logs pod <pod_id>`, `kubectl describe pod <pod_id>`).
7. Предоставьте манифесты и скриншоты и/или вывод необходимых команд.

------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------

