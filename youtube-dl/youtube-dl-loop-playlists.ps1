# Requires youtube-dl in same directory - https://github.com/ytdl-org/youtube-dl/releases

$outputDir = '.\' # Output directory, use '.\' for same directory as the script. Each playlist will create a subdirectory. 
$archiveName = 'downloaded.txt' # Filename for youtube-dl archive to track what episodes have been downloaded
# Put playlist URLs surrounding by 's below. Do not use a comma after the last item.
$playlists = @(
    'https://www.youtube.com/watch?v=nAFIsPX3_3A&list=PLR6RS8PTcoXRKYa3LnG-PHeqLPAst4CHL',
    'https://www.youtube.com/watch?v=FeeCKGYAenA&list=PLR6RS8PTcoXStXzjszhT1OpLWoqq0Zx0W',
    'https://www.youtube.com/watch?v=z5EHJ0bxPfU&list=PLR6RS8PTcoXSbN9zeV13vR4MLbnr3n4IC',
    'https://www.youtube.com/watch?v=n9rUw-Jls8w&list=PLR6RS8PTcoXT_l1pSnRqzS1-btVp9DoNq'
)

ForEach($pl in $playlists) {
    Write-Host $pl
    .\youtube-dl.exe $pl -o "$($outputDir)%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s" --download-archive "$($archiveName)"
}

