Write-Host -ForegroundColor Yellow "Please only use this for good"

$backupConfirm = Read-Host "Do you have a backup of this system? This script will not check if you lie. (y/N)"
if($backupConfirm -ne "y" -or $backupConfirm -ne "Y") {
    Throw "Please backup this system before running script"
}

$sqlService = Get-Service MSSQLSERVER
Write-Host -ForegroundColor Cyan "Using default SQL service $($sqlService.name)"
$sqlServicePrompt = Read-Host "Change SQL service? (y/N)"
if($sqlServicePrompt -eq "y" -or $sqlServicePrompt -eq "Y") {
    $newServiceName = Read-Host "Enter service name" 
    $sqlService = Get-Service $newServiceName
}
$sqlInstallPath = "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Binn"
Write-Host -ForegroundColor Cyan "Using default SQL install directory: $($sqlInstallPath)"
$sqlInstallPrompt = Read-Host "Change SQL install directory? (y/N)"
if($sqlInstallPrompt -eq "y" -or $sqlInstallPrompt -eq "Y") {
    $sqlInstallPath = Read-Host "Enter SQL install path. Do not include trailing \"
}
$newUsername = Read-Host "Enter username for new login"
$newPasswordSecure = Read-Host "Enter password for new login" -AsSecureString
$newPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPasswordSecure))

Clear-Host
Write-Host "Please review before starting`n----"
Write-Host "Service`n$($sqlService.name)`n"
Write-Host "SQL install directory`n$($sqlInstallPath)`n"
Write-Host "Username`n$($newUsername)`n"
$continuePrompt = Read-Host "Continue? (y/N)"
if($continuePrompt -ne "y" -or $continuePrompt -ne "Y") {
    Throw "Stopped by user"
}

Stop-Service $sqlService
Write-Host "`n`nStarting SQL single user session"
$singleSQLSession = Start-Process -FilePath "sqlservr.exe" -Args "-m" -WorkingDirectory $sqlInstallPath -PassThru
Write-Host "Creating login $($newUsername)"
& sqlcmd.exe -Q "CREATE LOGIN $($newUsername) with PASSWORD = '$($newPassword)';"
Write-Host "Adding sysadmin role to $($newUsername)"
& sqlcmd.exe -Q "SP_ADDSRVROLEMEMBER '$($newUsername)', 'sysadmin';"

Write-Host "Stopping SQL single user session"
Stop-Process -InputObject $singleSQLSession

Write-Host "Restarting SQL service"
Restart-Service $sqlService    

Write-Host "Done!"

