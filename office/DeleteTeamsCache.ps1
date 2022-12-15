param(
    [switch]$force
)
write-host "Closing Teams"
get-process -Name "Teams" | stop-process
write-host "Deleting cache"
if($force) {
    remove-item "$($env:appdata)\Microsoft\Teams\Cache" -recurse 
}
else {
    write-host "Use -force to skip prompt"
    remove-item "$($env:appdata)\Microsoft\Teams\Cache" -recurse -confirm
}

write-host "Restarting Teams"
& "$($env:localappdata)\Microsoft\Teams\current\Teams.exe" > out-null
