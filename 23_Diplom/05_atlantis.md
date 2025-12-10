Необходимо удалить отдельный репозиторий с дипломом, удалить вебхук, обновить терраформ, и по новой добавить lb с новой веткой, также сделать статичный ip и убрать внешние адреса у воркер нод

### Деплой инфраструктуры в terraform pipeline

1. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте и настройте в кластере [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из CI/CD системы.

Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
2. Http доступ на 80 порту к web интерфейсу grafana.
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
4. Http доступ на 80 порту к тестовому приложению.
5. Atlantis или terraform cloud или ci/cd-terraform



# Решение

https://www.youtube.com/watch?v=sV9IBczE3IA

> Создаем отдельный namespace для atlantis
- kubectl create namespace atlantis

> Получаем GITHUB_TOKEN: Profile → Settings → Developer settings → Personal access tokens

> По аналогии с ранее созданным secret.backend.tfvars для передачи access_key и secret_key через файл не содержащийся в репозитории, токены GitHub и Yandex Cloud передаются в Kubernetes в виде переменных окружения из фала ```.env``` и используются при создании Secret без хранения значений в коде. Пример содержимого:

```
export GITHUB_TOKEN=xxxxx
export AWS_ACCESS_KEY_ID=xxxxx
export AWS_SECRET_ACCESS_KEY=xxxxx
```

> Добавляем переменные окружения: source .env

> Создаем secrets и проверяем: kubectl get secrets -n atlantis

```
kubectl create secret generic atlantis-env \
  -n atlantis \
  --from-literal=AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
  --from-literal=AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
  --from-literal=GITHUB_TOKEN="$GITHUB_TOKEN"
```

<img width="642" height="59" alt="изображение" src="https://github.com/user-attachments/assets/42ccf279-692d-4c6d-9312-050ed13ce9aa" />

> Также можно проверить что переменные сохранились корректно через команды:
- echo $GITHUB_TOKEN
- echo $AWS_ACCESS_KEY_ID
- echo $AWS_SECRET_ACCESS_KEY

> Дальше создаем yaml и запускаем поды, сервисы, и т.д (переменные хранятся в secret)
- kubectl get all -n atlantis

Удаление!
- kubectl delete -n atlantis secrets atlantis-github
- kubectl delete -n atlantis secrets yc-credentials
- kubectl delete -n atlantis secrets atlantis-env

Копирование!
- scp -r /home/reivol/Terraform2/05_diplom/atlantis reivol@46.21.246.134:/home/reivol/
- scp -r  reivol@46.21.246.134:/home/reivol/atlantis /home/reivol/Terraform2/05_diplom/atlantis/


#### Отладка

- kubectl get pods -n atlantis
- kubectl describe pod -n atlantis atlantis-666c5577c-rptpb
- kubectl logs -n atlantis atlantis-666c5577c-rptpb --previous

> Удаление
- kubectl -n atlantis delete deployments.apps atlantis 
- kubectl -n atlantis delete configmaps atlantis-config
- kubectl -n atlantis delete svc atlantis

> Установка
- kubectl apply -f atlantis-cm.yaml
- kubectl apply -f atlantis-deployment.yaml
- kubectl apply -f atlantis-svc.yaml


### Проверка работы atlantis

> Проверяем что сервис запустился, http://89.169.151.178:32001/

<img width="1214" height="652" alt="изображение" src="https://github.com/user-attachments/assets/19be5f85-c781-49e4-b9a5-1a351367ffde" />

> Настраиваем Webhook, в настройках репозитория https://github.com/vladislav-arzybov/Diplom_vladislav_arzybov заходим в Настройки - Settings - Webhooks - Add webhook

<img width="772" height="98" alt="изображение" src="https://github.com/user-attachments/assets/7805a311-4961-476f-b881-149c800577cc" />

- В ```Payload URL``` указываем ip мастера и порт atlantis'a http://89.169.151.178:32001/events
- В ```Content type``` - application/json
- В блоке ```Which events would you like to trigger this webhook?``` выбираем ```Let me select individual events.```, а затем выбираем: Issue comments, Pull requests, Pull request reviews, Pushes

<img width="781" height="659" alt="изображение" src="https://github.com/user-attachments/assets/e1f49615-764e-4e1e-8697-cd30ede3933f" />

> Нажимаем Add webhook

<img width="780" height="192" alt="изображение" src="https://github.com/user-attachments/assets/68daa725-1b93-4236-99b8-c10b96724249" />

> Снова возвращаемся в настройки и проверяем что ping проходит

<img width="796" height="182" alt="изображение" src="https://github.com/user-attachments/assets/0d9f1f16-7077-4e17-b397-fd408f002896" />


### Тестирование

> Копируем репозиторий: git@github.com:vladislav-arzybov/Diplom_vladislav_arzybov.git

<img width="889" height="147" alt="изображение" src="https://github.com/user-attachments/assets/4f0da461-e07c-44e3-96f3-5872bb388233" />

> Добавляем в него network_load_balancer.tf для работы балансировщика по 80 порту для приложения и графаны
- git add .
- git commit -m 'test-b'
- git checkout -b test-atlantis
- git push origin test-atlantis

<img width="958" height="383" alt="изображение" src="https://github.com/user-attachments/assets/32fa4266-fcdc-4d11-a07f-5fd4590d6370" />

> Проверяем что изменения передались в git, новая ветка с новым network_load_balancer.tf

<img width="917" height="501" alt="изображение" src="https://github.com/user-attachments/assets/cecb204b-f20e-40a2-88ef-bd703a1a16a8" />

> Переходим в Pull requests - нажимаем New pull request

<img width="1393" height="292" alt="изображение" src="https://github.com/user-attachments/assets/ddfbaf30-eb39-4235-8d63-1abf2d6d0ceb" />

> Выбираем процесс слияния из test-atlantis в main, нажимаем Create pull request

<img width="1243" height="235" alt="изображение" src="https://github.com/user-attachments/assets/0d17b200-ed12-4007-8cbc-2f6abc8f306d" />

> При необходимости можно указать заголовок и описание, затем нажать Create pull request

<img width="910" height="516" alt="изображение" src="https://github.com/user-attachments/assets/4624ab36-c74a-4134-94b4-dd567193468d" />
