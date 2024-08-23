# Login using Managed Identity
$ErrorActionPreference = "Stop"

Write-Output "Logging in using Managed Identity"
Connect-AzAccount -Identity

# Wait for 30 seconds
Write-Output "Waiting for 30 seconds before shutting down VMs"
Start-Sleep -Seconds 30

# Shutdown the Windows VM
Write-Output "Shutting down Windows VM"
Stop-AzVM -ResourceGroupName "rg-srikanth-c2s" -Name "myWindowsVM" -Force

# Shutdown the Linux VM
Write-Output "Shutting down Linux VM"
Stop-AzVM -ResourceGroupName "rg-srikanth-c2s" -Name "myLinuxVM" -Force


