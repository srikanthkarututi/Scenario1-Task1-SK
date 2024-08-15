param (
    [string]$VMName
)

# Define the resource group name
$rgName = "rg-srikanth-c2s"

# Connect to Azure using the managed identity
Connect-AzAccount -Identity

# Stop the VM
Stop-AzVM -ResourceGroupName $rgName -Name $VMName -Force

# Output status
Write-Output "VM '$VMName' in resource group '$rgName' has been stopped."
