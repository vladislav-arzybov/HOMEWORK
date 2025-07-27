# Домашнее задание к занятию Troubleshooting

### Цель задания

Устранить неисправности при деплое приложения.

### Чеклист готовности к домашнему заданию

1. Кластер K8s.

### Задание. При деплое приложение web-consumer не может подключиться к auth-db. Необходимо это исправить

1. Установить приложение по команде:
```shell
kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
```

<img width="1533" height="75" alt="изображение" src="https://github.com/user-attachments/assets/26faf03c-bad6-4b05-9259-6578fd6f0a14" />

Приложения создаются в разных namespaces которые предварительно отсутствуют в кластере.

<img width="422" height="72" alt="изображение" src="https://github.com/user-attachments/assets/955e4a59-99fc-46f3-af45-2af564198fcb" />

<img width="1140" height="74" alt="изображение" src="https://github.com/user-attachments/assets/669eb5f3-cd9c-419e-895c-08914e1fee9e" />

2. Выявить проблему и описать.

Проверяем что поды запущены и с ними всё хорошо

<img width="615" height="128" alt="изображение" src="https://github.com/user-attachments/assets/480e6039-ad50-4c4f-838a-5c0808574f44" />

Проверяем привязку сервиса

<img width="757" height="60" alt="изображение" src="https://github.com/user-attachments/assets/7ba2d3c6-8f2c-48a6-b743-2407e73e0126" />

Проверяем доступность приложения из контейнера

<img width="696" height="485" alt="изображение" src="https://github.com/user-attachments/assets/4da980e2-d108-4123-8713-8ee4a4877e73" />

Проверяем логи приложения web-consumer, видим ошибку подключения к сервису auth-db

<img width="625" height="73" alt="изображение" src="https://github.com/user-attachments/assets/92ee380d-3e88-4f3e-bc11-86508b4026bc" />

3. Исправить проблему, описать, что сделано.

4. Продемонстрировать, что проблема решена.


### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
