# 📱 ZIP Game — Flutter

App de **ZIP Game** (Práctica I · Desarrollo para Dispositivos Inteligentes · UTD · 10°A BIS).
Tablero 6×6: conecta los números en orden con un solo camino que pase por las 36 celdas, sin diagonales y sin repetir.
Funciona con **mouse (Chrome)** y **táctil (Android)** y se comunica con la API de AdonisJS (`zip_game_api`).

## Requisitos

- Flutter estable reciente (`flutter --version`, `flutter doctor`)
- Backend `zip_game_api` encendido en `http://localhost:3333`

## Instalación (primera vez después de clonar)

```powershell
flutter create . --platforms=web,android --project-name zip_game
Remove-Item test\widget_test.dart -ErrorAction SilentlyContinue
flutter pub get
flutter analyze
```

`flutter create .` sólo genera las carpetas de plataforma que faltan (`web/`, el resto de `android/`);
no reemplaza `lib/`, `pubspec.yaml` ni el `AndroidManifest.xml` del repositorio.

> Si `flutter pub get` dice que no encuentra `material_ui`, tu versión de Flutter todavía trae Material integrado.
> Ejecuta `.\scripts\usar_flutter_material.ps1` (Windows) o `bash scripts/usar_flutter_material.sh` (WSL/Linux) para cambiar los imports a `package:flutter/material.dart`.

## Ejecución

```powershell
flutter run -d chrome
# Emulador Android (ve a la PC como 10.0.2.2):
flutter run --dart-define=API_URL=http://10.0.2.2:3333/api
# Celular físico en la misma red Wi-Fi:
flutter run --dart-define=API_URL=http://<IP-de-tu-PC>:3333/api
```

Usuario de demostración: **demo@zipgame.test / demo12345**.

## Pruebas

```powershell
flutter test                                                    # 19 pruebas
flutter test test/integration --dart-define=INTEGRATION=true    # con el backend encendido
flutter test 2>&1 | Tee-Object -FilePath evidencias_flutter.txt
```

## Arquitectura (feature-first con capas)

```text
lib/
├── main.dart
├── app/            app.dart · app_scope.dart (inyección de dependencias) · routes/ · theme/
├── core/           network/ (ApiClient, token) · errors/ · constants/ · utils/
├── features/
│   ├── auth/         presentation · domain · data
│   ├── home/
│   ├── levels/       presentation · domain · data
│   ├── game/         presentation (controlador, tablero, HUD) · domain (ZipRules) · data
│   ├── leaderboard/
│   └── profile/
└── shared/widgets/ (estados cargando / vacío / error)
```

| Capa | Contiene | No contiene |
|---|---|---|
| Presentation | Pantallas, widgets, controladores (`ChangeNotifier`) | HTTP directo, reglas del juego |
| Domain | Entidades, `ZipRules`, repositorios abstractos | Widgets, JSON, HTTP |
| Data | Modelos JSON, datasources HTTP, repositorios concretos | Widgets |

El `GameController` maneja el camino, el siguiente número, el cronómetro, los errores, las pistas y la finalización.
La validación local da retroalimentación inmediata, pero **el backend vuelve a validar** antes de dar puntos.

## Evidencias

- `docs/capturas/` — capturas de la app
- `docs/evidencias/` — Chrome DevTools → Network (`login`, `levels`, `games`, `finish`)
- `evidencias_flutter.txt` — salida de `flutter test`
