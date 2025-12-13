<img width="777" height="646" alt="изображение" src="https://github.com/user-attachments/assets/e5e5d641-0ca4-40c5-a79b-d22d1de0b872" />Необходимо удалить отдельный репозиторий с дипломом, удалить вебхук, обновить терраформ до 1.11.3, и по новой добавить lb с новой веткой, также сделать статичный ip и убрать внешние адреса у воркер нод

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

> - Для настройки atlantis потребуются GITHUB_TOKEN, а также AWS_ACCESS_KEY_ID и AWS_SECRET_ACCESS_KEY т.к. в работе используется s3 backend
> - Получаем GITHUB_TOKEN в настройках профиля github: Profile → Settings → Developer settings → Personal access tokens
> - AWS_ACCESS_KEY_ID и AWS_SECRET_ACCESS_KEY получаем из ранее созданного файла для настройки s3 backend - secret.backend.tfvars (access_key и secret_key)
> - Для передачи секретов используется файл .env, содержащий переменные окружения (GITHUB_TOKEN, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY).
> - Файл подключается в shell-сессию командой ```source .env```, после чего его значения используются при создании secret в kubernetes.
> - Дополнительно файл .env добавлен в .gitignore и не хранится в репозитории, пример содержимого внутри .env:

```
export GITHUB_TOKEN=xxxxx
export AWS_ACCESS_KEY_ID=xxxxx
export AWS_SECRET_ACCESS_KEY=xxxxx
```

> Добавляем переменные окружения командой: 
- source .env

> Дополнительно можно проверить, что переменные сохранились корректно, выполнив команды:
- echo $GITHUB_TOKEN
- echo $AWS_ACCESS_KEY_ID
- echo $AWS_SECRET_ACCESS_KEY

> Создаем новый namespace - atlantis:
- kubectl create namespace atlantis

<img width="656" height="38" alt="изображение" src="https://github.com/user-attachments/assets/d33f6ec7-f207-4d2b-b790-998eb53f6541" />

> Создаем secrets вручную, командой: 

```
kubectl create secret generic atlantis-env \
  -n atlantis \
  --from-literal=AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
  --from-literal=AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
  --from-literal=GITHUB_TOKEN="$GITHUB_TOKEN"
```

<img width="784" height="109" alt="изображение" src="https://github.com/user-attachments/assets/6864d74b-3638-4788-992d-1393859ce37a" />

> Проверяем что всё ок командой:
- kubectl get secrets -n atlantis

<img width="647" height="56" alt="изображение" src="https://github.com/user-attachments/assets/7d08a2e6-c55b-45ee-bdda-96887ead5a70" />

> Подготавливаем yaml манифесты для деплоя atlantis

[atlantis-cm.yaml]()
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: atlantis-config
  namespace: atlantis
data:
  repos.yaml: |
    repos:
      - id: /.*/
        branch: /.*/
        allowed_overrides: [apply_requirements]
        apply_requirements: [approved]
        workflow: default

  atlantis.yaml: |
    workflows:
      default:
        plan:
          steps:
            - init
            - plan
        apply:
          steps:
            - apply
```

[atlantis-deployment.yaml]()
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: atlantis
  namespace: atlantis
spec:
  replicas: 1
  selector:
    matchLabels:
      app: atlantis
  template:
    metadata:
      labels:
        app: atlantis
    spec:
      containers:
        - name: atlantis
          image: ghcr.io/runatlantis/atlantis:v0.34.0
          imagePullPolicy: IfNotPresent

          args:
            - server
            - --port=4141
            - --config=/etc/atlantis/repos.yaml
            - --repo-config=/etc/atlantis/atlantis.yaml
            - --gh-user=vladislav-arzybov
            - --repo-allowlist=github.com/vladislav-arzybov/*
            - --gh-token=$(GITHUB_TOKEN)

          envFrom:
            - secretRef:
                name: atlantis-env

          ports:
            - name: http
              containerPort: 4141

          volumeMounts:
            - name: atlantis-config
              mountPath: /etc/atlantis/atlantis.yaml
              subPath: atlantis.yaml
              readOnly: true
            - name: atlantis-config
              mountPath: /etc/atlantis/repos.yaml
              subPath: repos.yaml
              readOnly: true

      volumes:
        - name: atlantis-config
          configMap:
            name: atlantis-config
```

[atlantis-svc.yaml]()
```
apiVersion: v1
kind: Service
metadata:
  name: atlantis
  namespace: atlantis
spec:
  type: NodePort
  selector:
    app: atlantis
  ports:
  - protocol: TCP
    port: 80
    targetPort: 4141
    nodePort: 30003
```

> Запускаем установку:
- kubectl apply -f 05_atlantis/atlantis/

<img width="717" height="76" alt="изображение" src="https://github.com/user-attachments/assets/55fdc0da-04b5-4cd2-b21d-b4ccecc9f305" />

> Проверяем что всё работает и сервис доступен http://89.169.151.178:30003/
- kubectl get all -n atlantis

<img width="735" height="221" alt="изображение" src="https://github.com/user-attachments/assets/16897af9-52a2-4d35-a3b7-f43b417f723b" />

<img width="1452" height="625" alt="изображение" src="https://github.com/user-attachments/assets/9d96ddcf-cb2e-4e6e-be4f-1a6557f70853" />


### Дальнейшая настройка atlantis для работы

> Настраиваем Webhook, в настройках репозитория https://github.com/vladislav-arzybov/Diplom_vladislav_arzybov заходим в Настройки - Settings - Webhooks - Add webhook

<img width="806" height="110" alt="изображение" src="https://github.com/user-attachments/assets/7d00ca61-a21c-4cae-8fd6-ae99967c9824" />

- В ```Payload URL``` указываем ip мастера и порт atlantis'a http://89.169.144.92:30003/events
- В ```Content type``` - application/json
- В блоке ```Which events would you like to trigger this webhook?``` выбираем ```Let me select individual events.```, а затем выбираем:
> - Issue comments
> - Pull requests
> - Pull request reviews
> - Pushes

<img width="777" height="646" alt="изображение" src="https://github.com/user-attachments/assets/6bda4de9-94da-4c51-a9c8-59d446d1a974" />

> Нажимаем Add webhook

<img width="789" height="203" alt="изображение" src="https://github.com/user-attachments/assets/5365bded-2afa-4d20-b572-58d9e94cce0b" />

> Снова возвращаемся в настройки и проверяем что ping проходит

<img width="813" height="172" alt="изображение" src="https://github.com/user-attachments/assets/9e8e997d-85c0-4c0a-9739-9ff7b779ede8" />


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
