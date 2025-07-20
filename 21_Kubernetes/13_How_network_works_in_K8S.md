# Домашнее задание к занятию «Как работает сеть в K8s» - `Арзыбов Владислав`

### Цель задания

Настроить сетевую политику доступа к подам.

### Чеклист готовности к домашнему заданию

1. Кластер K8s с установленным сетевым плагином Calico.

<img width="503" height="147" alt="изображение" src="https://github.com/user-attachments/assets/1a8afcb0-4bbc-4e34-a13c-5c2fcc494e22" />

<img width="1321" height="272" alt="изображение" src="https://github.com/user-attachments/assets/7cc84e48-dbf1-40f9-955b-10159398d1a8" />

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Calico](https://www.tigera.io/project-calico/).
2. [Network Policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/).
3. [About Network Policy](https://docs.projectcalico.org/about/about-network-policy).

-----

### Задание 1. Создать сетевую политику или несколько политик для обеспечения доступа

1. Создать deployment'ы приложений frontend, backend и cache и соответсвующие сервисы.



2. В качестве образа использовать network-multitool.
3. Разместить поды в namespace App.

- kubectl create namespace app
- kubectl get pod -n app
- kubectl get svc -n app -o wide

<img width="490" height="37" alt="изображение" src="https://github.com/user-attachments/assets/a69fbc6d-738a-4cb2-abd4-d9afc59e5c61" />

<img width="784" height="184" alt="изображение" src="https://github.com/user-attachments/assets/556b600c-4a2c-4886-8515-25d30c1a7d83" />

4. Создать политики, чтобы обеспечить доступ frontend -> backend -> cache. Другие виды подключений должны быть запрещены.



5. Продемонстрировать, что трафик разрешён и запрещён.

#### Проверяем возможность подключения с подов до применения политик

- kubectl -n app exec frontend-6897db7dcc-k492p -ti -- bash

<img width="761" height="128" alt="изображение" src="https://github.com/user-attachments/assets/e1e7f58c-343b-4d98-90fd-1adf9bcd02aa" />

- kubectl -n app exec backend-bb6d7b88c-9s2hl -ti -- bash

<img width="755" height="127" alt="изображение" src="https://github.com/user-attachments/assets/1752f552-88d8-4060-9501-b312c0b00349" />

- kubectl -n app exec cache-ff79687df-5fg74 -ti -- bash

<img width="722" height="128" alt="изображение" src="https://github.com/user-attachments/assets/52a7feab-0d59-4946-a718-5445f6bdc620" />

#### Включаем политику запрещающую любые сетевые подключени

- kubectl get networkpolicies.networking.k8s.io -n app

<img width="718" height="59" alt="изображение" src="https://github.com/user-attachments/assets/eaaad34a-ef9c-4fd3-b8c2-0e2480959f8b" />

<img width="422" height="38" alt="изображение" src="https://github.com/user-attachments/assets/b03172c1-6d01-4616-af6b-76c0be9a2f87" />

<img width="407" height="36" alt="изображение" src="https://github.com/user-attachments/assets/6bfe98b0-994c-4955-a6ef-edf07a93c774" />

<img width="397" height="34" alt="изображение" src="https://github.com/user-attachments/assets/c0a06ba4-4a90-48a6-95b2-122f41889c8d" />


#### Включаем политики для доступа по схеме frontend -> backend -> cache, проверяем доступы:

<img width="414" height="148" alt="изображение" src="https://github.com/user-attachments/assets/d88a6753-e73c-4413-b5b4-a0c0bb160ae9" />

<img width="408" height="147" alt="изображение" src="https://github.com/user-attachments/assets/4f8d6ca3-4cda-41ff-ab41-57263985d684" />

<img width="401" height="71" alt="изображение" src="https://github.com/user-attachments/assets/2c4de436-7619-458f-8433-b571a4acbc8d" />

Лишние сетевые доступы отсутствуют.


### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
