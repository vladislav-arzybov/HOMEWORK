# Домашнее задание к занятию «Хранение в K8s. Часть 2» - `Арзыбов Владислав`

### Цель задания

В тестовой среде Kubernetes нужно создать PV и продемострировать запись и хранение файлов.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным GitHub-репозиторием.

------

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке NFS в MicroK8S](https://microk8s.io/docs/nfs). 
2. [Описание Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/). 
3. [Описание динамического провижининга](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/). 
4. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1

**Что нужно сделать**

Создать Deployment приложения, использующего локальный PV, созданный вручную.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.

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
        - name: example-volume
          mountPath: /etc/out
      - name: multitool
        image: wbitt/network-multitool:latest
        volumeMounts:
        - name: example-volume
          mountPath: /etc/in
      volumes:
      - name: example-volume
        persistentVolumeClaim:
          claimName: example-pvc
```

2. Создать PV и PVC для подключения папки на локальной ноде, которая будет использована в поде.

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: example-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: ""
  resources:
    requests:
      storage: 1Gi
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: example-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: ""
  hostPath:
    path: "/mnt/data"
```

![изображение](https://github.com/user-attachments/assets/ffa67253-77c9-4617-8c19-eb5400edd507)

![изображение](https://github.com/user-attachments/assets/cd9ece63-19b0-4037-8cdd-d75cc69c41d9)

3. Продемонстрировать, что multitool может читать файл, в который busybox пишет каждые пять секунд в общей директории.

#### kubectl exec -ti vol-deployment-7b89677f-p5n5m -c busybox -- sh

![изображение](https://github.com/user-attachments/assets/e3be2518-340a-4ada-8758-276a6c391a9f)

#### kubectl exec -ti vol-deployment-7b89677f-p5n5m -c multitool -- sh

![изображение](https://github.com/user-attachments/assets/eb52fc89-ac72-4f71-a850-45e501f55de1)

4. Удалить Deployment и PVC. Продемонстрировать, что после этого произошло с PV. Пояснить, почему.

После удаления PVC PV перейдет в статус Released и его можно будет использовать повторно, также PV помнит PVC для которого был создан.

![изображение](https://github.com/user-attachments/assets/aeb10f64-565e-49a0-b2da-b536c8aa1553)


5. Продемонстрировать, что файл сохранился на локальном диске ноды. Удалить PV.  Продемонстрировать что произошло с файлом после удаления PV. Пояснить, почему.

![изображение](https://github.com/user-attachments/assets/0d189a5c-f6bc-4341-ab90-cef2d1fc57d1)

![изображение](https://github.com/user-attachments/assets/b1727c29-e349-4c6b-9b1d-26c58c69c7c1)

Файл не был удален, т.к. по умолчанию применяется политика ```persistentVolumeReclaimPolicy: Retain``` где значение Retain означает что после удаления PV данные удалены не будут.

6. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

[vol-deployment.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/07_Storage_in_K8s_Part_2/vol-deployment.yml)

------

### Задание 2

**Что нужно сделать**

Создать Deployment приложения, которое может хранить файлы на NFS с динамическим созданием PV.

1. Включить и настроить NFS-сервер на MicroK8S.

#### microk8s enable hostpath-storage

![изображение](https://github.com/user-attachments/assets/618604d3-060b-4fca-9de8-d8b7860c89cd)

2. Создать Deployment приложения состоящего из multitool, и подключить к нему PV, созданный автоматически на сервере NFS.

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nfs-deployment
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
      - name: multitool
        image: wbitt/network-multitool:latest
        volumeMounts:
        - name: example-volume
          mountPath: /etc/in
      volumes:
      - name: example-volume
        persistentVolumeClaim:
          claimName: example-pvc
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: example-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: "microk8s-hostpath"
  resources:
    requests:
      storage: 1Gi
```

![изображение](https://github.com/user-attachments/assets/ff40fd9b-c75c-4ee1-ab80-4e6840427542)

![изображение](https://github.com/user-attachments/assets/60d6425d-78c9-4ac7-86fb-8c883253a7dc)

3. Продемонстрировать возможность чтения и записи файла изнутри пода.

#### kubectl exec -it nfs-deployment-5c55ccfc49-zkrc8 -- sh

![изображение](https://github.com/user-attachments/assets/fd0326c8-c6cc-4637-835b-57e41ef5af8c)

Также можно проверить наличие файла внутри созданного хранилища, которое в этот раз будет удалено вместе с PVC

#### cat /var/snap/microk8s/common/default-storage/default-example-pvc-pvc-41007020-c7d7-4238-aa01-8589d636fdfe/test.txt

![изображение](https://github.com/user-attachments/assets/23e651ff-fb9b-4917-a3e4-cf1d1d306654)

4. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

[nfs-deployment.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/07_Storage_in_K8s_Part_2/nfs-deployment.yml)

------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
