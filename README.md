---
runme:
  id: 01HHA66D7C4PE9J2Y0SZ0EFMC6
  version: v3
shell: bash
---

# Laboratorium baz danych

Instrukcja przygotowania środowiska na przykładzie darmowej subskrypcji Microsoft Azure.

## Niezbędne narzędzia

1. subskrypcja Azure'a
2. lokalny klient MySQLa, np. [MySQL Workbench](https://www.mysql.com/products/workbench/)

## Kroki

*wszystkie kroki można uruchomić w CloudShell przy pomocy poniższego polecenia (przez użycie skryptu powłoki):*

```sh {"background":"false","closeTerminalOnSuccess":"false","id":"01HZ7YPF17FA6JS6NWRSD27GZW","name":"full-setup-shell"}
curl -s https://raw.githubusercontent.com/serafin-tech/lab-db-azure/main/skrypt.sh | bash -x
```

### Logowanie

*krok pomijamy w przypadku użycia CloudShella*

```sh {"background":"false","closeTerminalOnSuccess":"false","id":"01HHA66D7BDQKDGYJYBRSF2050","name":"login"}
az login
```

### Konfiguracja subskrypcji

*krok pomijamy w przypadku użycia CloudShella*

```sh {"background":"false","closeTerminalOnSuccess":"false","id":"01HHA66D7BDQKDGYJYBVD5HFRW","name":"subscription"}
az account set --subscription <id z konsoli portal.azure.com>
```

konfigurację sprawdzamy tak:

```sh {"background":"false","closeTerminalOnSuccess":"false","id":"01HHA66D7BDQKDGYJYBWMBJPT4","name":"account-check"}
az account show
```

ważne pola do sprawdzenia:

+ "id" - identyfikator subskrypcji, czy pokrywa się z tym co widzimy w Azure Portalu
+ "isDefault" - istotne, gdybyśmy mieli kilka subskrypcji w naszej instancji AZ CLI
+ "name" - nazwa sbskrypcji, sprawdzmy jak `id`
+ "state" - stan skonfiguracji konta, jeśli nie jest `Enabled` to błąd

### Utworzenie ResourceGroup-y

```sh {"background":"false","closeTerminalOnSuccess":"false","id":"01HHA66D7BDQKDGYJYBYQ2VBAN","name":"resource-grp","promptEnv":"false"}
export RESOURCE_GRP_NAME="merito-db-$(echo $RANDOM | sha1sum | cut -c 1-8)"
# az account list-locations -o table
export RESOURCE_LOCATION="germanywestcentral"

echo "export RESOURCE_GRP_NAME=${RESOURCE_GRP_NAME}" | tee ~/config.sh
echo "export RESOURCE_LOCATION=${RESOURCE_LOCATION}" | tee -a ~/config.sh

az group create --name $RESOURCE_GRP_NAME --location $RESOURCE_LOCATION
```

### Utworzenie serwera bazy dancyh

```sh {"background":"false","closeTerminalOnSuccess":"false","id":"01HHA66D7BDQKDGYJYC1P50AG0","name":"db-server","promptEnv":"false"}
export DB_SRV_NAME="db-srv-$(echo $RANDOM | sha1sum | cut -c 1-8)"
export MY_PUBLIC_IP=$(curl -s ifconfig.me)

echo "export DB_SRV_NAME=${DB_SRV_NAME}" | tee -a ~/config.sh

az mysql flexible-server create \
    --database-name lab-db \
    --name $DB_SRV_NAME \
    --location $RESOURCE_LOCATION \
    --public-access $MY_PUBLIC_IP \
    --resource-group $RESOURCE_GRP_NAME \
    --sku-name Standard_B1ms \
    --storage-auto-grow Disabled \
    --version 8.0.21 \
    --admin-user adminuser \
    --admin-password Som3Passw0rd
```

### Connection string

parametry połączeń dla poszczególnych języków programowania:

```sh {"background":"false","closeTerminalOnSuccess":"false","id":"01HHA66D7BDQKDGYJYC36MFWBW","name":"db-server-connect"}
az mysql flexible-server show-connection-string --server-name $DB_SRV_NAME --admin-user=adminuser
```

aby połączyć się z bazą danych potrzebny będzie również certyfikat SSL (chyba, że wyłączymy SSLa, ale nie jest to zalecane):

```sh {"background":"false","closeTerminalOnSuccess":"false","id":"01HHA66D7BDQKDGYJYC5PCMMKG","name":"ssl-cert-get"}
curl -s -o cacert.pem https://dl.cacerts.digicert.com/DigiCertGlobalRootCA.crt.pem
```

### Utworzenie bazy danych do ćwiczeń

poniższe polecenie przygotowuje bazę danych do ćwiczeń:

```sh {"background":"false","closeTerminalOnSuccess":"false","id":"01HZ7YPF17FA6JS6NWRSTGTGET","name":"db-prep"}
curl -s https://raw.githubusercontent.com/serafin-tech/lab-db-azure/main/lab_db_v3.sql | \
    mysql --host=${DB_SRV_NAME}.mysql.database.azure.com \
    --user=adminuser --password=Som3Passw0rd
```

### Konfiguracja dostępu sieciowego

Operacja wykoywana z [GUI](https://portal.azure.com/) i polegająca na dodaniu dopuszczenia połączeń dla wybranego adresu publicznego dla danego serwera bazy danych działającego w chmurze. Realizowana w zakładce Networks serwera bazy danych.

### MyCLI, czyli interfejs do bazy danych

[MyCLI](https://www.mycli.net/) commandline'owy interfejs do bazy danych - nie tylko MySQL. MyCLI zapewnia lepszy User eXperience niż podstawowe narzędzia konsolowe MySQLa, dzięki np autouzupełnianiu i przeszukiwaniu historii poleceń.

```sh {"background":"false","closeTerminalOnSuccess":"false","excludeFromRunAll":"true","id":"01HHA66D7C4PE9J2Y0SRYP81T9","name":"mycli-install"}
python -m venv venv
# cd venv\Scripts   # windows
# activate          # windows
. venv/bin/activate # linux
pip3 install mycli
mycli --help
```

jak zalogować się do bazy:

```sh {"background":"false","closeTerminalOnSuccess":"false","excludeFromRunAll":"true","id":"01HHA66D7C4PE9J2Y0SV3S8PB5","name":"mycli-login"}
mycli --host=${DB_SRV_NAME}.mysql.database.azure.com --ssl-ca=cacert.pem --user=adminuser
```

### Zatrzymanie instancji

Z racji na koszty utrzymania zasobów chmurowych zalecane jest wyłączanie ich po zakończonej pracy:

```sh {"background":"false","closeTerminalOnSuccess":"false","excludeFromRunAll":"true","id":"01HHA66D7C4PE9J2Y0SX4D5K57","name":"db-server-stop"}
az mysql flexible-server stop --name $DB_SRV_NAME
```

lub wręcz ich kasowanie:

```sh {"background":"false","closeTerminalOnSuccess":"false","excludeFromRunAll":"true","id":"01HHA66D7C4PE9J2Y0SXV3RWVT","name":"db-server-delete"}
az mysql flexible-server delete --resource-group $RESOURCE_GRP_NAME --name $DB_SRV_NAME
```

## Referencje

- [Demo: Getting Started | Azure Database for MySQL - Beginners Series](https://learn.microsoft.com/en-us/shows/azure-database-for-mysql-beginners-series/demo-getting-started)
- [Azure Database for MySQL documentation](https://learn.microsoft.com/en-us/azure/mysql/)
- [MySQL Tutorial](https://www.mysqltutorial.org/)
- [mysql-database-samples](https://github.com/Azure-Samples/mysql-database-samples)
