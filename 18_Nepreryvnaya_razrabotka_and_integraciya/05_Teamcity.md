# Домашнее задание к занятию 11 «Teamcity» - `Арзыбов Владислав`

## Подготовка к выполнению

1. В Yandex Cloud создайте новый инстанс (4CPU4RAM) на основе образа `jetbrains/teamcity-server`.

![изображение](https://github.com/user-attachments/assets/5d3a7730-810e-43a2-b407-4fd88935c718)

2. Дождитесь запуска teamcity, выполните первоначальную настройку.

![изображение](https://github.com/user-attachments/assets/d6cd7544-7d2c-46aa-a15d-6e55b976a59f)

![изображение](https://github.com/user-attachments/assets/811f5dc1-63eb-4b27-95d6-55c6820a711c)

3. Создайте ещё один инстанс (2CPU4RAM) на основе образа `jetbrains/teamcity-agent`. Пропишите к нему переменную окружения `SERVER_URL: "http://<teamcity_url>:8111"`.

![изображение](https://github.com/user-attachments/assets/38703ad6-4772-4e32-bb6c-d46f6eea67d1)

![изображение](https://github.com/user-attachments/assets/1da5f81a-9ebe-413d-9fd6-41d5d6e2fb02)

4. Авторизуйте агент.

![изображение](https://github.com/user-attachments/assets/c22eec2f-0396-4dac-88ba-feb1a9a73004)

5. Сделайте fork [репозитория](https://github.com/aragastmatb/example-teamcity).

- https://github.com/vladislav-arzybov/example-teamcity

6. Создайте VM (2CPU4RAM) и запустите [playbook](./infrastructure).

![изображение](https://github.com/user-attachments/assets/ce03e1d5-d99d-41dd-bfc4-161bd6ab765a)

![изображение](https://github.com/user-attachments/assets/aa92f9dc-9123-40d4-8723-7aad624b5bd2)


## Основная часть

1. Создайте новый проект в teamcity на основе fork.

![изображение](https://github.com/user-attachments/assets/8cff7428-f9a1-4e4d-802c-0d4304c70728)

2. Сделайте autodetect конфигурации.

![изображение](https://github.com/user-attachments/assets/acc6269d-d152-4cd5-9789-6635b2a59df2)

4. Сохраните необходимые шаги, запустите первую сборку master.

![изображение](https://github.com/user-attachments/assets/71ac7930-ae93-4741-95f1-cc47606e72af)

5. Поменяйте условия сборки: если сборка по ветке `master`, то должен происходит `mvn clean deploy`, иначе `mvn clean test`.

![изображение](https://github.com/user-attachments/assets/23035e3d-87f8-4ea3-af95-cfe5b74a9f15)

![изображение](https://github.com/user-attachments/assets/e288b3f4-3c26-410a-a3bd-e7ffbd827afa)

7. Для deploy будет необходимо загрузить [settings.xml](./teamcity/settings.xml) в набор конфигураций maven у teamcity, предварительно записав туда креды для подключения к nexus.

![изображение](https://github.com/user-attachments/assets/328da5ce-c42d-4501-a7a0-b00d169e2dfc)

9. В pom.xml необходимо поменять ссылки на репозиторий и nexus.

```
	<distributionManagement>
		<repository>
				<id>nexus</id>
				<url>http://51.250.44.134:8081/repository/maven-releases</url>
		</repository>
	</distributionManagement>
```

11. Запустите сборку по master, убедитесь, что всё прошло успешно и артефакт появился в nexus.
12. Мигрируйте `build configuration` в репозиторий.
13. Создайте отдельную ветку `feature/add_reply` в репозитории.
14. Напишите новый метод для класса Welcomer: метод должен возвращать произвольную реплику, содержащую слово `hunter`.
15. Дополните тест для нового метода на поиск слова `hunter` в новой реплике.
16. Сделайте push всех изменений в новую ветку репозитория.
17. Убедитесь, что сборка самостоятельно запустилась, тесты прошли успешно.
18. Внесите изменения из произвольной ветки `feature/add_reply` в `master` через `Merge`.
19. Убедитесь, что нет собранного артефакта в сборке по ветке `master`.
20. Настройте конфигурацию так, чтобы она собирала `.jar` в артефакты сборки.
21. Проведите повторную сборку мастера, убедитесь, что сбора прошла успешно и артефакты собраны.
22. Проверьте, что конфигурация в репозитории содержит все настройки конфигурации из teamcity.
23. В ответе пришлите ссылку на репозиторий.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
