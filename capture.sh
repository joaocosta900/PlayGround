#!/usr/bin/env bash
# Capture desktop and mobile screenshots of the running preview.
# Reacts to CAPTURE_URL and CAPTURE_DIR; leaves the app running untouched.
set -euo pipefail
cd "$(dirname "$0")"

: "${CAPTURE_URL:?"Set CAPTURE_URL to the preview URL."}"
: "${CAPTURE_DIR:?"Set CAPTURE_DIR to the capture output directory."}"

# Our ready marker: the world HUD only appears after the game script has run.
export CAPTURE_READY_SELECTOR="${CAPTURE_READY_SELECTOR:-#wd}"
export CAPTURE_AUTO_START="${CAPTURE_AUTO_START:-false}"

timed() { echo "+ $*" >&2; /usr/bin/time -p "$@"; }  # header/stderr so redirections keep stdout clean

timed mkdir -p "$CAPTURE_DIR"
timed bash -n "$0"

# Defer to the runtime capture driver: playwright, transient-failure exit 75,
# defect exit 1, browser closed in finally. App server is not touched.
timed node "${RUNTIME_DIR:?}/scripts/default-capture.mjs"
