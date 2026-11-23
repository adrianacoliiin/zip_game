# Usar SOLO si `flutter pub get` no encuentra el paquete material_ui.
# Cambia los imports a package:flutter/material.dart y quita la dependencia del pubspec.
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)
Get-ChildItem -Recurse -Include *.dart -Path lib, test -ErrorAction SilentlyContinue | ForEach-Object {
  $c = Get-Content $_.FullName -Raw -Encoding UTF8
  $n = $c -replace "package:material_ui/material_ui.dart", "package:flutter/material.dart"
  if ($n -ne $c) { [IO.File]::WriteAllText($_.FullName, $n, (New-Object Text.UTF8Encoding $false)); Write-Host "  actualizado $($_.Name)" }
}
(Get-Content pubspec.yaml -Encoding UTF8) | Where-Object { $_ -notmatch '^\s*material_ui:' } | Set-Content pubspec.yaml -Encoding UTF8
flutter pub get
