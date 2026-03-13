$nodePath = "C:\Program Files\nodejs"
if (Test-Path $nodePath) {
    Write-Host "Found at: $nodePath"
    & "$nodePath\node.exe" --version
    & "$nodePath\npm.cmd" --version
} else {
    Write-Host "Not found at Program Files"
    # Check user appdata
    $userPath = "$env:APPDATA\npm"
    if (Test-Path $userPath) { Write-Host "npm at: $userPath" }
}
