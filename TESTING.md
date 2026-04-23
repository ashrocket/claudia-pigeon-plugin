# Plugin Testing Guide

## Pre-Installation

Ensure you have:
- Claude Code CLI installed
- `curl` and `jq` available in your terminal
- A Claudia Pigeon server running (self-hosted or hosted account)
- API credentials: `PIGEON_URL` and `PIGEON_API_KEY`

## Installation

```bash
claude plugins add github:ashrocket/claudia-pigeon-plugin
```

Or for local testing:

```bash
claude plugins add file:///path/to/claudia-pigeon-plugin
```

## Test Suite

### 1. Setup Test

```
/pigeon-setup
```

**Expected behavior:**
- Prompts for PIGEON_URL if not set
- Prompts for PIGEON_API_KEY if not set
- Verifies server connectivity
- Asks about Gmail dual-channel (optional)
- Creates `.local.md` with settings
- Confirms setup success

**Pass if:** All prompts work, `.local.md` is created, no errors

### 2. Diagnostic Test

```
/pigeon-check
```

**Expected behavior:**
- Reports Pigeon server status
- Lists configured env vars
- Checks for `curl` and `jq`
- Reports Gmail MCP availability (if opted in)

**Pass if:** All checks report healthy/available

### 3. Manual Message Test

```
/pigeon hello from the plugin
```

**Expected behavior:**
- Message appears in Pigeon inbox on phone
- Confirms message ID in response

**Pass if:** Message lands on phone within 5 seconds

### 4. Manual Question Test

```
/pigeon
```

Then say: "Ask the user if the deploy looks good"

**Expected behavior:**
- Question sends to phone as `type: question`
- Claude polls for reply (5s intervals)
- When you reply on phone, Claude shows the reply in conversation

**Pass if:** Full round-trip: send → phone → reply → back to Claude

### 5. Natural Language Trigger Test

In conversation, say: "Pigeon it to me — the API is ready for review"

**Expected behavior:**
- Skill detects "pigeon it to me"
- Routes to Pigeon channel
- Sends as message type
- Appears on phone

**Pass if:** Message lands on phone automatically (no slash command)

### 6. Email Channel Test (if Gmail opted in)

In conversation, say: "Email me this deployment guide"

**Expected behavior:**
- Skill detects "email me"
- Routes to Gmail MCP if available
- Creates draft in Gmail, or falls back to Pigeon

**Pass if:** Draft appears in Gmail (or fallback message to phone)

### 7. Stop Hook Test

Run a task with 3+ tool calls:

```
/pigeon
```

Then ask Claude to do something complex (file operations, API calls, etc.)

**Expected behavior:**
- After Claude finishes, you receive a status notification on phone
- Summary describes what was done
- Shows project/directory name

**Pass if:** Auto-notification arrives on phone after task completes

## Full Integration Test

1. Install plugin
2. Run `/pigeon-setup`
3. Run `/pigeon-check`
4. Send a message via `/pigeon`
5. Ask a question and reply
6. Trigger NL skill ("pigeon it to me")
7. Complete a multi-tool task to trigger stop hook

**Success:** All 7 tests pass without errors

## Troubleshooting

If any test fails:

1. Run `/pigeon-check` to diagnose
2. Verify `PIGEON_URL` and `PIGEON_API_KEY` are set
3. Check server is reachable: `curl -H "Authorization: Bearer $PIGEON_API_KEY" $PIGEON_URL/api/messages`
4. Check `curl` and `jq` are installed: `which curl && which jq`
5. Check phone app is configured and receiving notifications

## Known Limitations

- Polling timeout is 5 minutes for questions
- Stop hook only fires on substantive tasks (3+ tool calls)
- Voice features require iOS 7+ (read-aloud) or 13+ (dictation)
