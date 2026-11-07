#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

echo "== Runtime =="
node -e 'console.log(JSON.stringify({version:process.version,platform:process.platform,arch:process.arch},null,2))'

echo
echo "== Android =="
if command -v getprop >/dev/null 2>&1; then
  printf 'release: '; getprop ro.build.version.release
  printf 'api: '; getprop ro.build.version.sdk
else
  echo "getprop not found"
fi

echo
echo "== Koffi =="
node -e 'const k=require("koffi"); console.log("koffi loaded:", typeof k.load === "function")'

echo
echo "== libc renameat2 symbol =="
node - <<'NODE'
const koffi = require("koffi");
const libc = koffi.load("/system/lib64/libc.so");
const renameat2 = libc.func("int renameat2(int, const char *, int, const char *, unsigned int)");
console.log("renameat2 symbol loaded:", typeof renameat2 === "function");
NODE
