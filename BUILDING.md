# Building UFO:AI

This document is a practical quick-start for local builds and dependency setup.

## 1) Build flow

The project uses a `configure` script + generated `Makefile`.

```bash
./configure
make -j$(nproc)
```

Useful configure flags:

- Debug builds are the default (`./configure` prints `Debug build`; there is no `--enable-debug` flag).
- `--enable-release`
- `--enable-ccache`
- `--prefix=/custom/prefix`

To inspect options:

```bash
./configure --help
```

## 2) Linux dependencies

Package names vary by distro; below are the *logical* dependencies detected by `configure`.

### Core game/runtime dependencies

- C/C++ toolchain (`gcc`, `g++`, make)
- SDL2 (`SDL.h` via `sdl2`)
- SDL2_mixer (`SDL_mixer.h`)
- SDL2_ttf (`SDL_ttf.h`)
- Lua 5.3+ (`lua.h`, typically `lua5.3` or `lua5.4`)
- mxml (`mxml.h`, package often called `mxml` or `mxml4`)
- Ogg (`ogg/ogg.h`)
- Vorbis (`vorbis/codec.h`)

### Common media/system libs

- zlib
- libpng
- libjpeg
- libwebp
- libcurl
- libxml2

### Optional/tooling dependencies

- OpenAL (`AL/al.h`)
- GoogleTest (`gtest/gtest.h`) for test module support
- For `uforadiant`:
  - GTK+2 (`gtk/gtk.h`)
  - GtkGLExt (`gtk/gtkglwidget.h`)
  - GtkSourceView 2.0 (`gtksourceview/gtksourceview.h`)

## 3) Windows dependencies

Windows builds require equivalent development libraries and headers for:

- OpenGL (`opengl32`)
- SDL2 / SDL2_mixer / SDL2_ttf
- Lua 5.3+
- mxml
- Ogg/Vorbis
- zlib/libpng/libjpeg/libwebp/libcurl/libxml2
- (Optional) OpenAL
- (Optional) GTK2/GtkGLExt/GtkSourceView for `uforadiant`

Use either:

- MinGW toolchains with matching `*-dev`/headers and import libs, or
- an IDE project setup from `build/projects/` with all third-party libs configured.

## 4) Troubleshooting

If modules are disabled after `configure`, review the dependency summary printed at the end. Missing headers/libraries are reported there per target (e.g. `ufo`, `ufoded`, `ufo2map`, `uforadiant`).

If `make ufo` says there is no such target, the `ufo` module was disabled by configure due to missing dependencies.

## 5) Sanity checks

```bash
./configure
make -j$(nproc)
```

Then verify binaries were produced for the modules you enabled.
