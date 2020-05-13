# vcenter settings
$vcenterServer = ""
$vcenterUser = "" # if vcenter is domain joined you can run this script as a domain user without setting a username and password
$vcenterPassword = ""

# email settings
$toAddress = "email@address.com", "email2@address.com" # use a single string (ex: "email@address.com") for one email address 
$fromAddress = ""
$smtpServer = ""
$smtpUsername = ""
$smtpPassword = "" # use single quotes (') if you're having issues with characters
$smtpPort = 25
$smtpSSL = $true
$subjectString = "VM Snapshots Report" # Email subject

# do not change anything below
$timestamp = Get-Date -Format "yyyy-MM-dd"
$subjectString += " $($timestamp)"
$sendReport = $false
$bodyString = "<html><title>$($subjectString)</title><head><style>table,td{border: 1px solid black;border-collapse: collapse;padding:5px;}</style></head><body><table width='100%'><tr style='font-weight: bold'><td>VM</td><td>Name</td><td>Description</td><td>Created</td></tr>"

if($vcenterPassword -gt 1)
{
    $securedVcenterPassword = ConvertTo-SecureString $vcenterPassword -AsPlainText -Force
    Connect-VIServer $vcenterServer -User $vcenterUser -Password $vcenterPassword 
}
else
{
    Connect-VIServer $vcenterServer 
}

$snapshots = get-vm | get-snapshot | Select-Object VM,Name,Description,Created
foreach($snap in $snapshots)
{
    $bodyString += "<tr><td>$($snap.VM)</td><td>$($snap.Name)</td><td>$($snap.Description)</td><td>$($snap.Created)</td></tr>"
    $sendReport = $true
}

Disconnect-VIServer $vcenterServer -Confirm:$false  
$bodyString += "</table></body></html>"

$useCreds = $false
if($sendReport)
{
    if($smtpPassword -gt 1)
    {
        $securedPassword = ConvertTo-SecureString $smtpPassword -AsPlainText -Force
        $smtpCreds = New-Object System.Management.Automation.PSCredential ($smtpUsername, $securedPassword)
        $useCreds = $true
    }

    if($useCreds)
    {
        if($smtpSSL)
        {
            Send-MailMessage -From $fromAddress -To $toAddress -SmtpServer $smtpServer -Port $smtpPort -Subject $subjectString -BodyAsHtml $bodyString -Credential $smtpCreds -UseSsl 
        }
        else
        {
            Send-MailMessage -From $fromAddress -To $toAddress -SmtpServer $smtpServer -Port $smtpPort -Subject $subjectString -BodyAsHtml $bodyString -Credential $smtpCreds 
        }
    }
    else 
    {
        Send-MailMessage -From $fromAddress -To $toAddress -SmtpServer $smtpServer -Port $smtpPort -Subject $subjectString -BodyAsHtml $bodyString 
    }
}
else
{
    Write-Host "No snapshots found, skipping email."
}

