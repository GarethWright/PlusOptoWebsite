$dir = "C:\Users\geoff.PLUS-OPTO\OneDrive - Plus Opto\Plus Opto Web Site 2020 LIVE\New Plus Opto Web Site\FaceLift"
$files = Get-ChildItem $dir -Filter "*.html"
$count = 0
foreach ($f in $files) {
    $content = [System.IO.File]::ReadAllText($f.FullName)
    $old = 'alt="Plus Opto" height="48" class="mb-3" style="filter:brightness(0) invert(1);"'
    $new = 'alt="Plus Opto" height="48" class="mb-3" style="background:white; border-radius:6px; padding:4px 8px;"'
    if ($content.Contains($old)) {
        $content = $content.Replace($old, $new)
        [System.IO.File]::WriteAllText($f.FullName, $content)
        Write-Host "Fixed: $($f.Name)"
        $count++
    }
}
Write-Host "Total fixed: $count"
