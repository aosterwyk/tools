$toAddress = "email@address.com", "email2@address.com" # use a single string (ex: "email@address.com") for one email address 
$fromAddress = ""
$smtpServer = ""
$smtpUsername = ""
$smtpPassword = "" # use single quotes (') if you're having issues with characters
$smtpPort = 25
$smtpSSL = $true

$subjectString = "Test Email"
$bodyString = "Test email body" # you can use HTML here

# do not change anything below

$useCreds = $false

if($smtpPassword -gt 1)
{
    $securedPassword = ConvertTo-SecureString $smtpPassword -AsPlainText -Force
    $smtpCreds = New-Object System.Management.Automation.PSCredential ($smtpUsername, $securedPassword)
    $useCreds = $true
}

if($useCreds)
{
    Write-Host "Using creds to send mail"
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
    Write-Host "Sending mail without creds"
    Send-MailMessage -From $fromAddress -To $toAddress -SmtpServer $smtpServer -Port $smtpPort -Subject $subjectString -BodyAsHtml $bodyString 
}

