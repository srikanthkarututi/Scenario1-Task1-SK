# Define variables
$blobUri = "https://demostorage6767.blob.core.windows.net/containerfortest677/networkDiagnostics.ps1"
$localScriptPath = "C:\Users\azureuser\Desktop\networkDiagnostics.ps1"
$csvOutputPath = "C:\Users\azureuser\Desktop\networkDiagnostics.csv"

# Connect to Azure using Managed Identity
#Install-Module -Name Az -AllowClobber -Scope CurrentUser
Connect-AzAccount -Identity

# Download the network diagnostics script from Azure Blob Storage
Write-Output "Downloading network diagnostics script from Blob Storage..."
Invoke-WebRequest -Uri $blobUri -OutFile $localScriptPath

# Verify if the script was downloaded successfully
if (-Not (Test-Path $localScriptPath)) {
    Write-Output "Failed to download the script from Blob Storage."
    exit
}

# Execute the downloaded network diagnostics script
Write-Output "Executing the downloaded network diagnostics script..."
& $localScriptPath

# Verify if the CSV file was created
if (Test-Path $csvOutputPath) {
    Write-Output "Script executed successfully. Results saved to $csvOutputPath"
} else {
    Write-Output "Script execution failed or output file not found."
}