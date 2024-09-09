# Домашнее задание к занятию «`Disaster recovery и Keepalived`» - `Арзыбов Владислав`

### Цель задания
В результате выполнения этого задания вы научитесь:
1. Настраивать отслеживание интерфейса для протокола HSRP;
2. Настраивать сервис Keepalived для использования плавающего IP

------

### Чеклист готовности к домашнему заданию

1. Установлена программа Cisco Packet Tracer
2. Установлена операционная система Ubuntu на виртуальную машину и имеется доступ к терминалу
3. Сделан клон этой виртуальной машины, они находятся в одной подсети и имеют разные IP адреса
4. Просмотрены конфигурационные файлы, рассматриваемые на лекции, которые находятся по [ссылке](1/)


------


### Задание 1
- Дана [схема](1/hsrp_advanced.pkt) для Cisco Packet Tracer, рассматриваемая в лекции.
- На данной схеме уже настроено отслеживание интерфейсов маршрутизаторов Gi0/1 (для нулевой группы)
- Необходимо аналогично настроить отслеживание состояния интерфейсов Gi0/0 (для первой группы).

  ![изображение](https://github.com/user-attachments/assets/55c256ab-906c-40ee-93fe-6118641f01ff)

- Для проверки корректности настройки, разорвите один из кабелей между одним из маршрутизаторов и Switch0 и запустите ping между PC0 и Server0.

  ![изображение](https://github.com/user-attachments/assets/93eeb3ad-12c5-48b3-a464-a0118d546c8d)

  ![изображение](https://github.com/user-attachments/assets/5cd5e603-6112-4eb7-bddc-2eb4e3d8ac10)

  разрываем соединение

  ![изображение](https://github.com/user-attachments/assets/fd725da1-d249-4513-bf7c-4eb030e2fc70)

  ![изображение](https://github.com/user-attachments/assets/b4d8299b-c588-4aee-9180-6ef23fdf3e7c)

  ![изображение](https://github.com/user-attachments/assets/01276caf-b7a8-4013-9e5f-4a671e7c338d)

- На проверку отправьте получившуюся схему в формате pkt и скриншот, где виден процесс настройки маршрутизатора.

  Обновленный файл: https://github.com/vladislav-arzybov/HOMEWORK/blob/main/10_Otkazoustojchivost/hsrp_advanced.pkt

------


### Задание 2
- Запустите две виртуальные машины Linux, установите и настройте сервис Keepalived как в лекции, используя пример конфигурационного [файла](1/keepalived-simple.conf).

  ![изображение](https://github.com/user-attachments/assets/a1014f9f-d45d-4f97-9343-9130f226fa20)

- Настройте любой веб-сервер (например, nginx или simple python server) на двух виртуальных машинах

  ![изображение](https://github.com/user-attachments/assets/988d0452-e7d4-436f-ac0c-ece9d22806b9)

- Напишите Bash-скрипт, который будет проверять доступность порта данного веб-сервера и существование файла index.html в root-директории данного веб-сервера.

```
#! /bin/bash
nginx_check() {
  if [[ -f /var/www/html/index.html ]] && [[ $(curl http://127.0.0.1 2> /dev/null) ]]; then
    return 0
  else 
    return 1
  fi;
}
nginx_check
```

- Настройте Keepalived так, чтобы он запускал данный скрипт каждые 3 секунды и переносил виртуальный IP на другой сервер, если bash-скрипт завершался с кодом, отличным от нуля (то есть порт веб-сервера был недоступен или отсутствовал index.html). Используйте для этого секцию vrrp_script

  ![изображение](https://github.com/user-attachments/assets/02e788db-1d42-4ce5-85a9-67ec34f21555)

- На проверку отправьте получившейся bash-скрипт и конфигурационный файл keepalived, а также скриншот с демонстрацией переезда плавающего ip на другой сервер в случае недоступности порта или файла index.html

  Ссылки на конфиги и скрипт:

  [nginx_check.sh](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/10_Otkazoustojchivost/nginx_check.sh)
  
  [keepalived.conf-master](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/10_Otkazoustojchivost/keepalived.conf-master)
  
  [keepalived.conf-backup](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/10_Otkazoustojchivost/keepalived.conf-backup)

  ![изображение](https://github.com/user-attachments/assets/849a7449-cd36-40e6-909c-fd13b9bdbcd1)

  ![изображение](https://github.com/user-attachments/assets/f131efa7-a0ab-4ed2-9e03-5384a496c015)

  Проверяем работу скрипта

  ![изображение](https://github.com/user-attachments/assets/41d797f0-4a2e-40b1-8446-037895b14563)

  ![изображение](https://github.com/user-attachments/assets/9831b594-7ce8-4ed5-b4e0-c8b706bd5290)


------

## Дополнительные задания со звёздочкой*

Эти задания дополнительные. Их можно не выполнять. На зачёт это не повлияет. Вы можете их выполнить, если хотите глубже разобраться в материале.
 
### Задание 3*
- Изучите дополнительно возможность Keepalived, которая называется vrrp_track_file
- Напишите bash-скрипт, который будет менять приоритет внутри файла в зависимости от нагрузки на виртуальную машину (можно разместить данный скрипт в cron и запускать каждую минуту). Рассчитывать приоритет можно, например, на основании Load average.

  
```
#! /bin/bash
a=$(cat /proc/loadavg | cut -d ' '  -f1)
b=100
x="$(echo "$a*$b" | bc -l | cut -d '.'  -f1)"
echo $x > /etc/track_nginx_file
```

- Настройте Keepalived на отслеживание данного файла.

  ![изображение](https://github.com/user-attachments/assets/3939f0f2-9f44-47a6-ac32-46d041f1281a)

- Нагрузите одну из виртуальных машин, которая находится в состоянии MASTER и имеет активный виртуальный IP и проверьте, чтобы через некоторое время она перешла в состояние SLAVE из-за высокой нагрузки и виртуальный IP переехал на другой, менее нагруженный сервер.

  ![изображение](https://github.com/user-attachments/assets/cef364bf-ae61-4b1f-8993-138357670b1f)

  Виртуальный ip установлен на мастер сервере
  
  ![изображение](https://github.com/user-attachments/assets/cee1c640-3021-4020-a6d2-fe62e21cf264)

  ![изображение](https://github.com/user-attachments/assets/d7b3b3e0-87aa-4425-a210-6cbfde24c848)

  Повышаем нагрузку чтобы виртуальный ip перешел на другой сервер

  ![изображение](https://github.com/user-attachments/assets/89c507f8-5546-4541-9d20-a76968abee95)

  ![изображение](https://github.com/user-attachments/assets/02969c8c-ad6b-4d2d-98aa-f9147f5ea35b)
  
- Попробуйте выполнить настройку keepalived на третьем сервере и скорректировать при необходимости формулу так, чтобы плавающий ip адрес всегда был прикреплен к серверу, имеющему наименьшую нагрузку.

  ![изображение](https://github.com/user-attachments/assets/512b539a-b1b9-4fe4-8691-cf8f8d46c072)

- На проверку отправьте получившийся bash-скрипт и конфигурационный файл keepalived, а также скриншоты логов keepalived с серверов при разных нагрузках

  ![изображение](https://github.com/user-attachments/assets/35be9ec7-8968-472e-9960-707ec192e82b)

    Ссылки на конфиги и скрипты:

  [keepalived_cron](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/10_Otkazoustojchivost/keepalived_cron)

  [script_track_nginx_file.sh](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/10_Otkazoustojchivost/nginx_check.sh)

  [keepalived.conf-master](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/10_Otkazoustojchivost/keepalived.conf-master)
  
  [keepalived.conf-backup](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/10_Otkazoustojchivost/keepalived.conf-backup)


------

### Правила приема работы

1. Необходимо следовать инструкции по выполнению домашнего задания, используя для оформления репозиторий Github
2. В ответе необходимо прикладывать требуемые материалы - скриншоты, конфигурационные файлы, скрипты. Необходимые материалы для получения зачета указаны в каждом задании.
