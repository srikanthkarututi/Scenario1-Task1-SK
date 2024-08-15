# Variables
$subscriptionId = "46187496-2b51-4828-9e72-73702efdfca8"
$resourceGroupName = "rg-srikanth-c2s"
$webAppName = "TestWebApp236"
$blobStorageAccountName = "demostorage6767"
$blobContainerName = "containerfortest677"
$zipFileName = "epic_web_publish.zip"
$localZipFilePath = "/Users/srikku/Task_1/pwsh_scripts/epic_web_publish.zip"

# Obtain an access token using Managed Identity
$tokenResponse = Invoke-RestMethod -Uri "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://management.azure.com/" -Method Get -Headers @{Metadata="true"}
$accessToken = $tokenResponse.access_token

# Set the subscription context
$headers = @{ 
    Authorization = "Bearer $accessToken" 
    "Content-Type" = "application/json"
}

$contextUrl = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Web/sites/$webAppName?api-version=2021-02-01"
Invoke-RestMethod -Uri $contextUrl -Method Get -Headers $headers

# Generate SAS Token for the blob
$endDate = (Get-Date).AddHours(1).ToString("yyyy-MM-ddTHH:mm:ssZ")
$blobSasToken = New-AzStorageAccountSASToken -ResourceGroupName $resourceGroupName -AccountName $blobStorageAccountName -Permission r -ExpiryTime $endDate -ResourceType o

# Construct the blob URI with SAS token
$blobUri = "https://$blobStorageAccountName.blob.core.windows.net/$blobContainerName/$zipFileName?$blobSasToken"

# Download the ZIP file from Azure Blob Storage
Invoke-WebRequest -Uri $blobUri -OutFile $localZipFilePath

# Verify the download
if (-Not (Test-Path -Path $localZipFilePath)) {
    Write-Output "Failed to download ZIP file from blob storage."
    exit
}

Write-Output "Successfully downloaded ZIP file to $localZipFilePath."

# Get the publishing credentials for the web app
$publishingProfileUrl = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Web/sites/$webAppName/publishingCredentials/list?api-version=2021-02-01"
$publishingCredentialsResponse = Invoke-RestMethod -Uri $publishingProfileUrl -Method Post -Headers $headers
$publishingCredentials = $publishingCredentialsResponse.properties

# Deploy the ZIP file to Azure App Service
$deploymentUrl = "https://$($webAppName).scm.azurewebsites.net/api/zipdeploy"
$authHeader = @{
    Authorization = ("Basic {0}" -f [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $publishingCredentials.PublishingUserName, $publishingCredentials.PublishingPassword))))
    "Content-Type" = "application/zip"
}

try {
    # Upload the ZIP file
    Invoke-RestMethod -Uri $deploymentUrl -Method Post -Headers $authHeader -InFile $localZipFilePath
    Write-Output "Deployment completed successfully."
} catch {
    Write-Output "Error during deployment: $_"
}
