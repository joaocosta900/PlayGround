#!/usr/bin/env bash
# Serve the game as a static site (foreground) on PORT (default 3000).
set -euo pipefail
cd "$(dirname "$0")"
PROJECT_DIR="$(pwd -P)"
DIST="$PROJECT_DIR/dist"
PORT="${PORT:-3000}"
WEB_DIR="${OPENCODE_WEB_DIR:-${RUNNER_TEMP:-/home/runner/work/_temp}/omgithub-web}"

timed() { echo "+ $*" >&2; /usr/bin/time -p "$@"; }  # header/stderr so redirections keep stdout clean

# Build: the game is a single self-contained HTML page; publish it as dist/index.html.
timed mkdir -p "$DIST"
timed cp -f "$PROJECT_DIR/mundos-brutalismo.html" "$DIST/index.html"

# Worker metadata only (deployment descriptor lives outside the source tree).
timed mkdir -p "$WEB_DIR"
# Atomic JSON write: temp label + rename, so no log text ever ends up inside the file.
printf '{"project":"%s","directory":"%s"}\n' "$PROJECT_DIR" "$DIST" > "$WEB_DIR/.deployment-output.tmp"
timed mv -f "$WEB_DIR/.deployment-output.tmp" "$WEB_DIR/deployment-output.json"

# Serve dist in the foreground so the calling session keeps it alive.
echo "Serving $DIST on port $PORT" >&2
exec /usr/bin/time -p python3 -m http.server "$PORT" --bind 0.0.0.0 --directory "$DIST"
