# Tested environment

The compatibility observations in this repository were developed and exercised on:

- Android 15 (API level 35), ARM64
- Termux 0.119.0-beta.3
- Node.js 26.12.1, running natively on Android/Bionic
- DeepSeek Harness CLI package version 0.2.2-rc.1

The exact device model and performance characteristics are not requirements of the experiments. Other Android versions, Termux builds, Node.js versions, filesystems, and Harness releases have not been established as compatible.

## What was observed

- The Harness CLI started in native Termux without a Debian/PRoot userspace.
- Selected native Node addons loaded in the tested environment.
- `node-pty` process spawn, interactive I/O, resize, and Ctrl+C behavior were exercised successfully.
- In the tested Termux HOME, the session-persistence hard-link operation failed with `EACCES`.
- Android libc `renameat2(RENAME_NOREPLACE)` passed a focused no-clobber test.
- A locally modified Harness session-persistence package preserved previous session history across a real Web process restart.

## What was not established

- A clean, repeatable installation from scratch on another device.
- A complete fix for attachment persistence.
- A supported patch application workflow.
- An Android sandbox backend or isolated Runner.
- Compatibility across Android versions, filesystems, or Node.js ABIs.

This is a community compatibility research archive, not an official DeepSeek-supported Android build or a ready-to-use port.
