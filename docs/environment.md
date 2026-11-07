# Tested environment

The compatibility work documented here was developed and exercised on:

- Android 15 (API level 35), ARM64
- Termux 0.119.0-beta.3
- Node.js 26.12.1, running natively on Android/Bionic
- DeepSeek Harness CLI package version 0.2.2-rc.1
- Android device with a 64-bit ARM userspace

The exact device model and performance characteristics are not requirements of the patch. Other Android versions, Termux builds, Node.js versions, and Harness releases have not been established as compatible by this test.

## What was verified

- The Harness CLI starts in native Termux without a Debian/PRoot userspace.
- The relevant native Node addons load in the tested environment.
- The JSONL session persistence code can publish new files using Android's libc `renameat2` with `RENAME_NOREPLACE`.
- A real Harness Web session was created, stopped, and restarted; prior conversation history remained available.

This is a community compatibility experiment, not an official DeepSeek-supported Android build.
