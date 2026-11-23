#!/usr/bin/env bash
# Usar SOLO si `flutter pub get` no encuentra el paquete material_ui.
# Cambia los imports a package:flutter/material.dart y quita la dependencia del pubspec.
set -e
cd "$(dirname "$0")/.."
grep -rl "package:material_ui/material_ui.dart" lib test 2>/dev/null | while read -r f; do
  sed -i 's#package:material_ui/material_ui.dart#package:flutter/material.dart#' "$f"
  echo "  actualizado $f"
done
sed -i '/^[[:space:]]*material_ui:/d' pubspec.yaml
flutter pub get
