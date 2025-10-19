# Домашнее задание к занятию «Установка Kubernetes» - `Арзыбов Владислав`

### Цель задания

Установить кластер K8s.

### Чеклист готовности к домашнему заданию

1. Развёрнутые ВМ с ОС Ubuntu 20.04-lts.

<img width="1519" height="430" alt="изображение" src="https://github.com/user-attachments/assets/458bae25-874e-449d-af6c-b32f63f5586e" />

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция по установке kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/).
2. [Документация kubespray](https://kubespray.io/).

-----

### Задание 1. Установить кластер k8s с 1 master node

1. Подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды.
2. В качестве CRI — containerd.
3. Запуск etcd производить на мастере.
4. Способ установки выбрать самостоятельно.

### Решение

В качестве инструмента для развертывания Kubernetes выбран RKE2, т.к. в нём в качестве container runtime используется containerd, с запущенны etcd на мастер ноде.

1. Установка RKE2 на мастер ноде выполняется под root, скачиваем и запускаем инсталлятор:
- sudo su
- curl -sfL https://get.rke2.io | sh -

<img width="1159" height="148" alt="изображение" src="https://github.com/user-attachments/assets/1faaef50-45dd-45ce-91c0-322d9f7ec09a" />

2. Создаем конфиг файл с содержимым ```write-kubeconfig-mode: "0644"```, предоставляем доступ к файлу kubeconfig на чтение без привилегий root, выдаем права доступа 0644.
- mkdir -p /etc/rancher/rke2/
- nano /etc/rancher/rke2/config.yaml

<img width="287" height="47" alt="изображение" src="https://github.com/user-attachments/assets/b2459948-9498-4fb8-9980-3ff06397d5f5" />

3. Запускаем сервис на мастер ноде и проверяем статус
- systemctl enable --now rke2-server.service
- systemctl status rke2-server.service

<img width="1223" height="39" alt="изображение" src="https://github.com/user-attachments/assets/31a26652-748a-409e-a5be-5d3feb7ca4ad" />

<img width="1250" height="235" alt="изображение" src="https://github.com/user-attachments/assets/ca6d0a95-755a-425c-9046-e693e8a959c0" />

4. Указываем путь к конфигу rke2
- export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
- export PATH=$PATH:/var/lib/rancher/rke2/bin

<img width="714" height="38" alt="изображение" src="https://github.com/user-attachments/assets/8c5c1434-76f5-42df-b962-4d48ac181fed" />

5. Проверяем статус
- kubectl get nodes
- kubectl get po -A

<img width="668" height="58" alt="изображение" src="https://github.com/user-attachments/assets/220f3ea1-1054-4766-9ba1-ab53670224a2" />

<img width="947" height="382" alt="изображение" src="https://github.com/user-attachments/assets/b6754a53-4911-42fe-ae65-35a633460386" />

6. Получаем token для worker-нод
- cat /var/lib/rancher/rke2/server/node-token

<img width="986" height="38" alt="изображение" src="https://github.com/user-attachments/assets/26c35aca-5634-43d4-9a5b-29f33718f745" />

7. Аналогичным образом под root выполняется установка агента на worker нодах
- sudo su
- curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" sh -

<img width="1104" height="148" alt="изображение" src="https://github.com/user-attachments/assets/c85235f3-3a6d-42b0-bee3-c2a8983c8a94" />

8. Создаем конфиг файл для подключения агента, в содержимом указываем локальный ip master ноды и ранее полученный token
- mkdir -p /etc/rancher/rke2/
- nano /etc/rancher/rke2/config.yaml

<img width="1094" height="64" alt="изображение" src="https://github.com/user-attachments/assets/12b65665-ab1a-4fb2-ab4d-1268a0215869" />

9. Запускаем агент на worker ноде и проверяем статус
- systemctl enable --now rke2-agent.service
- systemctl status rke2-agent.service

<img width="1177" height="40" alt="изображение" src="https://github.com/user-attachments/assets/40910e06-60a3-4675-a233-d44a76b72b26" />

<img width="1256" height="236" alt="изображение" src="https://github.com/user-attachments/assets/5afd22ef-a144-4613-aad1-6a4e522689c3" />

10. После установки агента на всех 4х worker нодах проверяем состояние кластера с master ноды
- kubectl get nodes
- kubectl get pods -n kube-system -o wide
- kubectl get --raw='/readyz?verbose'

<img width="690" height="130" alt="изображение" src="https://github.com/user-attachments/assets/76a44260-9d8a-407a-818d-eb27ea41a5b3" />

<img width="1413" height="618" alt="изображение" src="https://github.com/user-attachments/assets/ea5bef20-2b42-43bd-9a4a-fc4540129c2a" />

<img width="702" height="688" alt="изображение" src="https://github.com/user-attachments/assets/9e3f9fe3-1a4f-4ede-8cfa-ac98697391fa" />



## Дополнительные задания (со звёздочкой)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.** Их выполнение поможет глубже разобраться в материале.   
Задания под звёздочкой необязательные к выполнению и не повлияют на получение зачёта по этому домашнему заданию. 

------
### Задание 2*. Установить HA кластер

1. Установить кластер в режиме HA.
2. Использовать нечётное количество Master-node.
3. Для cluster ip использовать keepalived или другой способ.

### Решение

Подготовим 6 ВМ, 3 master ноды и 3 worker ноды, саму установку будем проводить с локальной ВМ по усправление OS Linux Ubuntu

<img width="1499" height="476" alt="изображение" src="https://github.com/user-attachments/assets/66fa74e2-7ba9-44bb-bf0d-0aa1c1f3e184" />

1. Cкачиваем репозиторий в домашний каталог:
- git clone https://github.com/kubernetes-sigs/kubespray.git

<img width="780" height="146" alt="изображение" src="https://github.com/user-attachments/assets/e14af03f-075b-4068-8c97-70b16701854d" />

2. Проверяем текущую версию python3, устанавливаем модуль для создания окружений
- python3 --version
- sudo apt update
- sudo apt install python3.10-venv

<img width="396" height="37" alt="изображение" src="https://github.com/user-attachments/assets/c1c24d28-caf3-4680-b464-f8b55b7e836e" />

3. Создаем окружение, активируем окружение, переходим в каталог kubespray
- python3 -m venv venv
- source venv/bin/activate
- cd kubespray

<img width="410" height="56" alt="изображение" src="https://github.com/user-attachments/assets/f1bf304b-1d83-4ce3-a87c-7a8434603489" />

4. Устанавливаем зависимости
- pip install -r requirements.txt

<img width="1755" height="239" alt="изображение" src="https://github.com/user-attachments/assets/59f6e208-fcf2-4d83-95c0-135a694cc01e" />

5. Копируем шаблоны в новый каталог
- cp -rfp inventory/sample/ inventory/mycluster

<img width="587" height="125" alt="изображение" src="https://github.com/user-attachments/assets/795fbe38-e37a-4b42-a511-7596a354d86b" />

6. Редактируем inventory.ini, указываем количество нод, название и их ip адреса
- nano inventory/mycluster/inventory.ini

<img width="782" height="227" alt="изображение" src="https://github.com/user-attachments/assets/28d991e1-c2f2-4dc4-a4e6-10b06e6d07ba" />

7. Запускаем установку
- ansible-playbook -i inventory/mycluster/inventory.ini cluster.yml -b -v

<img width="1838" height="546" alt="изображение" src="https://github.com/user-attachments/assets/667ab848-6c63-435a-9db4-6ccce9c193ea" />

8. Подключаемся на первую мастер ноду, копируем конфи для работы kubectl
- mkdir -p $HOME/.kube
- sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
- sudo chown $(id -u):$(id -g) $HOME/.kube/config

<img width="745" height="61" alt="изображение" src="https://github.com/user-attachments/assets/4477c3e8-77e8-412b-8d4b-9b18692048ee" />

9. Проверяем работу кластера
- kubectl get nodes
- kubectl get pods -n kube-system -o wide

<img width="532" height="145" alt="изображение" src="https://github.com/user-attachments/assets/d90b65a3-3a01-41a0-8b15-01a603b49ad0" />

<img width="1354" height="653" alt="изображение" src="https://github.com/user-attachments/assets/30f9b94c-0ac8-4d63-9fc6-7dd709f62276" />

10. Проверяем наличие CRI — containerd, должны быть записи k8s.io
- ctr --namespace=k8s.io containers ls

<img width="1294" height="349" alt="изображение" src="https://github.com/user-attachments/assets/9c1cec1f-1fb9-4a07-b2f4-51c0a711bebb" />

11. Проверяем установку и статус etcd на мастер нодах
- etcd --version
- systemctl status etcd.service

<img width="862" height="274" alt="изображение" src="https://github.com/user-attachments/assets/ccefaa4e-a88a-49d5-8ba9-cd46e7dfe20f" />

12. Настраиваем kubectl для подсключения с локальной ВМ
- curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
- chmod +x ./kubectl
- sudo mv ./kubectl /usr/local/bin/kubectl
- source <(kubectl completion bash)

13. Создаем папку для конфига k8s
- mkdir -p $HOME/.kube
- scp reivol@51.250.43.54:$HOME/.kube/config $HOME/.kube/config
- ```sudo chown $(id -u):$(id -g) $HOME/.kube/config```


### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl get nodes`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
