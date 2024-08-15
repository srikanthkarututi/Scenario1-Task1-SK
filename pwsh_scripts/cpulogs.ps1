Install-Module -Name Az -AllowClobber -Scope CurrentUser

# Define the path to the output text file
$outputFile = "cpu_metrics.txt"

# Get the current date and time
$currentDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Get the CPU metrics
$cpuUsage = Get-Counter '\Processor(_Total)\% Processor Time' | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue

# Write the CPU metrics to the text file
"$currentDate - CPU Usage: $cpuUsage%" | Out-File -FilePath $outputFile -Append

# Print the location of the output file
Write-Output "CPU metrics saved to $outputFile"

# Azure Storage information
$storageAccountName = "demostorage6767"
$storageContainerName = "containerfortest677"
$blobName = "cpu_metrics.txt"
$localFilePath = $outputFile

# Azure Authentication
Connect-AzAccount -Identity
$context = Get-AzContext
Set-AzContext -SubscriptionId $context.Subscription.Id

# Azure Storage context
$storageContext = New-AzStorageContext -StorageAccountName $storageAccountName -UseConnectedAccount

# Upload file to Azure Storage
Set-AzStorageBlobContent -File $localFilePath -Container $storageContainerName -Blob $blobName -Context $storageContext -Force

# Output completion message
Write-Output "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') Metrics data saved to $localFilePath and uploaded to storage container $storageContainerName as $blobName."
