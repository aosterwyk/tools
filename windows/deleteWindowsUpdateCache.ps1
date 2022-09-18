param(
    [switch]$delete,
    [switch]$force
)

Write-Host "Stopping Windows Update service";
Stop-Service wuauserv

# C:\Windows\SoftwareDistribution
if($delete) {
    Write-Host "Deleting C:\Windows\SoftwareDistribution"; 
    if($force) {
        Remove-Item "C:\Windows\SoftwareDistribution" -Recurse;
    }
    else {
        Write-Host -ForegroundColor Yellow "Use -Delete and -Force to skip confirmation prompt."
        Remove-Item "C:\Windows\SoftwareDistribution" -Recurse -Confirm;
    }
}
else {
    $backupPath = "C:\Windows\SoftwareDistributionOLD";
    Write-Host "Checking if $($backupPath) already exists.";
    if(Test-Path $backupPath) {
        Write-Host -ForegroundColor Yellow "SoftwareDistributionOLD already exits.";
        $backupPath = "C:\Windows\SoftwareDistributionOLD2";
        if(Test-Path $backupPath) {
            Write-Host -ForegroundColor Red "SoftwareDistributionOLD2 already exits. Exiting. `nUse -Delete to delete directory or delete SoftwareDistributionOLD directories.";
            exit;
        }
    }
    Write-Host "Moving C:\Windows\SoftwareDistribution to $($backupPath)";
    Rename-Item "C:\Windows\SoftwareDistribution" $backupPath;
}

Write-Host "Starting Windows Update service";
Start-Service wuauserv
