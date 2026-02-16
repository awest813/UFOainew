# Building UFO:AI (CMake)

This repository has both a legacy `Makefile`/`configure` flow and a CMake flow.
For reproducible local and CI builds, use CMake (`cmake_minimum_required(VERSION 3.15)` in the root `CMakeLists.txt`).

The commands below are based on the current CMake targets and options in:

- `CMakeLists.txt` (global options and subprojects)
- `src/game/CMakeLists.txt` (game library dependencies)
- `src/server/CMakeLists.txt` (dedicated server dependencies)
- `src/client/CMakeLists.txt` (full client dependencies)

## What these instructions build

The steps here build the **dedicated server + game library** (`ufoded` + `game`) on both Linux and Windows/MSVC.

To keep cross-platform setup manageable, they explicitly disable optional components that pull in larger toolchains (Radiant, tools, docs/manual, packaging, map compilation, tests, translations, and the standalone client).

## Common CMake options used

```txt
-DDISABLE_UFO=ON
-DDISABLE_TESTS=ON
-DDISABLE_TOOLS=ON
-DDISABLE_UFORADIANT=ON
-DDISABLE_I18N=ON
-DDISABLE_MANUAL=ON
-DDISABLE_DOXYGEN_DOCS=ON
-DDISABLE_BASE_PACKAGES=ON
-DDISABLE_MAPS_COMPILE=ON
```

---

## Linux

### 1) Install prerequisites (Debian/Ubuntu)

```bash
sudo apt-get update
sudo apt-get install -y \
  build-essential cmake ninja-build pkg-config \
  libsdl2-dev libcurl4-openssl-dev zlib1g-dev liblua5.3-dev
```

### 2) Configure

```bash
cmake -S . -B build/linux -G Ninja \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DDISABLE_UFO=ON \
  -DDISABLE_TESTS=ON \
  -DDISABLE_TOOLS=ON \
  -DDISABLE_UFORADIANT=ON \
  -DDISABLE_I18N=ON \
  -DDISABLE_MANUAL=ON \
  -DDISABLE_DOXYGEN_DOCS=ON \
  -DDISABLE_BASE_PACKAGES=ON \
  -DDISABLE_MAPS_COMPILE=ON
```

### 3) Build

```bash
cmake --build build/linux --parallel
```

Build outputs are placed under `build/linux/` (and the `game` shared library output under `build/linux/base/` per CMake target properties).

---

## Windows (MSVC)

### 1) Install prerequisites

- Visual Studio 2022 with **Desktop development with C++**
- CMake 3.15+
- Git
- vcpkg (recommended for dependencies)

Install dependencies with vcpkg (from a Developer PowerShell):

```powershell
git clone https://github.com/microsoft/vcpkg C:\vcpkg
C:\vcpkg\bootstrap-vcpkg.bat
C:\vcpkg\vcpkg.exe install sdl2 curl zlib lua --triplet x64-windows
```

### 2) Configure

```powershell
cmake -S . -B build\windows-msvc -G "Visual Studio 17 2022" -A x64 `
  -DCMAKE_TOOLCHAIN_FILE=C:/vcpkg/scripts/buildsystems/vcpkg.cmake `
  -DVCPKG_TARGET_TRIPLET=x64-windows `
  -DDISABLE_UFO=ON `
  -DDISABLE_TESTS=ON `
  -DDISABLE_TOOLS=ON `
  -DDISABLE_UFORADIANT=ON `
  -DDISABLE_I18N=ON `
  -DDISABLE_MANUAL=ON `
  -DDISABLE_DOXYGEN_DOCS=ON `
  -DDISABLE_BASE_PACKAGES=ON `
  -DDISABLE_MAPS_COMPILE=ON
```

### 3) Build

```powershell
cmake --build build\windows-msvc --config RelWithDebInfo --parallel
```

The dedicated server executable is produced under `build\windows-msvc\RelWithDebInfo\` and the `game` DLL under `build\windows-msvc\base\`.

---

## Building more than the core targets

If you want the standalone client (`ufo`) or other optional components, start by setting `-DDISABLE_UFO=OFF` and/or toggling other `DISABLE_*` options from the root `CMakeLists.txt`.

Be aware the client adds more dependencies (`OpenGL`, `PNG`, `JPEG`, `OGG`, `VORBIS`, `SDL_mixer`, `SDL_ttf`, `MXML`, `X11` on Linux, etc.) as defined in `src/client/CMakeLists.txt`.
