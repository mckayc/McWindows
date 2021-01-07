# Instructions - - - - - - - - 
# 1. Get Spotify Track list from: https://watsonbox.github.io/exportify/
# 2. Import csv into Google Sheets. Delete everything but the tracks. 
# 3. Export the sheet as CSV and name "trackList.csv"


$trackList = Import-Csv -Path .\trackList.csv
function Randomize-List
{
   Param(
     [array]$trackList
   )

   return $trackList | Get-Random -Count $trackList.Count;
}

$a = 1494
Write-Output (Randomize-List -InputList $a)