# download pads.zip (https://www.nirsoft.net/pad/index.html) and extract to "pads" directory before running this script

$downloadPath = ".\downloaded"
if(-not (test-path $downloadPath)) {
    write-host -foregroundcolor yellow "Download path $($downloadPath) does not exist. Creating directory."
    new-item -type directory -path $downloadPath
}

get-childitem -path ".\pads" -filter "*.xml" | foreach-object {
    # [xml]$xmlFile = Get-Content ".\pads\bluescreenview.xml"
    [xml]$xmlFile = Get-Content ".\pads\$($_)"

    $downloadURL = Select-Xml -Xml $xmlFile -XPath "//Primary_Download_URL"
    $downloadName = Select-Xml -Xml $xmlFile -XPath "//Program_Name"
    
    $downloadURLString = $downloadURL.toString() 
    $fileName = $downloadURLString.split('/')[-1]
    
    write-host "Downloading $downloadName ($($downloadURLString))"
    invoke-webrequest -uri $downloadURLString -outfile ".\downloaded\$($fileName)"
}
