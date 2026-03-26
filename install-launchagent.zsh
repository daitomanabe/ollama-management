#!/bin/zsh
set -eu

SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
TEMPLATE_PATH="${SCRIPT_DIR}/local.ollama.safe.plist"
TARGET_PATH="${HOME}/Library/LaunchAgents/local.ollama.safe.plist"
LOG_PATH="${HOME}/Library/Logs/local.ollama.safe.log"

mkdir -p "${HOME}/Library/LaunchAgents"
mkdir -p "${HOME}/Library/Logs"

sed \
  -e "s|{repo_path}|${SCRIPT_DIR}|g" \
  -e "s|{log_path}|${LOG_PATH}|g" \
  "${TEMPLATE_PATH}" > "${TARGET_PATH}"

plutil -lint "${TARGET_PATH}" >/dev/null

echo "Installed ${TARGET_PATH}"
