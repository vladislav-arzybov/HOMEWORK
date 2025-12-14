### Деплой инфраструктуры в terraform pipeline

1. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте и настройте в кластере [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из CI/CD системы.

#### Решение

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

> Для автоматизации процесса деплоя необходимо также передать информацию о ```.authorized_key.json``` хранящимся локально, создаем секрет:

```
kubectl create secret generic atlantis-yc-sa \
  -n atlantis \
  --from-file=authorized_key.json=$HOME/.authorized_key.json
```

<img width="792" height="76" alt="изображение" src="https://github.com/user-attachments/assets/f312f2fa-fce9-463b-a227-a484d4d59824" />

> Ткже потребуется передать ssh public-key, чтобы не возникло ошибок при запуске Terraform внутри Atlantis

```
kubectl create secret generic ssh-public-key \
  -n atlantis \
  --from-file=ssh_public_key=$HOME/.ssh/id_rsa.pub
```

<img width="778" height="74" alt="изображение" src="https://github.com/user-attachments/assets/fb828519-0293-4dae-83b5-e1b6cde1c0d6" />

> Проверяем что всё ок командой:
- kubectl get secrets -n atlantis

<img width="632" height="94" alt="изображение" src="https://github.com/user-attachments/assets/b88f8187-2232-47ae-8e34-abe61a3359e4" />

> Подготавливаем yaml манифесты для деплоя atlantis

[atlantis-cm-terraform.yaml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/23_Diplom/05_atlantis/atlantis/01_atlantis-cm-terraform.yaml)
> Необходим для корректной работы atlantis с yandex cloud
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: terraform-cli-config
  namespace: atlantis
data:
  terraform.rc: |
    provider_installation {
      network_mirror {
        url     = "https://terraform-mirror.yandexcloud.net/"
        include = ["registry.terraform.io/*/*"]
      }
      direct {
        exclude = ["registry.terraform.io/*/*"]
      }
    }
```

[atlantis-cm.yaml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/23_Diplom/05_atlantis/atlantis/01_atlantis-cm.yaml)
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

[atlantis-deployment.yaml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/23_Diplom/05_atlantis/atlantis/02_atlantis-deployment.yaml)
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

          env:
            - name: TF_CLI_CONFIG_FILE
              value: /etc/terraform.d/terraform.rc

            - name: YC_SERVICE_ACCOUNT_KEY_FILE
              value: /home/atlantis/authorized_key.json

            - name: TF_VAR_ssh_public_key
              valueFrom:
                secretKeyRef:
                  name: ssh-public-key
                  key: ssh_public_key

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

            - name: terraform-cli-config
              mountPath: /etc/terraform.d/terraform.rc
              subPath: terraform.rc
              readOnly: true

            - name: yc-sa-key
              mountPath: /home/atlantis/authorized_key.json
              subPath: authorized_key.json
              readOnly: true

      volumes:
        - name: atlantis-config
          configMap:
            name: atlantis-config

        - name: terraform-cli-config
          configMap:
            name: terraform-cli-config

        - name: yc-sa-key
          secret:
            secretName: atlantis-yc-sa
```

[atlantis-svc.yaml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/23_Diplom/05_atlantis/atlantis/03_atlantis-svc.yaml)
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

<img width="786" height="92" alt="изображение" src="https://github.com/user-attachments/assets/0365c361-258d-4143-acc7-c71fdb2e1439" />

> Проверяем что всё работает
- kubectl get cm -n atlantis
- kubectl get all -n atlantis

<img width="739" height="310" alt="изображение" src="https://github.com/user-attachments/assets/b107d754-e08a-475c-b6f3-61d067190c7b" />

> Проверяем что сервис доступен из вне: http://89.169.151.178:30003/

<img width="1452" height="625" alt="изображение" src="https://github.com/user-attachments/assets/9d96ddcf-cb2e-4e6e-be4f-1a6557f70853" />


#### Настройка atlantis для работы с репозиторием

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

> Создаем новую ветку:
- git checkout -b test-atlantis

<img width="722" height="39" alt="изображение" src="https://github.com/user-attachments/assets/eb6cc1ca-0d1d-4b9f-9dd6-29fb8055495d" />

> Для теста добавляем network_load_balancer, чтобы обращения к приложению и графане могли осуществляться по 80 порту, по разным адресам.

[network_load_balancer.tf]()
```
# Создаем группу для балансировщика с включением всех нод
resource "yandex_lb_target_group" "k8s-nlb" {
  name       = "k8s-balancer-group"
  depends_on = [yandex_compute_instance.k8s]

  dynamic "target" {
    for_each = values(yandex_compute_instance.k8s)

    content {
      subnet_id = target.value.network_interface[0].subnet_id
      address   = target.value.network_interface[0].ip_address
    }
  }
}

# Настраиваем балансировщик для grafana
resource "yandex_lb_network_load_balancer" "grafana" {
  name = "grafana"

  listener {
    name        = "grafana-listener"
    port        = 80
    target_port = 30001
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = yandex_lb_target_group.k8s-nlb.id
    healthcheck {
      name = "healthcheck"
      tcp_options {
        port = 30001
      }
    }
  }

  depends_on = [yandex_lb_target_group.k8s-nlb]
}

# Настраиваем балансировщик для nginx
resource "yandex_lb_network_load_balancer" "nginx" {
  name = "nginx"
  listener {
    name        = "nginx-listener"
    port        = 80
    target_port = 30002
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = yandex_lb_target_group.k8s-nlb.id
    healthcheck {
      name = "healthcheck"
      tcp_options {
        port = 30002
      }
    }
  }
  depends_on = [yandex_lb_network_load_balancer.grafana]
}
```

> Пушим изменнеия в новую ветку:
- git add .
- git commit -m 'test-b'
- git push origin test-atlantis

<img width="897" height="342" alt="изображение" src="https://github.com/user-attachments/assets/30bfca49-8e61-4c4e-8410-ac6e39dc6137" />

> Проверяем что изменения передались в git, новая ветка с новым network_load_balancer.tf

<img width="917" height="501" alt="изображение" src="https://github.com/user-attachments/assets/cecb204b-f20e-40a2-88ef-bd703a1a16a8" />

> Переходим в Pull requests - нажимаем New pull request

<img width="1393" height="292" alt="изображение" src="https://github.com/user-attachments/assets/ddfbaf30-eb39-4235-8d63-1abf2d6d0ceb" />

> Выбираем процесс слияния из test-atlantis в main, нажимаем Create pull request

<img width="1243" height="235" alt="изображение" src="https://github.com/user-attachments/assets/0d17b200-ed12-4007-8cbc-2f6abc8f306d" />

> При необходимости можно указать заголовок и описание, затем нажать Create pull request

<img width="910" height="516" alt="изображение" src="https://github.com/user-attachments/assets/4624ab36-c74a-4134-94b4-dd567193468d" />

> После выполнения проверки откроется окно с инструкциями

<img width="851" height="653" alt="изображение" src="https://github.com/user-attachments/assets/4c30bb05-ff9e-4c26-9ba9-559023c2dd66" />

> Чтобы выполнить terrafform apply необходимо в поле ```Add a comment``` указать ```atlantis apply -d 02_k8s/02_infra``` и нажать Comment

<img width="854" height="636" alt="изображение" src="https://github.com/user-attachments/assets/b5168ebb-6672-4674-b3b0-51216fead092" />

> Изменения внесены успешно

<img width="874" height="612" alt="изображение" src="https://github.com/user-attachments/assets/d73d71e0-8235-4825-8399-7c2d6a0fdf5e" />

<img width="1481" height="671" alt="изображение" src="https://github.com/user-attachments/assets/c373ea5a-423b-445d-bfd5-74bb0875418b" />

<img width="1074" height="129" alt="изображение" src="https://github.com/user-attachments/assets/6e3f2f2a-793a-4fb6-9dc2-e1008964ef27" />

> Для внесения изменений в main ветку, необходимо нажать ```Merge pull request```

<img width="877" height="312" alt="изображение" src="https://github.com/user-attachments/assets/e9511a0c-6c4b-420c-8cd0-7676d3983676" />

<img width="910" height="427" alt="изображение" src="https://github.com/user-attachments/assets/191e8d8b-c76e-48d9-8bfb-54ebd7282772" />

<img width="1475" height="641" alt="изображение" src="https://github.com/user-attachments/assets/74aeba39-2117-4352-896f-df88d93d2394" />



Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
2. Http доступ на 80 порту к web интерфейсу grafana.
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
4. Http доступ на 80 порту к тестовому приложению.
5. Atlantis или terraform cloud или ci/cd-terraform
