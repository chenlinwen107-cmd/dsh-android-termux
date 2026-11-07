# Android sandbox investigation

## Findings in the tested environment

The current Harness sandbox backend selection does not include an Android-specific backend. Its known platform chains include Linux (bubblewrap/Landlock), macOS (Seatbelt), and Windows (Windows ACL).

The tested Termux environment did not provide a usable existing backend:

- bubblewrap was not available as a usable Termux backend.
- Unprivileged user namespaces were unavailable in the tested device environment.
- A Landlock probe was terminated by Android's application syscall filtering (SIGSYS).
- PRoot was considered but not treated as a security boundary: it relies on process tracing and path translation, not an independent security domain.

As a result, a requested `workspace-write` sandbox could fail closed rather than execute a command without isolation. Running with unrestricted command access is not equivalent to a sandbox.

## Research direction, not an implementation

An independent Android Runner application could potentially use Android's per-application UID isolation. Harness would pass narrowly scoped tasks and files to the Runner through authenticated IPC. This is only a research direction.

A real implementation would still need to address filesystem transfer, network access, child processes, IPC exposure, resource limits, timeouts, and malicious workloads. A separate UID alone does not constitute a complete sandbox.

**No Android sandbox backend or isolated Runner is implemented by this repository at this stage.**
