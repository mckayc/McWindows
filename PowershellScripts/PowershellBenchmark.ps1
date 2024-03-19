# This is a script that runs very basic benchmarks. This benchmark is not reliable or consistent. It is designed for a basic general idea to compare computer models.
# For the most success this should be run on a newly installed computer before other programs are installed.

# Measure the total run time of winsat cpuformal command
$cpuformalTime = Measure-Command {
    winsat cpuformal
}
# Measure the total run time of winsat memformal command
$memformalTime = Measure-Command {
    winsat memformal
}
# Measure the total run time of winsat diskformal command
$diskformalTime = Measure-Command {
    winsat diskformal
}
# Measure the total run time of winsat d3d command
$d3dTime = Measure-Command {
    winsat d3d
}

# Convert times to Milliseconds
$cpuformalMilliseconds = $cpuformalTime.TotalMilliseconds
$memformalMilliseconds = $memformalTime.TotalMilliseconds
$diskformalMilliseconds = $diskformalTime.TotalMilliseconds
$d3dMilliseconds = $d3dTime.TotalMilliseconds

# Output the total run times in milliseconds
Write-Host "cpuformal Run Time in milliseconds: $cpuformalMilliseconds"
Write-Host "memformal Run Time in milliseconds: $memformalMilliseconds"
Write-Host "diskformal Run Time in milliseconds: $diskformalMilliseconds"
Write-Host "cd3d Run Time in milliseconds: $d3dMilliseconds"