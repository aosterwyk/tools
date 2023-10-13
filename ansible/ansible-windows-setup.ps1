# PUBLIC ssh key from ansible server 
$ansibleSSHKey = ""

# copy ansible's SSH public key to the user profiles below
# single user (user running this script)
$sshUsers = $env:UserName
# multiple users
# $sshUsers = "admin", "zero_cool", "acid_burn"

Write-Host "Installing OpenSSH Client and Server" 
# Install the OpenSSH Client
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

Write-Host "Starting sshd service"
Start-Service sshd
Write-Host "Setting sshd service to automatic startup"
Set-Service -Name sshd -StartupType Automatic
 
$sshUsers | ForEach-Object {
    if(-Not (Test-Path -path "c:\temp")) {
        Write-Host "Creating temp directory"
        New-Item -type directory -path "c:\temp"
    }       

    $sshKeysPath = "c:\users\$($_)\.ssh"
    if(-Not (Test-Path -path $sshKeysPath)) {
        New-Item -type directory -path $sshKeysPath
    }

    Write-Host "Adding ansible server's SSH key to $($_)'s authorized keys" 
    Add-Content -path "$($sshKeysPath)\authorized_keys" -value $ansibleSSHKey
}
