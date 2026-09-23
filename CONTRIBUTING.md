# Contributing

Contributions are welcome when they keep the toolkit safe, focused, and testable.

1. Fork the repository and create a focused branch.
2. Keep default behavior read-only. Destructive actions require explicit opt-in and should provide a preview first.
3. Add or update tests in `tests/Toolkit.Tests.ps1`.
4. Run `pwsh -NoProfile -File ./tests/Toolkit.Tests.ps1` on Windows.
5. Update both English and Arabic README sections when behavior changes.
6. Open a pull request describing the behavior, validation performed, and Windows version used.

Do not commit machine-specific reports, credentials, tokens, personal paths, binaries, or generated temporary data.
