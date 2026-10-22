@echo off
setlocal
title 写真のExif見る君 アイコン作成
set "APP=%~dp0"
set "APP=%APP:~0,-1%"
echo.
echo  デスクトップとスタートメニューに「写真のExif見る君」のアイコンを作ります...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%APP%\scripts\create_shortcut.ps1" -AppDir "%APP%"
if errorlevel 1 (
  echo.
  echo  アイコンを作れませんでした。上のメッセージを確認してください。
) else (
  echo.
  echo  完了しました。デスクトップの「写真のExif見る君」をダブルクリックすると開きます。
)
echo.
pause
