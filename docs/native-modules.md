# Native Node modules

The tested Harness dependency tree contained these native addons:

- `@deepseek-ai/node-addon-system` Android ARM64 system addon
- `node-addon-require-builtin` Android ARM64 N-API addon
- `koffi` Android ARM64 addon
- `node-pty` addon

In the tested environment, the first three addons loaded successfully. The `node-pty` JavaScript entry point could be required, but a full PTY spawn/interaction test was not completed. Do not interpret module loading as proof that every native feature works.

The session persistence compatibility patch uses the already-declared `koffi` dependency to call Android libc. It does not add a new npm dependency.

Native addon compatibility depends on the Android ABI, Node.js ABI/N-API level, package build artifacts, and the specific feature being used.
