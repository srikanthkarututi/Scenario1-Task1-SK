 # Define variables
$vmIPAddress = "23.96.9.155"
$portToCheck = 3389                
$localPath = "C:\Users\azureuser\Desktop\networkDiagnostics.csv"

# Connect to Azure using managed identity
Write-Output "Connecting to Azure using managed identity..."
Connect-AzAccount -Identity

# Function to perform ping test
function Test-Ping {
    param (
        [string]$IPAddress
    )
    try {
        # Execute the ping command
        $pingResult = Test-Connection -ComputerName $IPAddress -Count 4 -ErrorAction Stop
        if ($pingResult) {
            Write-Output "Ping Success!"
            # Extract latency values
            $latencyValues = $pingResult | ForEach-Object { $_.ResponseTime }

            # Calculate average, min, and max latency
            $avgLatency = [math]::Round(($latencyValues | Measure-Object -Average).Average, 2)
            $minLatency = [math]::Round(($latencyValues | Measure-Object -Minimum).Minimum, 2)
            $maxLatency = [math]::Round(($latencyValues | Measure-Object -Maximum).Maximum, 2)
        } else {
            $avgLatency = $null
            $minLatency = $null
            $maxLatency = $null
        }
    } catch {
        Write-Output "Ping Test Failed: $_"
        $avgLatency = $null
        $minLatency = $null
        $maxLatency = $null
    }

    return @{
        PingResults = $latencyValues
        PingAvgResponseTime = $avgLatency
        PingMinResponseTime = $minLatency
        PingMaxResponseTime = $maxLatency
    }
}

# Function to perform port check
function Test-Port {
    param (
        [string]$IPAddress,
        [int]$Port
    )
    $tcpClient = $null
    try {
        $tcpClient = New-Object System.Net.Sockets.TcpClient
        $tcpClient.Connect($IPAddress, $Port)
        $portOpen = $true
    } catch {
        Write-Output "Port Test Failed: $_"
        $portOpen = $false
    } finally {
        if ($tcpClient) { $tcpClient.Close() }
    }
    return $portOpen
}

# Collect 3 samples, 30 seconds apart
$results = @()
for ($i = 1; $i -le 3; $i++) {
    $pingResults = Test-Ping -IPAddress $vmIPAddress
    $portSuccess = Test-Port -IPAddress $vmIPAddress -Port $portToCheck

    # Add aggregated results
    $result = [PSCustomObject]@{
        Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        PingAvgResponseTime = $pingResults.PingAvgResponseTime
        PingMinResponseTime = $pingResults.PingMinResponseTime
        PingMaxResponseTime = $pingResults.PingMaxResponseTime
        PortStatus = $portSuccess
    }
    $results += $result

    # Wait for 30 seconds before collecting the next sample
    Start-Sleep -Seconds 30
}

# Export results to CSV file
$results | Export-Csv -Path $localPath -NoTypeInformation

Write-Output "Results saved to $localPath"
 
