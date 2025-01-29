# Laboratorium baz danych

Instrukcja przygotowania środowiska na przykładzie darmowej subskrypcji Microsoft Azure.

## Niezbędne narzędzia

1. subskrypcja Azure'a
2. włączony [Persistent Shell Storage](https://learn.microsoft.com/en-us/azure/cloud-shell/persisting-shell-storage) wg instrukcji,
3. lokalny klient MySQLa, np. [MySQL Workbench](https://www.mysql.com/products/workbench/)

## Uruchomienie środowiska

```sh
curl -s https://raw.githubusercontent.com/serafin-tech/lab-db-azure/main/skrypt.sh | bash
```

aby połączyć się z bazą danych potrzebny będzie również certyfikat SSL:

```sh
curl -s -o cacert.pem https://dl.cacerts.digicert.com/DigiCertGlobalRootCA.crt.pem
```

### Użytkownik i hasło

|            |                |
|------------|----------------|
| Użytkownik | `adminuser`    |
| Hasło      | `Som3Passw0rd` |

### Konfiguracja dostępu sieciowego

Operacja wykonywana z [GUI](https://portal.azure.com/) i polegająca na otwarciu połączeń dla wybranego adresu publicznego dla danego serwera bazy danych działającego w chmurze.
Realizowana w zakładce Settings/Networks serwera bazy danych.

### Connection string

parametry połączeń dla języków programowania:

```sh
az mysql flexible-server show-connection-string --server-name $DB_SRV_NAME --admin-user=adminuser
```

### Utworzenie bazy danych do ćwiczeń

poniższe polecenie przygotowuje/resetuje bazę danych do ćwiczeń:

```sh
curl -s https://raw.githubusercontent.com/serafin-tech/lab-db-azure/main/lab_db_v3.sql | \
    mysql --host=${DB_SRV_NAME}.mysql.database.azure.com \
    --user=adminuser --password=Som3Passw0rd --ssl-ca=cacert.pem
```

### MyCLI, czyli interfejs do bazy danych

[MyCLI](https://www.mycli.net/) commandline'owy interfejs do bazy danych - nie tylko MySQL. MyCLI zapewnia lepszy User eXperience niż podstawowe narzędzia konsolowe MySQLa, dzięki np autouzupełnianiu i przeszukiwaniu historii poleceń.

```sh
python -m venv venv
# cd venv\Scripts   # windows
# activate          # windows
. venv/bin/activate # linux
pip3 install mycli
mycli --help
```

jak zalogować się do bazy:

```sh
mycli --host=${DB_SRV_NAME}.mysql.database.azure.com --ssl-ca=cacert.pem --user=adminuser
```

### Zatrzymanie instancji

Z racji na koszty utrzymania zasobów chmurowych zalecane jest wyłączanie ich po zakończonej pracy:

```sh
az mysql flexible-server stop --name $DB_SRV_NAME
```

lub wręcz ich kasowanie:

```sh
az mysql flexible-server delete --resource-group $RESOURCE_GRP_NAME --name $DB_SRV_NAME
```

### Kasowanie resource grupy

W momencie, gdy chcemy mieć pewność, ze wszystkie zasoby zostały usunięte najprościej jest skasować całą resource grupę:

```sh
az group delete --resource-group=$RESOURCE_GRP_NAME
```

## Referencje

- [Demo: Getting Started | Azure Database for MySQL - Beginners Series](https://learn.microsoft.com/en-us/shows/azure-database-for-mysql-beginners-series/demo-getting-started)
- [Azure Database for MySQL documentation](https://learn.microsoft.com/en-us/azure/mysql/)
- [Get started with Azure Cloud Shell using persistent storage](https://learn.microsoft.com/en-us/azure/cloud-shell/get-started/new-storage?tabs=azurecli)
- [MySQL Tutorial](https://www.mysqltutorial.org/)
- [mysql-database-samples](https://github.com/Azure-Samples/mysql-database-samples)
