#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

cat >&2 <<'NOTICE'
This script is intentionally disabled.

The patch in patches/session-persistence-android.patch is a historical
research artifact with a known whitespace/application problem. It is not
a supported or ready-to-apply fix.

Do not apply it to a working Harness installation. See README.md and
docs/hardlink-eacces.md for the current research status.
NOTICE

exit 1
