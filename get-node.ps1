$ver = "v24.14.0"
$url = "https://nodejs.org/dist/$ver/node-$ver-x64.msi"
$out = "$env:TEMP\node-installer.msi"
Write-Host "Downloading Node.js $ver..."
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $out)
Write-Host "Installing..."
$proc = Start-Process msiexec.exe -ArgumentList "/i `"$out`" /qn /norestart ADDLOCAL=ALL" -Wait -PassThru
Write-Host "Exit code: $($proc.ExitCode)"
if ($proc.ExitCode -eq 0) { Write-Host "SUCCESS" } else { Write-Host "FAILED" }
