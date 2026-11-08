# Hard-link publication failure in the tested Termux environment

A minimal Node.js `fs.link()` test in the tested Termux HOME returned `EACCES`. The Harness session-persistence code encountered the same error while publishing a session file.

This is an observation from one environment and filesystem location. It must not be generalized to every Android filesystem, shared-storage mount, Termux installation, or Android release.

## Session-persistence experiment

The local experiment used Android libc:

- Library: `/system/lib64/libc.so`
- Function: `renameat2`
- Directory descriptor: `AT_FDCWD` (`-100`)
- Flag: `RENAME_NOREPLACE` (`1`)

A focused test showed that, in the tested location, publishing to a new destination succeeded and attempting to publish over an existing destination returned `EEXIST` without overwriting it.

A local modification of the session-persistence package then allowed a real Harness Web session to be restarted with previous history still available.

**Important:** the patch checked into this repository has a known whitespace/application problem and is retained for historical inspection only. It is not a supported, ready-to-apply fix. See the repository README.

## Attachment persistence is a separate unresolved problem

The attachment package also uses hard links, but its call sites do not all have the same semantics:

- A staged temporary object may be published by moving it to its final name, provided no-clobber behavior and cleanup are preserved.
- An immutable content-addressed object may be the source for multiple aliases. Its source must remain available after an alias is created.

A direct `renameat2` replacement at the alias call site would move the source object and could break later aliases. Copy-and-publish approaches introduce different storage, atomicity, and cleanup trade-offs.

No complete attachment-persistence adaptation or end-to-end attachment test is provided by this repository.

## General limitation

`renameat2(RENAME_NOREPLACE)` is not a universal replacement for hard links. Whether it is appropriate depends on the exact source lifetime, destination collision behavior, filesystem, and failure-cleanup semantics of each call site.
