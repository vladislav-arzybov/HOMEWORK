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

3. Сохраните необходимые шаги, запустите первую сборку master.

![изображение](https://github.com/user-attachments/assets/71ac7930-ae93-4741-95f1-cc47606e72af)

4. Поменяйте условия сборки: если сборка по ветке `master`, то должен происходит `mvn clean deploy`, иначе `mvn clean test`.

![изображение](https://github.com/user-attachments/assets/23035e3d-87f8-4ea3-af95-cfe5b74a9f15)

![изображение](https://github.com/user-attachments/assets/f4bdcb1a-7fc1-40d3-b507-8dfd978e2df5)

![изображение](https://github.com/user-attachments/assets/7ddc5e3e-3468-4afd-a1f9-a090484118c5)

5. Для deploy будет необходимо загрузить [settings.xml](./teamcity/settings.xml) в набор конфигураций maven у teamcity, предварительно записав туда креды для подключения к nexus.

![изображение](https://github.com/user-attachments/assets/328da5ce-c42d-4501-a7a0-b00d169e2dfc)

6. В pom.xml необходимо поменять ссылки на репозиторий и nexus.

```
	<distributionManagement>
		<repository>
				<id>nexus</id>
				<url>http://51.250.44.134:8081/repository/maven-releases</url>
		</repository>
	</distributionManagement>
```

7. Запустите сборку по master, убедитесь, что всё прошло успешно и артефакт появился в nexus.

![изображение](https://github.com/user-attachments/assets/109894d0-07c4-495b-99d2-ad45ccf56b2c)

![изображение](https://github.com/user-attachments/assets/25781e97-3e6e-4ee2-8d70-a2a10f812a50)

8. Мигрируйте `build configuration` в репозиторий.

![изображение](https://github.com/user-attachments/assets/e05c218d-85db-4e24-a5c2-574370b8b28c)

![изображение](https://github.com/user-attachments/assets/7036465c-351a-437e-ae7c-193b1afa8cb2)

9. Создайте отдельную ветку `feature/add_reply` в репозитории.

![изображение](https://github.com/user-attachments/assets/b1b3088d-4284-4075-9f56-71e83c64ce59)

10. Напишите новый метод для класса Welcomer: метод должен возвращать произвольную реплику, содержащую слово `hunter`.

```
#Welcomer.java

	public String sayHelp(){
		return "Can I help you hunter?";
	}
```

11. Дополните тест для нового метода на поиск слова `hunter` в новой реплике.

```
#WelcomerTest.java

	@Test
	public void welcomerSaysHelp(){
		assertThat(welcomer.sayHelp(), containsString("hunter"));
	}
```

12. Сделайте push всех изменений в новую ветку репозитория.

![изображение](https://github.com/user-attachments/assets/32620c2b-abdc-4816-a3c6-991e96ae809a)

13. Убедитесь, что сборка самостоятельно запустилась, тесты прошли успешно.

![изображение](https://github.com/user-attachments/assets/5658c4d6-f74b-4fac-b91f-6dfaaa6e2abe)

![изображение](https://github.com/user-attachments/assets/f2497b5b-6b42-4bf1-b829-84eb8bd2623b)

14. Внесите изменения из произвольной ветки `feature/add_reply` в `master` через `Merge`.

![изображение](https://github.com/user-attachments/assets/410a8f3f-9ede-490e-9f38-4c069dee816b)

15. Убедитесь, что нет собранного артефакта в сборке по ветке `master`.

![изображение](https://github.com/user-attachments/assets/2686d93a-4336-42da-a401-7daf6d0b5d73)

![изображение](https://github.com/user-attachments/assets/ddc95967-5825-46d6-b724-ea788ada1100)

```
Failed to execute goal org.apache.maven.plugins:maven-deploy-plugin:3.1.1:deploy (default-deploy) on project plaindoll: Failed to deploy artifacts: Could not transfer artifact org.netology:plaindoll:pom:0.0.1 from/to nexus (http://51.250.44.134:8081/repository/maven-releases): status code: 400, reason phrase: Repository does not allow updating assets: maven-releases (400)
```

16. Настройте конфигурацию так, чтобы она собирала `.jar` в артефакты сборки.

![изображение](https://github.com/user-attachments/assets/f3501e27-2d79-4aec-86a8-fdfe150a767d)

Также настроено версионирование сборок

```
<groupId>org.netology</groupId>
	<artifactId>plaindoll</artifactId>
	<packaging>jar</packaging>
	<version>${version.long}</version>

	<properties>
		<maven.compiler.source>1.8</maven.compiler.source>
		<maven.compiler.target>1.8</maven.compiler.target>
		<version.short>0.0.1</version.short>
		<version.long>${version.short}B${build.number}</version.long>
	</properties>
```

17. Проведите повторную сборку мастера, убедитесь, что сбора прошла успешно и артефакты собраны.

![изображение](https://github.com/user-attachments/assets/4a0a4153-1adb-4270-8a84-5c2ff0301605)

![изображение](https://github.com/user-attachments/assets/d85bae7f-b0e5-4922-ad09-9909c25fcfe7)

![изображение](https://github.com/user-attachments/assets/4fa6bb83-d5e9-4783-8baa-44f2370e9f92)

![изображение](https://github.com/user-attachments/assets/ec4a3368-42d7-447a-99da-a00e7cc6460d)

18. Проверьте, что конфигурация в репозитории содержит все настройки конфигурации из teamcity.

![изображение](https://github.com/user-attachments/assets/277613f4-5dcc-4b9a-9836-2d8a2d0f08f7)

19. В ответе пришлите ссылку на репозиторий.

[example-teamcity](https://github.com/vladislav-arzybov/example-teamcity.git)

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
