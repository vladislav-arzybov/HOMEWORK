# Домашнее задание к занятию «Базовые объекты K8S» - `Арзыбов Владислав`

### Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Pod с приложением и подключиться к нему со своего локального компьютера. 

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. Описание [Pod](https://kubernetes.io/docs/concepts/workloads/pods/) и примеры манифестов.
2. Описание [Service](https://kubernetes.io/docs/concepts/services-networking/service/).

------

### Задание 1. Создать Pod с именем hello-world

1. Создать манифест (yaml-конфигурацию) Pod.

[hello-world.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/02_Base_objects_K8S/hello-world.yml)

```
apiVersion: v1
kind: Pod
metadata:
  name: hello-world
  labels:
    app: hello
spec:
  containers:
    - name: hello-world
      image: gcr.io/kubernetes-e2e-test-images/echoserver:2.2
```

2. Использовать image - gcr.io/kubernetes-e2e-test-images/echoserver:2.2.

![изображение](https://github.com/user-attachments/assets/ff117ce1-218c-4675-91dc-9ca3176c7dea)

4. Подключиться локально к Pod с помощью `kubectl port-forward` и вывести значение (curl или в браузере).

#### kubectl port-forward pod/hello-world 8087:8080

![изображение](https://github.com/user-attachments/assets/bd89eab3-fd10-4356-b2e9-a785835dc4d7)

![изображение](https://github.com/user-attachments/assets/4f7015e2-38b7-4514-8ec9-fd5cb0e78f83)

------

### Задание 2. Создать Service и подключить его к Pod

1. Создать Pod с именем netology-web.

[netology-web.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/02_Base_objects_K8S/netology-web.yml)

```
apiVersion: v1
kind: Pod
metadata:
  name: netology-web
  labels:
    app: web
spec:
  containers:
    - name: netology-web
      image: gcr.io/kubernetes-e2e-test-images/echoserver:2.2
```

2. Использовать image — gcr.io/kubernetes-e2e-test-images/echoserver:2.2.

![изображение](https://github.com/user-attachments/assets/9815d568-9979-499d-b111-8f52d8171120)

3. Создать Service с именем netology-svc и подключить к netology-web.

[netology-svc.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/02_Base_objects_K8S/netology-svc.yml)

```
apiVersion: v1
kind: Service
metadata:
  name: netology-svc
spec:
  selector:
    app: web
  ports:
    - name: netology-port
      protocol: TCP
      port: 80
      targetPort: 8080
```

![изображение](https://github.com/user-attachments/assets/e21c5a33-7f8e-4101-920b-2968258e370d)

4. Подключиться локально к Service с помощью `kubectl port-forward` и вывести значение (curl или в браузере).

#### kubectl port-forward svc/netology-svc 8088:80

![изображение](https://github.com/user-attachments/assets/3568a9de-c616-41d4-8f6f-428c6aa0cdc4)

![изображение](https://github.com/user-attachments/assets/c3442eed-97af-422a-9721-77a42ce6e6fd)

------

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода команд `kubectl get pods`, а также скриншот результата подключения.
3. Репозиторий должен содержать файлы манифестов и ссылки на них в файле README.md.

------

### Критерии оценки
Зачёт — выполнены все задания, ответы даны в развернутой форме, приложены соответствующие скриншоты и файлы проекта, в выполненных заданиях нет противоречий и нарушения логики.

На доработку — задание выполнено частично или не выполнено, в логике выполнения заданий есть противоречия, существенные недостатки.
