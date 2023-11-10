ACR_NAME=skipacrtutorial
RES_GROUP=$ACR_NAME # Resource Group name

az group create  --resource-group $RES_GROUP --location eastus
az acr create --resource-group $RES_GROUP --name $ACR_NAME --sku Standard --location eastus

az acr build --platform windows --registry $ACR_NAME --image helloacrtasks:v3 .

#az container create \
#    --os-type windows \
#    --resource-group $RES_GROUP \
#    --name acr-tasks \
#    --image $ACR_NAME.azurecr.io/helloacrtasks:v3 \
#    --registry-login-server $ACR_NAME.azurecr.io \
#    --registry-username $(az keyvault secret show --vault-name $AKV_NAME --name $ACR_NAME-pull-usr --query value -o tsv) \
#    --registry-password $(az keyvault secret show --vault-name $AKV_NAME --name $ACR_NAME-pull-pwd --query value -o tsv) \
#    --dns-name-label acr-tasks-$ACR_NAME \
#    --query "{FQDN:ipAddress.fqdn}" \
#    --output table

az container create \
    --os-type windows \
    --resource-group $RES_GROUP \
    --name acr-tasks \
    --image $ACR_NAME.azurecr.io/helloacrtasks:v7 \
    --registry-login-server $ACR_NAME.azurecr.io \
    --registry-username 'b86fccca-b0e8-4b80-a85c-37e69316b2eb' \
    --registry-password 'FkH8Q~sFBG0bOyM~XtY5uYSGuJkiLRzzUtTm-chO' \
    --dns-name-label acr-tasks-$ACR_NAME \
    --query "{FQDN:ipAddress.fqdn}" \
    --secure-environment-variables "AZP_POOL=Dev-ASA-AWS" \
      "AZP_URL=https://dev.azure.com/CSGDevOpsAutomation" \
      "AZP_TOKEN=sqwpkybdbxguwu36sucdlchmdhksetgxkrlh4ere2bzuq23o6d4q" \
    --output table

az container stop --name acr-tasks --resource-group $RES_GROUP
az container start --name acr-tasks --resource-group $RES_GROUP
az container attach --resource-group $RES_GROUP --name acr-tasks

az container delete --resource-group $RES_GROUP --name acr-tasks
az container exec --resource-group $RES_GROUP --name acr-tasks --exec cmd
