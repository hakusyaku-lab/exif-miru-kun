# デスクトップとスタートメニューに「写真のExif見る君」のショートカットを作る
# Chrome があれば Chrome の専用ウィンドウ（アドレスバーなし）で開く。なければ既定のブラウザで開く
param([Parameter(Mandatory=$true)][string]$AppDir)

$page  = Join-Path $AppDir 'index.html'
$icon  = Join-Path $AppDir 'icon.ico'
$url   = ([Uri]$page).AbsoluteUri
$shell = New-Object -ComObject WScript.Shell

# Chrome の場所を探す
$chrome = $null
foreach ($key in @(
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe',
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe',
    'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe')) {
    try { $v = (Get-ItemProperty -Path $key -ErrorAction Stop).'(default)'; if ($v -and (Test-Path $v)) { $chrome = $v; break } } catch {}
}
if (-not $chrome) {
    foreach ($p in @(
        (Join-Path $env:ProgramFiles 'Google\Chrome\Application\chrome.exe'),
        (Join-Path ${env:ProgramFiles(x86)} 'Google\Chrome\Application\chrome.exe'),
        (Join-Path $env:LOCALAPPDATA 'Google\Chrome\Application\chrome.exe'))) {
        if ($p -and (Test-Path $p)) { $chrome = $p; break }
    }
}

if ($chrome) { Write-Host "  Chrome で開くように設定します: $chrome" }
else         { Write-Host "  Chrome が見つからないため、既定のブラウザで開くように設定します" }

$places = @(
    [Environment]::GetFolderPath('Desktop'),
    [Environment]::GetFolderPath('Programs')
)
foreach ($dir in $places) {
    if (-not $dir) { continue }
    $lnk = Join-Path $dir '写真のExif見る君.lnk'
    $s = $shell.CreateShortcut($lnk)
    if ($chrome) {
        $s.TargetPath = $chrome
        $s.Arguments  = '--app="' + $url + '" --window-size=1000,900'
    } else {
        $s.TargetPath = $page
        $s.Arguments  = ''
    }
    $s.WorkingDirectory = $AppDir
    $s.IconLocation     = $icon
    $s.Description      = '写真の撮影日時・機種・F値・位置情報を見る'
    $s.Save()
    Write-Host "  作成しました: $lnk"
}
