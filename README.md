---
shell: bash
---

# Labolatorium baz danych

Instrukcja przygotowania środowiska na przykładzie darmowej subskrypcji Microsoft Azure.

## Niezbędne narzędzia

1. subskrypcja Azure'a
2. lokalny klient MySQLa, np. [MySQL Workbench](https://www.mysql.com/products/workbench/)

## Kroki

### Logowanie

```sh {name=login background=false closeTerminalOnSuccess=false}
az login
```

### Konfiguracja subskrypcji

```sh {name=subscription background=false closeTerminalOnSuccess=false}
az account set --subscription <id z konsoli portal.azure.com>
```

konfigurację sprawdzamy tak:

```sh {name=account-check background=false closeTerminalOnSuccess=false}
az account show
```

ważne pola do sprawdzenia:
+ "id" - identyfikator subskrypcji, czy pokrywa się z tym co widzimy w Azure Portalu
+ "isDefault" - istotne, gdybyśmy mieli kilka subskrypcji w naszej instancji AZ CLI
+ "name" - nazwa sbskrypcji, sprawdzmy jak `id`
+ "state" - stan skonfiguracji konta, jeśli nie jest `Enabled` to błąd

### Utworzenie ResourceGroup-y

```sh {name=resource-grp background=false closeTerminalOnSuccess=false promptEnv=false}
export RESOURCE_GRP_NAME="merito-db-$(echo $RANDOM | sha1sum | cut -c 1-8)"
# az account list-locations -o table
export RESOURCE_LOCATION="germanywestcentral"

az group create --name $RESOURCE_GRP_NAME --location $RESOURCE_LOCATION
```

### Utworzenie serwera bazy dancyh

```sh {name=db-server background=false closeTerminalOnSuccess=false promptEnv=false}
export DB_SRV_NAME="db-srv-$(echo $RANDOM | sha1sum | cut -c 1-8)"
export MY_PUBLIC_IP=$(curl -s ifconfig.me)

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

```sh {name=db-server-connect background=false closeTerminalOnSuccess=false}
az mysql flexible-server show-connection-string --server-name $DB_SRV_NAME --admin-user=adminuser
```

aby połączyć się z bazą danych potrebny będzie również certyfikat SSL (chyba, że wyłączymy SSLa, ale nie jest to zalecane):

```sh {name=ssl-cert-get background=false closeTerminalOnSuccess=false}
curl -s -o cacert.pem https://dl.cacerts.digicert.com/DigiCertGlobalRootCA.crt.pem
```

### Konfiguracja dostępu sieciowego

Operacja wykoywana z [GUI](https://portal.azure.com/) i polegająca na dodaniu dopuszczenia połączeń dla wybranego adresu publicznego dla danego serwera bazy danych działającego w chmurze. Realizowana w zakładce Networks serwera bazy danych.

### MyCLI, czyli interfejs do bazy danych

[MyCLI](https://www.mycli.net/) commandline'owy interfejs do bazy danych - nie tylko MySQL. MyCLI zapewnia lepszy User eXperience niż podstawowe narzędzia konsolowe MySQLa, dzięki np autouzupełnianiu i przeszukiwaniu historii poleceń.

```sh {name=mycli-install background=false closeTerminalOnSuccess=false excludeFromRunAll=true}
# poniższe polecenia zadziałają w systemie Windows
python -m venv venv
# cd venv\Scripts   # windows
# activate          # windows
. venv/bin/activate # linux
pip3 install mycli
mycli --help
```

jak zalogować się do bazy:

```sh {name=mycli-login background=false closeTerminalOnSuccess=false excludeFromRunAll=true}
mycli --host=${DB_SRV_NAME}.mysql.database.azure.com --ssl-ca=cacert.pem --user=adminuser
```

### Zatrzymanie instancji

Z racji na koszty utrzymania zasobów chmurowych zalecane jest wyłączanie ich po zakończonej pracy:

```sh {name=db-server-stop background=false closeTerminalOnSuccess=false excludeFromRunAll=true}
az mysql flexible-server stop --name $DB_SRV_NAME
```

lub wręcz ich kasowanie:

```sh {name=db-server-delete background=false closeTerminalOnSuccess=false excludeFromRunAll=true}
az mysql flexible-server delete --resource-group $RESOURCE_GRP_NAME --name $DB_SRV_NAME
```

## Referencje

- [Demo: Getting Started | Azure Database for MySQL - Beginners Series](https://learn.microsoft.com/en-us/shows/azure-database-for-mysql-beginners-series/demo-getting-started)
- [Azure Database for MySQL documentation](https://learn.microsoft.com/en-us/azure/mysql/)
- [MySQL Tutorial](https://www.mysqltutorial.org/)
- [mysql-database-samples](https://github.com/Azure-Samples/mysql-database-samples)
