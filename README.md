# nv30_infra
nv30 Infra repository

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
