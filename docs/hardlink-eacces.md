# Hard-link publication failure on the tested Termux environment

The original session persistence implementation publishes staged files with filesystem hard links.

In the tested Termux HOME directory, a minimal Node.js `fs.link()` test returned `EACCES`. The same failure occurred when the Harness attempted to publish a session file. This establishes the behavior in that tested environment; it should not be generalized to every Android filesystem or every Termux installation.

## Compatibility approach

On Android only, the patch uses:

- Android libc: `/system/lib64/libc.so`
- Function: `renameat2`
- Directory descriptor: `AT_FDCWD` (`-100`)
- Flag: `RENAME_NOREPLACE` (`1`)

This provides an atomic rename that refuses to replace an existing destination. In the tested environment:

- Publishing to a new destination succeeded.
- Publishing when the destination already existed failed with `EEXIST`.
- The existing destination was not overwritten.

The non-Android code paths remain unchanged.

## Important limitations

This patch is specific to the tested Android/Bionic environment. It assumes the libc exports `renameat2`, that the syscall is permitted by the app's execution policy, and that the source and destination are on a filesystem where the operation is supported. It is not a general replacement for all hard-link semantics on all platforms.
