# dsh-android-termux

Research notes on running DeepSeek Harness natively in Termux on Android.

> **Status: incomplete research archive — not a ready-to-use Android port.**
>
> This repository records observations from one working Android/Termux environment. It does not provide a complete, maintained, or generally reproducible installation. The session patch currently stored here is known to be unsuitable for direct application; the attachment persistence path is not fixed. Do not apply the patch or treat these files as a working compatibility kit.

> **Unofficial project.** This repository is not affiliated with, endorsed by, or officially supported by DeepSeek.

## What was demonstrated

On one Android 15 / ARM64 / Termux environment, the following were observed:

- DeepSeek Harness CLI 0.2.2-rc.1 could start natively in Termux, without Debian or PRoot.
- Several Android ARM64 Node.js native addons loaded.
- `node-pty` was exercised for process spawning, interactive input/output, terminal resize, and Ctrl+C interruption.
- In the tested Termux HOME, Node.js `fs.link()` returned `EACCES` for the session-persistence use case.
- Android libc `renameat2(RENAME_NOREPLACE)` worked in a focused test and was used in a local session-persistence modification.
- A real Harness Web process recovered previous session history after restart.

These observations are specific to the tested environment. They do not establish compatibility with other devices, Android versions, filesystems, Node.js ABIs, Termux builds, or Harness releases.

## Known incomplete areas

- **The checked-in session patch is not a supported drop-in fix.** Its whitespace formatting was found to be unreliable when applying it with the standard patch tool. It is retained only as a historical research artifact.
- **Attachment persistence is unresolved.** The attachment package contains separate hard-link publication paths with different source-file lifetime requirements. No complete, tested Android-compatible patch is provided here.
- **Sandboxing is not implemented.** There is no Android sandbox backend or isolated Runner in this repository. Unrestricted command execution must not be described as sandboxed.
- **Packaging and clean-install reproducibility have not been established.** This repository does not distribute a complete Harness runtime or native binary bundle.

## Research directions

The work may be useful as a starting point for further investigation:

1. Reproduce the `fs.link()` behavior on the target filesystem and distinguish it from other Android storage locations.
2. Evaluate `renameat2(RENAME_NOREPLACE)` only for publication paths where moving the source is semantically safe.
3. For content-addressed attachment objects, preserve the source object when creating aliases; a direct rename is not equivalent to a hard link.
4. Test session and attachment persistence independently, including collisions, crash cleanup, and restart recovery.
5. Treat Android sandboxing as a separate security engineering project, not as a side effect of running inside PRoot.

These are research suggestions, not implementation instructions or guarantees.

## Repository contents

- `docs/`: environment observations, native-module notes, filesystem findings, and sandbox limitations.
- `patches/`: an experimental historical patch, retained for inspection only.
- `tests/`: a focused test of the Android `renameat2` primitive; it is not an end-to-end Harness test.
- `scripts/verify-environment.sh`: prints selected environment and symbol information.
- `scripts/apply-patch.sh`: intentionally disabled because the archived patch is not safe to present as an installable fix.

## Licensing

The MIT license in this repository applies only to original materials authored here, subject to the notices in [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md). It does not relicense DeepSeek Harness or third-party dependencies. Consult the relevant upstream package licenses before redistributing or modifying upstream material.

## Contributions

Reproducible device-specific observations and careful corrections are welcome. Include Android version, architecture, Termux version, Node.js version, Harness package version, filesystem location, and exact test output. Do not include API keys, session files, access tokens, or private logs.
