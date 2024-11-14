# Get the logged-in user's SID
$loggedInUser = (Get-WmiObject -Class Win32_ComputerSystem).UserName
$userSID = (New-Object System.Security.Principal.NTAccount($loggedInUser)).Translate([System.Security.Principal.SecurityIdentifier]).Value

# Define the registry path for the logged-in user under HKEY_USERS
$registryPath = "Registry::HKEY_USERS\$userSID\Network"

# Check if the registry path exists
if (Test-Path $registryPath) {
    # Get all child items (keys and values) under the registry path
    $childItems = Get-ChildItem -Path $registryPath
  
    # Remove each child item
    foreach ($item in $childItems) {
        Remove-Item -Path $item.PSPath -Recurse -Force
        Write-Host "Removed: $($item.PSPath)"
    }
} else {
    Write-Host "Registry path not found: $registryPath"
}
