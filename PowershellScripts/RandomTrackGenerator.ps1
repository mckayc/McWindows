# Instructions - - - - - - - - 
# 1. Get Spotify Track list from: https://watsonbox.github.io/exportify/
# 2. Import csv into Google Sheets. Delete everything but the tracks. (keep the header)
# 3. Export the sheet as CSV and name "trackList.csv"

# Note; this simulation does completely random tracks (which might even allow for the same song in a row - it does not take into account what songs have already been played)


$trackList = Import-Csv -Path .\trackList.csv # Import Tracklist from csv
$iterations = 20000 # Specify how many track plays you want to simulate
$count = 0 # Variable to use in the while loop to generate new list
$newList = @() # Initiate the array

while($count -lt $iterations) # Only do as many tracks as specified
{
    $randomPlay = $trackList | Get-Random -Count 1 # Pull single random track from playlist
    $newList += $randomPlay # Append track to new list
    $count++
}

$newList | Export-Csv -Path "simulatedTrackList.csv" -NoTypeInformation



