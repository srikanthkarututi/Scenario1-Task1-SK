#az login 

az deployment group create --resource-group rg-srikanth-c2s --template-file mitemplate.json  --parameters miparameter.json
az deployment group create --resource-group rg-srikanth-c2s --template-file miroletemplate.json  --parameters miroleparameter.json
az deployment group create --resource-group rg-srikanth-c2s --template-file keyvaulttemplate.json  --parameters keyvaultparameter.json
az deployment group create --resource-group rg-srikanth-c2s --template-file satemplate.json  --parameters saparameter.json
az deployment group create --resource-group rg-srikanth-c2s --template-file vmtemplate.json  --parameters vmparameter.json

az deployment group create --resource-group rg-srikanth-db --template-file mitemplate.json
#az storage blob upload --account-name demostorage6767 --container-name containerfortest677 --name shutdown.ps1 --file ./shutdown.ps1

#az storage blob upload --account-name demostorage6767 --container-name containerfortest677 --name deploy-zip.ps1 --file /Users/srikku/Task_1/pwsh_scripts/deploy-zip.ps1
#az storage blob upload --account-name demostorage6767 --container-name containerfortest677 --name deploy-zip.ps1 --file /Users/srikku/Task_1/pwsh_scripts/deploy-zip.ps1 --overwrite
#az storage blob delete --account-name demostorage6767 --container-name containerfortest677 --name testvm_port_ping.ps1  

az storage blob upload --account-name demostorage6767 --container-name containerfortest677 --name create_patients_table.sql --file /Users/srikku/Task_1/sql_db/create_table.sql

#To deploy the web application to app service from local
az webapp deployment source config-zip --resource-group rg-srikanth-c2s  --name TestWebApp236 --src /Users/srikku/Task_1/pwsh_scripts/epic_web_publish.zip

az deployment group create --resource-group rg-srikanth-c2s --template-file appservice-ds-template.json   

az deployment group create --resource-group rg-srikanth-c2s --template-file stop-VMdp-template.json 

az deployment sub create --template-file policy-definitions-template.json --location eastus
az deployment group create --resource-group rg-srikanth-c2s --template-file policy-assignments-template.json
az deployment group create --resource-group rg-srikanth-c2s --template-file lockingtemplate.json

az deployment group create --resource-group rg-srikanth-c2s --template-file linuxvmtemplate.json  --parameters linuxvmparameter.json

ssh azureuser@52.234.150.240
Myvmlogin@234

