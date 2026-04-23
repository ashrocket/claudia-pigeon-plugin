# Claudia Pigeon Plugin

Send messages, questions, and documents to your phone via push notification. Get replies without returning to the laptop.

## Installation

```bash
claude plugins add github:ashrocket/claudia-pigeon-plugin
```

Then run:

```
/pigeon-setup
```

This guides you through configuration.

## Features

- **Push notifications** — Messages land on your phone instantly
- **Questions with replies** — Ask blocking questions, poll for replies without checking back
- **Documents** — Send HTML explainers that render beautifully on mobile
- **Status updates** — Heartbeat notifications when tasks complete
- **Voice input** — Dictate replies via microphone (iOS 13+)
- **Voice output** — Hear messages read aloud (iOS 7+)
- **Dual-channel** — Optional email delivery alongside push (Gmail MCP)
- **Auto-notify** — Get notified when Claude finishes work (configurable)

## Quick Start

After setup, you can:

**Send a message manually:**
```
/pigeon build finished
```

**Delegate to Claude (NL detection):**
```
/pigeon
```

**Ask a blocking question:**
"Ask the user if we should deploy this"

**Send a document:**
"Email me this cost analysis"

## Commands

- `/pigeon [message]` — Send a manual message or delegate to skill
- `/pigeon-setup` — Configure PIGEON_URL and API key
- `/pigeon-check` — Verify setup and dependencies

## Configuration

Run `/pigeon-setup` to initialize:

1. Provide your Pigeon server URL (if self-hosted) or hosted instance
2. Provide API key
3. Choose dual-channel delivery (Gmail + Pigeon) — optional
4. Plugin verifies `curl` and `jq` are installed
5. Creates `.local.md` with your preferences

**Local settings** (`.local.md`):

```markdown
stop_notify: true          # Auto-notify on task completion
gmail_channel: false       # Also send via Gmail when available
```

## Architecture

- **Skill** (`skills/pigeon/SKILL.md`) — Detects NL triggers, routes to channels
- **Core script** (`scripts/pigeon.sh`) — API client (send, poll, health)
- **Commands** — `/pigeon`, `/pigeon-setup`, `/pigeon-check`
- **Stop hook** — Auto-notify on task completion

## Requirements

- **Server:** Your own Claudia Pigeon instance on Cloudflare OR hosted account
- **Credentials:** PIGEON_URL and API_KEY
- **Tools:** `curl`, `jq` (checked during setup)
- **iOS:** Safari 7+ (voice read-aloud), Safari 13+ (voice input)

## Troubleshooting

Run `/pigeon-check` to diagnose:

```
/pigeon-check
```

Reports server health, env vars, dependencies, and Gmail MCP availability.

## More Info

- [Claudia Pigeon Server](https://github.com/ashrocket/claudia-pigeon)
- [MCP Tools](https://github.com/ashrocket/claudia-pigeon/blob/main/server/src/routes/mcp.ts)
- [API Docs](https://github.com/ashrocket/claudia-pigeon#api)
