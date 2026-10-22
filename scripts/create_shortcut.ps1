# デスクトップとスタートメニューに「写真のExif見る君」のショートカットを作る
param([Parameter(Mandatory=$true)][string]$AppDir)

$page  = Join-Path $AppDir 'index.html'
$icon  = Join-Path $AppDir 'icon.ico'
$shell = New-Object -ComObject WScript.Shell

$places = @(
    [Environment]::GetFolderPath('Desktop'),
    [Environment]::GetFolderPath('Programs')
)
foreach ($dir in $places) {
    if (-not $dir) { continue }
    $lnk = Join-Path $dir '写真のExif見る君.lnk'
    $s = $shell.CreateShortcut($lnk)
    $s.TargetPath       = $page
    $s.WorkingDirectory = $AppDir
    $s.IconLocation     = $icon
    $s.Description      = '写真の撮影日時・機種・F値・位置情報を見る'
    $s.Save()
    Write-Host "  作成しました: $lnk"
}
