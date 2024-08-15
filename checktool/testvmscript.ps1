# Define variables
$vmIPAddress = "172.174.64.176"
$portToCheck = 3389                
$localPath = "/Users/srikku/Task_1/checktool/ping_port_check.csv"

# Function to perform ping test
function Test-Ping {
    param (
        [string]$IPAddress
    )
    try {
        # Execute the ping command
        $pingResult = Test-Connection -ComputerName $IPAddress -Count 4 -ErrorAction Stop

        # Extract latency values
        $latencyValues = $pingResult | ForEach-Object { $_.Latency }

        # Debug: output latency values
        Write-Output "Latency Values: $($latencyValues -join ', ')"

        # Calculate average, min, and max latency
        $avgLatency = if ($latencyValues.Count -gt 0) { [math]::Round(($latencyValues | Measure-Object -Average).Average, 2) } else { $null }
        $minLatency = if ($latencyValues.Count -gt 0) { [math]::Round(($latencyValues | Measure-Object -Minimum).Minimum, 2) } else { $null }
        $maxLatency = if ($latencyValues.Count -gt 0) { [math]::Round(($latencyValues | Measure-Object -Maximum).Maximum, 2) } else { $null }
    } catch {
        $avgLatency = $null
        $minLatency = $null
        $maxLatency = $null
    }

    return @{
        PingSuccess = $latencyValues.Count -gt 0
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

    # Create result object
    $result = [PSCustomObject]@{
        Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        Metric = "PingSuccess"
        Value = $pingResults.PingSuccess
    }
    $results += $result

    $result = [PSCustomObject]@{
        Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        Metric = "PingAvgResponseTime"
        Value = $pingResults.PingAvgResponseTime
    }
    $results += $result

    $result = [PSCustomObject]@{
        Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        Metric = "PingMinResponseTime"
        Value = $pingResults.PingMinResponseTime
    }
    $results += $result

    $result = [PSCustomObject]@{
        Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        Metric = "PingMaxResponseTime"
        Value = $pingResults.PingMaxResponseTime
    }
    $results += $result

    $result = [PSCustomObject]@{
        Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        Metric = "PortSuccess"
        Value = $portSuccess
    }
    $results += $result

    # Wait for 30 seconds before collecting the next sample
    Start-Sleep -Seconds 30
}

# Export results to CSV file
$results | Export-Csv -Path $localPath -NoTypeInformation

Write-Output "Results saved to $localPath"
