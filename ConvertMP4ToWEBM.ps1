param(
    [string]$file,
    [string]$directory,
    [switch]$help
)

if($help) {
    write-host "This script converts .mp4 files to vp9 .webm files. It will convert all .mp4 files in the working directory by default."
    write-host -foregroundcolor yellow "ffmpeg must be in your path for this script to work correctly"
    write-host -foregroundcolor red "This may overwrite files without asking!`r`n"
    write-host "-help: Displays this message"
    write-host "-directory: Convert all .mp4 files in specified directory."
    write-host "-file: Convert individual file.`r`n"
    return
}   

# make a convert function

# Check for -file otherwise use all .mp4s in directory
if($file) {
    $fileInfo = get-item $file
    & cmd.exe /c "ffmpeg -i $($file) -c:v libvpx-vp9 -b:v 2M -pass 1 -an -f null NUL && ffmpeg -i $($file) -c:v libvpx-vp9 -b:v 2M -pass 2 -c:a libopus $($fileInfo.directory)\$($fileInfo.basename).webm" 
    return
}

if($directory) {
    get-childitem "$($directory)\*.mp4" | foreach-object {
        write-host -foregroundcolor cyan "Converting $($_)"
        & cmd.exe /c "ffmpeg -i $($_) -c:v libvpx-vp9 -b:v 2M -pass 1 -an -f null NUL && ffmpeg -i $($_) -c:v libvpx-vp9 -b:v 2M -pass 2 -c:a libopus $($_.directory)\$($_.basename).webm" 
        # remove-item ".\ffmpeg2pass-0.log"
    }
}
else {
    get-childitem ".\*.mp4" | foreach-object {
        write-host "Converting $($_)"
        & cmd.exe /c "ffmpeg -i $($_) -c:v libvpx-vp9 -b:v 2M -pass 1 -an -f null NUL && ffmpeg -i $($_) -c:v libvpx-vp9 -b:v 2M -pass 2 -c:a libopus $($_.basename).webm" 
        # remove-item ".\ffmpeg2pass-0.log"
    }
}
