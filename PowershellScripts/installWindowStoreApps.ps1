# Winget test - Show the info so the scripts below don't fail.
winget --info

# Install Microsoft Photos
winget install -e --silent --accept-source-agreements --accept-package-agreements --id 9WZDNCRFJBH4
# Install Windows Calculator
winget install -e --silent --accept-source-agreements --accept-package-agreements --id 9WZDNCRFHVN5
# Install Windows Camera
winget install -e --silent --accept-source-agreements --accept-package-agreements --id 9WZDNCRFJBBG