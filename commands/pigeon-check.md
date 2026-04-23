# /pigeon-check

Diagnostic command to verify Pigeon setup.

**Usage:**
```
/pigeon-check
```

**Checks:**
- Server health (ping via `pigeon.sh health`)
- Environment variables set (`PIGEON_URL`, `PIGEON_API_KEY`)
- Dependencies installed (`curl`, `jq`)
- Gmail MCP available (if opted into dual-channel)

**Output:** Status report like:
```
✓ Pigeon: healthy
✓ Env vars: configured
✓ Dependencies: installed
✓ Gmail MCP: available
Ready to use pigeon.
```

**Troubleshooting:** If any check fails, follow the error message to fix it.
