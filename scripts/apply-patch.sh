#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
PATCH_FILE="${REPO_DIR}/patches/session-persistence-android.patch"
DSH_ROOT="${1:-$PWD}"
TARGET="node_modules/@deepseek-ai/dsh-session-persistence-jsonl/lib/index.js"

if [[ ! -f "${DSH_ROOT}/${TARGET}" ]]; then
  echo "Cannot find ${TARGET} under: ${DSH_ROOT}" >&2
  echo "Pass the DSH installation root as the first argument." >&2
  exit 1
fi

if ! command -v patch >/dev/null 2>&1; then
  echo "The 'patch' command is required. Install it in Termux with: pkg install patch" >&2
  exit 1
fi

cd "${DSH_ROOT}"
patch --dry-run -p1 < "${PATCH_FILE}"
patch -p1 < "${PATCH_FILE}"

echo "Patch applied. Review the resulting diff and run the verification steps."
