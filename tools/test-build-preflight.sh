#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT_DIR"

if [[ ! -f Makefile.local || "${1:-}" == "--reconfigure" ]]; then
  echo "[preflight] Running ./configure to refresh build metadata..."
  ./configure >/tmp/ufoai-configure.log
  echo "[preflight] configure output captured at /tmp/ufoai-configure.log"
fi

if [[ ! -f Makefile.local ]]; then
  echo "[preflight] ERROR: Makefile.local was not generated."
  exit 1
fi

get_value() {
  local key="$1"
  local value
  value=$(sed -n "s/^${key}[[:space:]]*?=[[:space:]]*//p" Makefile.local | head -n1)
  value=${value%\"}
  value=${value#\"}
  echo "$value"
}

is_enabled() {
  local target="$1"
  [[ "$(get_value "${target}_DISABLE")" != "yes" ]]
}

has_feature() {
  local feature="$1"
  [[ "$(get_value "$feature")" == "1" ]]
}

print_missing() {
  local -a missing=()
  for pair in "$@"; do
    local var=${pair%%:*}
    local label=${pair#*:}
    if ! has_feature "$var"; then
      missing+=("$label")
    fi
  done

  if [[ ${#missing[@]} -eq 0 ]]; then
    echo "  none"
  else
    printf '  - %s\n' "${missing[@]}"
  fi
}

echo "[preflight] Enabled build targets:"
for target in cgame-campaign cgame-multiplayer cgame-skirmish game testall ufo ufo2map ufoded ufomodel uforadiant; do
  if is_enabled "$target"; then
    echo "  - $target"
  fi
done

echo
if is_enabled testall; then
  echo "[preflight] testall target is enabled ✅"
else
  echo "[preflight] testall target is disabled ❌"
  echo "[preflight] Missing dependencies for testall:"
  print_missing \
    HAVE_MXML4_MXML_H:mxml \
    HAVE_SDL2_MIXER_SDL_MIXER_H:SDL2_mixer \
    HAVE_SDL2_TTF_SDL_TTF_H:SDL2_ttf \
    HAVE_GTEST_GTEST_H:GoogleTest
fi

echo
if is_enabled ufo; then
  echo "[preflight] ufo client target is enabled ✅"
else
  echo "[preflight] ufo client target is disabled ❌"
  echo "[preflight] Missing dependencies for ufo:"
  print_missing \
    HAVE_LUA5_4_LUA_H:lua5.4 \
    HAVE_LUA5_3_LUA_H:lua5.3 \
    HAVE_MXML4_MXML_H:mxml \
    HAVE_SDL2_SDL_H:SDL2 \
    HAVE_SDL2_MIXER_SDL_MIXER_H:SDL2_mixer \
    HAVE_SDL2_TTF_SDL_TTF_H:SDL2_ttf \
    HAVE_OGG_OGG_H:libogg \
    HAVE_VORBIS_CODEC_H:libvorbis
fi

echo
cat <<'HINT'
[preflight] Next steps:
  1) Install missing development packages.
  2) Re-run ./configure.
  3) Re-run this script with --reconfigure.
  4) Run a test build once testall is enabled:
       make -j"$(nproc)" testall
HINT
