# This script uses wget - http://gnuwin32.sourceforge.net/packages/wget.htm 
# open image in giphy > click media > copy "social" url and put into img array 

$imgs = 'https://media1.tenor.com/images/f591e3fc986246a41f322c9cc0d6824c/tenor.gif','https://media1.tenor.com/images/d3f85b26d4ac1aef86ad2e4836eda02e/tenor.gif'
for($x = 0; $x -lt $imgs.Length; $x++)
{
    Write-Host $imgs[$x]
    wget $imgs[$x] -o "$($x).gif"
}
