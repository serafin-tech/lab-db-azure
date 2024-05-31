#!/usr/bin/env bash

set -ex

RESOURCE_GRP_NAME="merito-db-$(echo $RANDOM | sha1sum | cut -c 1-8)"
RESOURCE_LOCATION="germanywestcentral"
DB_SRV_NAME="db-srv-$(echo $RANDOM | sha1sum | cut -c 1-8)"
MY_PUBLIC_IP=$(curl -s ifconfig.me)

echo "export RESOURCE_GRP_NAME=${RESOURCE_GRP_NAME}" | tee ~/config.sh
echo "export RESOURCE_LOCATION=${RESOURCE_LOCATION}" | tee -a ~/config.sh
echo "export DB_SRV_NAME=${DB_SRV_NAME}" | tee -a ~/config.sh


az group create --name $RESOURCE_GRP_NAME --location $RESOURCE_LOCATION


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

curl -s https://raw.githubusercontent.com/serafin-tech/lab-db-azure/main/lab_db_v3.sql | \
    mysql --host="${DB_SRV_NAME}.mysql.database.azure.com" \
    --user=adminuser --password=Som3Passw0rd
