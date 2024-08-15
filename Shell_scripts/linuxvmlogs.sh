#!/bin/bash

# Variables for paths and filenames
directoryPath="/var/log/test"
logFilePath="$directoryPath/cpu_metrics_linuxvm.log"
storageAccountName="demostorage6767"
storageContainerName="containerfortest677"
blobName="cpu_metrics_linuxvm.log"

# Authenticate using the managed identity (using Azure CLI)
echo "Authenticating with Azure..."
az login --identity > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Azure authentication failed"
    exit 1
fi

# Ensure the context is set correctly to your subscription
subscriptionId=$(az account show --query id -o tsv)
az account set --subscription "$subscriptionId" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Failed to set Azure subscription"
    exit 1
fi

# Create the directory if it doesn't exist (requires sudo)
if [ ! -d "$directoryPath" ]; then
    echo "Creating directory '$directoryPath'..."
    sudo mkdir -p "$directoryPath"
    if [ $? -eq 0 ]; then
        echo "Directory '$directoryPath' created."
    else
        echo "Failed to create directory '$directoryPath'."
        exit 1
    fi
else
    echo "Directory '$directoryPath' already exists."
fi

# Fetch the current date and time
currentDate=$(date +"%Y-%m-%d %H:%M:%S")

# Get the CPU metrics
cpuUsage=$(mpstat 1 1 | awk '/Average/ {print 100 - $12}')
if [ -z "$cpuUsage" ]; then
    echo "Failed to retrieve CPU usage metrics"
    exit 1
fi

# Write the CPU metrics to the log file
echo "$currentDate - CPU Usage: $cpuUsage%" >> "$logFilePath"
if [ $? -ne 0 ]; then
    echo "Failed to write CPU metrics to $logFilePath"
    exit 1
fi
echo "CPU metrics saved to $logFilePath"

# Verify that the log file exists
if [ ! -f "$logFilePath" ]; then
    echo "Log file does not exist: $logFilePath"
    exit 1
fi

# Upload the log file to Azure Blob Storage using Azure CLI
echo "Uploading file to Azure Blob Storage..."
az storage blob upload --account-name "$storageAccountName" --container-name "$storageContainerName" --name "$blobName" --file "$logFilePath" --auth-mode login
if [ $? -ne 0 ]; then
    echo "Error occurred during blob upload"
    exit 1
fi

# Output completion message
echo "$(date +"%Y-%m-%d %H:%M:%S") Metrics data saved to $logFilePath and uploaded to storage container $storageContainerName as $blobName."
