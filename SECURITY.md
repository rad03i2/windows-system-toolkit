# Security Policy

## Supported version
The latest `main` branch is supported.

## Safety model
Windows System Toolkit is read-only by default. `cleanup-preview` only enumerates candidate files; it never deletes them. The toolkit does not upload system information, use telemetry, request credentials, or require administrator rights for its normal commands.

System reports can reveal computer model, username, storage layout, and other local metadata. Review exported JSON before sharing it publicly.

## Reporting a vulnerability
Please use GitHub's private vulnerability reporting feature when available. Do not publish secrets, private machine data, or exploit details in a public issue.
