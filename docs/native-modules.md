# Native Node modules

The tested Harness dependency tree contained these native addons:

- `@deepseek-ai/node-addon-system` Android ARM64 system addon
- `node-addon-require-builtin` Android ARM64 N-API addon
- `koffi` Android ARM64 addon
- `node-pty` addon

In the tested environment:

- The first three addons loaded successfully.
- `node-pty` was tested beyond module loading: process spawn, output capture, interactive input, terminal resize, and Ctrl+C interruption all worked in the recorded tests.
- The session-persistence experiment used the already-present `koffi` dependency to call Android libc.

These results apply only to the specific installed artifacts and runtime that were tested. They do not establish that a fresh npm installation on another device will obtain compatible binaries, nor that every feature of these packages works.

Native addon compatibility depends on the Android ABI, Node.js ABI/N-API level, package build artifacts, and the specific feature being used. The repository does not provide a complete, reproducible native-module build or distribution process.
