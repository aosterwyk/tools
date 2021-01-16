# Requires youtube-dl in same directory 

$playlists = @(
    'https://www.youtube.com/watch?v=z5EHJ0bxPfU&list=PLR6RS8PTcoXSbN9zeV13vR4MLbnr3n4IC',
    'https://www.youtube.com/watch?v=n9rUw-Jls8w&list=PLR6RS8PTcoXT_l1pSnRqzS1-btVp9DoNq'
)

ForEach($pl in $playlists) {
    Write-Host $pl
    .\youtube-dl.exe $pl -o '%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s'
}

