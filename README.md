# dsh-android-termux

Community compatibility notes and patches for running DeepSeek Harness natively in Termux on Android.

> **Unofficial project.** This repository is not affiliated with, endorsed by, or officially supported by DeepSeek.

## Project status

The following work was tested on a specific Android 15 / ARM64 / Termux environment:

- Running the DeepSeek Harness Web CLI directly in native Termux, without Debian or PRoot.
- Loading selected Android ARM64 native Node.js addons.
- Diagnosing a hard-link publication failure (`EACCES`) in the tested Termux HOME.
- Using Android libc `renameat2(RENAME_NOREPLACE)` as an Android-only alternative for publishing session files.
- Restarting the Harness Web process and confirming that previous session history remained available.
- Investigating the limitations of existing Linux sandbox backends under Android/Termux.

Compatibility is not guaranteed for other Android versions, Termux builds, Node.js versions, filesystems, or Harness releases. See [the tested environment](docs/environment.md).

## Android session persistence patch

Patch file: [`patches/session-persistence-android.patch`](patches/session-persistence-android.patch)

The patch changes only the Android publication path in the upstream session-persistence package. On Android it calls `renameat2` through the already-declared `koffi` dependency, using `RENAME_NOREPLACE` to preserve no-clobber behavior. Non-Android code paths remain unchanged.

### Apply

Back up your installation before modifying dependencies. From this repository checkout:

```bash
bash scripts/apply-patch.sh "$HOME/dsh-test"
```

Replace the example path with the root of your Harness installation. The script performs a dry run before applying the patch. It requires the `patch` utility.

The target package file is:

```
node_modules/@deepseek-ai/dsh-session-persistence-jsonl/lib/index.js
```

After applying, review the diff, run `node --check` on the modified file, and start Harness to verify session creation and restart recovery. Reinstalling dependencies may overwrite this local patch.

### Verify the Android primitive

From the root of a compatible Harness installation, run:

```bash
node /path/to/dsh-android-termux/tests/renameat2-test.js
```

The test creates and removes its own temporary directory. It checks that a new destination can be published and that an existing destination is not overwritten.

## Sandbox status

This repository does **not** implement an Android sandbox or an isolated Runner. The current findings and limitations are documented in [`docs/android-sandbox.md`](docs/android-sandbox.md). In particular, PRoot is not treated as a security boundary, and unrestricted command execution must not be described as sandboxed.

## Repository contents

- `patches/`: compatibility patch files.
- `docs/`: environment notes, verified behavior, and known limitations.
- `scripts/`: helper scripts for applying the patch and inspecting the environment.
- `tests/`: focused tests for the Android filesystem primitive.
- `THIRD_PARTY_NOTICES.md`: upstream attribution and licensing notes.

## Licensing

The MIT license in this repository applies to original materials authored for this repository, subject to the notices in [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md). The patch targets an upstream DeepSeek Harness file; upstream copyright and license terms continue to apply to upstream material. This repository does not relicense DeepSeek's code.

## Contributions

Bug reports, device-specific verification, and compatibility notes are welcome. Please include Android version, CPU architecture, Termux version, Node.js version, Harness package version, and the exact error or test output. Do not include API keys, session files, access tokens, or private logs.
