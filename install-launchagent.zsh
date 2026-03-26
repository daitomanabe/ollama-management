#!/bin/zsh
set -eu

SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
TEMPLATE_PATH="${SCRIPT_DIR}/local.ollama.safe.plist"
TARGET_PATH="${HOME}/Library/LaunchAgents/local.ollama.safe.plist"

mkdir -p "${HOME}/Library/LaunchAgents"

sed "s|{repo_path}|${SCRIPT_DIR}|g" "${TEMPLATE_PATH}" > "${TARGET_PATH}"

plutil -lint "${TARGET_PATH}" >/dev/null

echo "Installed ${TARGET_PATH}"
