# Домашнее задание к занятию «Хранение в K8s. Часть 1» - `Арзыбов Владислав`

### Цель задания

В тестовой среде Kubernetes нужно обеспечить обмен файлами между контейнерам пода и доступ к логам ноды.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным GitHub-репозиторием.

------

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке MicroK8S](https://microk8s.io/docs/getting-started).
2. [Описание Volumes](https://kubernetes.io/docs/concepts/storage/volumes/).
3. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1 

**Что нужно сделать**

Создать Deployment приложения, состоящего из двух контейнеров и обменивающихся данными.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.

[vol-deployment.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/06_Storage_in_K8s_Part_1/vol-deployment.yml)

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: vol-deployment
  labels:
    app: vol
spec:
  selector:
    matchLabels:
      app: vol
  template:
    metadata:
      labels:
        app: vol
    spec:
      containers:
      - name: busybox
        image: busybox:latest
        command: ['sh', '-c', 'while true; do echo "$(date)">>/etc/out/test.txt;sleep 5;done']
        volumeMounts:
        - name: test-vol
          mountPath: /etc/out
      - name: multitool
        image: wbitt/network-multitool:latest
        command: ['sh', '-c', 'while true; do cat /etc/in/test.txt;sleep 5;done']
        volumeMounts:
        - name: test-vol
          mountPath: /etc/in
      volumes:
      - name: test-vol
        emptyDir: {}
```

![изображение](https://github.com/user-attachments/assets/f4d5acbe-f379-478b-bd09-6d77e801a1b7)

2. Сделать так, чтобы busybox писал каждые пять секунд в некий файл в общей директории.

#### kubectl exec -it vol-deployment-5bcdf8854b-d4h4n -c busybox -- sh

![изображение](https://github.com/user-attachments/assets/ebace295-7e8a-4b19-842e-cd2d6198894c)

3. Обеспечить возможность чтения файла контейнером multitool.

#### kubectl logs deployments/vol-deployment multitool

![изображение](https://github.com/user-attachments/assets/ba844eb1-98bb-4e90-a734-3f661cb6b1ca)

4. Продемонстрировать, что multitool может читать файл, который периодоически обновляется.

#### kubectl exec -it vol-deployment-5bcdf8854b-d4h4n -c multitool -- sh

![изображение](https://github.com/user-attachments/assets/1c3182f4-846d-4608-ab04-0d0d09f8ceed)

5. Предоставить манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.

------

### Задание 2

**Что нужно сделать**

Создать DaemonSet приложения, которое может прочитать логи ноды.

1. Создать DaemonSet приложения, состоящего из multitool.

[vol-daemonset.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/06_Storage_in_K8s_Part_1/vol-daemonset.yml)

```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: vol-daemonset
  labels:
    app: vol-multitool
spec:
  selector:
    matchLabels:
      app: vol-multitool
  template:
    metadata:
      labels:
        app: vol-multitool
    spec:
      containers:
      - name: multitool
        image: wbitt/network-multitool:latest
        volumeMounts:
        - name: daemon-vol
          mountPath: /data/log
      volumes:
      - name: daemon-vol
        hostPath:
          path: /var/log
```

2. Обеспечить возможность чтения файла `/var/log/syslog` кластера MicroK8S.

![изображение](https://github.com/user-attachments/assets/c2d30f9e-7411-427c-a9bf-c61a48231644)

3. Продемонстрировать возможность чтения файла изнутри пода.

#### kubectl exec -it vol-daemonset-tbzrw -- sh

![изображение](https://github.com/user-attachments/assets/d2c5afe7-fdf9-4903-af3d-796bcc8f0c0a)

4. Предоставить манифесты Deployment, а также скриншоты или вывод команды из п. 2.

------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------
