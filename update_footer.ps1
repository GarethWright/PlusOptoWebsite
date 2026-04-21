Set-Location 'C:\Users\geoff.PLUS-OPTO\OneDrive - Plus Opto\Plus Opto Web Site 2020 LIVE\New Plus Opto Web Site\FaceLift'
$reg = '<p class="mb-0" style="font-size:.8rem;">Registered in England &amp; Wales 02987120 | VAT Number: GB 732 4193 48</p>'
$old2025 = '<p class="mb-0">&copy; 2025 Plus Opto. All rights reserved.</p>'
$old2026 = '<p class="mb-0">&copy; 2026 Plus Opto. All rights reserved.</p>'
Get-ChildItem -Filter '*.html' | ForEach-Object {
    $c = Get-Content $_.FullName -Raw
    $c2 = $c.Replace($old2025, $reg + $old2025)
    $c2 = $c2.Replace($old2026, $reg + $old2026)
    if ($c2 -ne $c) {
        Set-Content $_.FullName -Value $c2 -NoNewline
        Write-Host "Updated: $($_.Name)"
    }
}
