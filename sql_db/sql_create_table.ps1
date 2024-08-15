# Define parameters
$storageAccountName = "demostorage6767"
$storageContainerName = "containerfortest677"
$sqlFileName = "create_table.sql"
$localTempDir = "/Users/srikku/Task_1/sql_db"

# Define SQL Server and Database connection details
$serverName = "sk-sqlserverfortest.database.windows.net"
$databaseName = "sk-sqldbfortest"
$adminUser = "sqladminlogin"
$adminPassword = "Srikku@6777"

# Authenticate using Managed Identity
Connect-AzAccount -Identity

# Get the current Azure context
$context = Get-AzContext

# Set the Azure context to ensure correct subscription is used
Set-AzContext -SubscriptionId $context.Subscription.Id

# Download the SQL script from Azure Blob Storage using the Managed Identity
$storageAccount = Get-AzStorageAccount -ResourceGroupName "rg-srikanth-c2s" -Name $storageAccountName
$blobContext = $storageAccount.Context

Get-AzStorageBlobContent -Container $storageContainerName -Blob $sqlFileName -Destination $localTempDir -Context $blobContext

# Define the connection string for SQL Server
$connectionString = "Server=tcp:$serverName;Database=$databaseName;User ID=$adminUser;Password=$adminPassword;Encrypt=true;TrustServerCertificate=false;Connection Timeout=30;"

# Execute the SQL script
$localFilePath = "$localTempDir\$sqlFileName"
Invoke-Sqlcmd -ConnectionString $connectionString -InputFile $localFilePath
