# This script requires ffmpeg https://ffmpeg.org/download.html
# The example below will convert all .mp4 files in a directory to .gif. You can change input and output formats if needed. 

Get-ChildItem *.mp4 | ForEach-Object {
    .\ffmpeg.exe -i "$($_.Name)" "$($_.BaseName).gif"
}
