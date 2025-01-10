#!/usr/bin/env bash

set -eu
set -o pipefail

NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'

function finish {
  echo -e "${RED}finished with some issue.${NOCOLOR}"
}

function echo_green {
  echo -e "${GREEN}$1${NOCOLOR}"
}

trap finish SIGINT SIGABRT SIGTERM

RESOURCE_GRP_NAME="merito-db-$(echo $RANDOM | sha1sum | cut -c 1-8)"
RESOURCE_LOCATION="polandcentral"
DB_SRV_NAME="db-srv-$(echo $RANDOM | sha1sum | cut -c 1-8)"
MY_PUBLIC_IP=$(curl -s ifconfig.me)

echo_green "================================"
echo_green "=== TWORZENIE RESOURCE GRUPY ==="
echo_green "================================"

az group create --name $RESOURCE_GRP_NAME --location $RESOURCE_LOCATION

echo_green "====================================="
echo_green "=== TWORZENIE SERWERA BAZY DANYCH ==="
echo_green "====================================="

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

curl -s -o cacert.pem https://dl.cacerts.digicert.com/DigiCertGlobalRootCA.crt.pem

echo "export RESOURCE_GRP_NAME=${RESOURCE_GRP_NAME}" | tee ~/config.sh
echo "export RESOURCE_LOCATION=${RESOURCE_LOCATION}" | tee -a ~/config.sh
echo "export DB_SRV_NAME=${DB_SRV_NAME}" | tee -a ~/config.sh

cat > ~/.my.cnf <<EOT
[mysql]
user=adminuser
password=Som3Passw0rd
host=${DB_SRV_NAME}.mysql.database.azure.com
ssl-ca=cacert.pem
EOT

cat > ~/.env <<EOT
DB_HOST=${DB_SRV_NAME}.mysql.database.azure.com
DB_USER=adminuser
DB_PASS=Som3Passw0rd
DB_NAME=books-db
RESOURCE_GRP_NAME=${RESOURCE_GRP_NAME}
DB_SRV_NAME=${DB_SRV_NAME}
EOT

chmod 600 ~/.my.cnf ~/.env

echo_green "====================="
echo_green "=== IMPORT DANYCH ==="
echo_green "====================="

curl -s https://raw.githubusercontent.com/serafin-tech/lab-db-azure/main/lab_db_v3.sql | mysql --ssl-ca=cacert.pem

echo_green "==============================================================================="
echo_green "=== Po zakończeniu działania skryptu ręcnie wykonaj polecenie 'source .env' ==="
echo_green "==============================================================================="
