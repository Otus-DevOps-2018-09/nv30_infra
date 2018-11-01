# nv30_infra
nv30 Infra repository

## Homework-6:

 - Удалены ssh ключи из метаданных проекта.
 - Установлен Terraform v0.11.10. Загружен провайдер "google" v.1.4.0.
 - В main.tf описано создание одной VM из образа reddit-base. VM развернута.
 - В main.tf добавлено описание добавления ssh ключа в разворачиваемую **VM** (instance).
 - Добавлен outputs.tf, где описываются нужные нам выходные переменные из terraform.tfstate.
 - В main.tf добавлено описание создания правила tcp:9292 для FW. Добавлен тег для создаваемой VM, чтобы применялось это правило.
 - Созданы файлы deploy.sh и puma.service для деплоя приложения и создания systemd unit для веб сервера Puma.
 - В main.tf добавлены провиженеры для копирования файлов deploy.sh и puma.service на VM.
 - Проверена работа провиженеров, приложение деплоится и работает. На него можно зайти по http://app_external_ip:9292.
 - Добавлен variables.tf, в котором описаны нужные нам входные переменные. Соответствующие параметры в main.tf заменены ссылками на эти переменные.
 - Добавлен terraform.tfvars, где определяются переменные.
 - Добавлены переменные для приватного ключа и зоны.
 - Конфигурационные файлы отформатированы командой "terraform fmt".
 - Создан файл terraform.tfvars.example с примерами описаний переменных.
 - \*Описано добавление нескольких ключей пользователей в **метаданные проекта**.
   - _Проблемы_: При добавлении ключа пользователя в метаданные проекта через веб, Terraform при применении конфига через "terraform apply" затирает его теми, что описаны в конфигурационном файле.
 - \**Создан lb.tf с описанием создания HTTP балансировщика. Балансировщик развернут и приложение доступно на его ip.
 - \**Описано создание нескольких VM без лишнего кода, используя параметр **count**.
   - _Проблемы_: БД на разных VM в группе не синхронизированы, что делает балансировку нагрузки бессмысленной. Также, без применения параметра count, конфигурационный файл разрастается из-за лишнего описания каждой VM.

## Homework-5:

 - Установлен packer.
 - Создан ADC.
 - Создан шаблон для packer для образа семейства reddit-base.
 - Созданы скрипты для провижининга (установка Ruby и MongoDB).
 - Параметризирован шаблон для reddit-base. Переменные определены в шаблоне и заданы в отдельном файле variables.json.
 - Добавлены дополнительные опции builder для GCP (описание образа, размер и тип диска, сеть, теги, пользователь ssh).
 - Создан образ семейства reddit-full, в который запечены все необходимые для работы приложения зависимости.
 - Создана vm на базе образа reddit-full и проверена работа приложения "из коробки".
 - Создан скрипт для создания vm на базе образа reddit-full.

## Homework-4:

Команда для создания инстанса с использованием startup-script:

```
gcloud compute instances create reddit-app \
        --boot-disk-size=10GB \
        --image-family ubuntu-1604-lts \
        --image-project=ubuntu-os-cloud \
        --machine-type=g1-small \
        --tags puma-server \
        --restart-on-failure \
        --metadata-from-file startup-script=startup.sh
```

Команда для создания правила для файерволла:

```
gcloud compute firewall-rules create default-puma-server \
    --action allow \
    --direction ingress \
    --rules tcp:9292 \
    --source-ranges 0.0.0.0/0 \
    --target-tags puma-server
```

```
testapp_IP=35.204.222.243
testapp_port=9292
```

## Homework-3:

Для подключения к someinternalhost используем jumphost, применяя ProxyCommand. Jumphost'ом выступает хост bastion.
Для этого необходимо создать файл ~/.ssh/config со следующим содержимым:

```
Host bastion
  User nv30
  Hostname 35.204.199.208

Host someinternalhost
  User nv30
  Hostname 10.164.0.3
  Port 22
  ProxyCommand ssh -q -W %h:%p bastion
```

Таким образом сразу же выполняется дополнительное задание, т.к. в config заданы алиасы для хостов bastion и someinternalhost.
Для подключения к bastion через openvpn:

```
bastion_IP = 35.204.199.208
someinternalhost_IP = 10.164.0.3
```

