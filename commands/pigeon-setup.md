# /pigeon-setup

Initialize Claudia Pigeon plugin. Guides you through first-run configuration.

**Run once to:**
1. Check for `PIGEON_URL` and `PIGEON_API_KEY` env vars
2. If missing: prompt you to provide them
3. Verify connectivity with `pigeon.sh health`
4. Ask if you want dual-channel delivery (Pigeon + Gmail)
5. Check that `curl` and `jq` are installed
6. Create `.local.md` config file with your preferences

**Usage:**
```
/pigeon-setup
```

**Output:** Reports success or error messages to guide setup.

**After setup:** You can use `/pigeon hello` or just say "pigeon it to me" in conversation.

**Re-running:** Safe to run multiple times. Updates config without losing settings.
