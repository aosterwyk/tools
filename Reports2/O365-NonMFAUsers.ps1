# Requuires MSOnline module 
# Install-Module msonline | Import-module msonline

$csvFilename = "mfa-disabled-users.csv"

$session = connect-msolservice
get-msoluser -all | Where { $_.IsLicensed -and $_.StrongAuthenticationRequirements.length -lt 1 } | Select-Object DisplayName,UserPrincipalName,BlockCredential | Sort-Object | Export-CSV $csvFilename

Write-Host "Report saved to $($csvFilename)" 

