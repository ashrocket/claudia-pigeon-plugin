# Claudia Pigeon Skill

Sends messages, questions, and documents to your phone via Pigeon push notifications, with optional email delivery.

**Trigger phrases:**
- "pigeon it to me", "send it to my phone", "send me that", "let me know on my phone"
- "email it to me", "draft it", "send it to my email"  
- "ask the user", "I need the user's input", "question for the user"
- "send a status", "status update", "let them know"

## Handler

When you detect one of these patterns, decide on:
1. **Message type**: document (HTML content), question (needs reply), message (FYI), status (heartbeat)
2. **Channel**: Pigeon (push notification), Gmail (email), or both
3. **Content**: title (required), body (optional), HTML content if applicable

Then execute the appropriate send command.

### Message Types

- **document**: HTML explainer, report, or long-form content. Rendered in document viewer.
- **question**: Needs a reply to unblock work. Uses polling to wait for response.
- **message**: Async FYI or status note. No reply expected.
- **status**: Heartbeat / task completion signal.

### Channel Selection Logic

```
if user says "pigeon" or "phone" → use Pigeon
elif user says "email" or "draft" → use Gmail (fallback: Pigeon)
elif message is document → use Gmail (fallback: Pigeon)
elif message is question → use Pigeon
elif user has opted into "both" → use both Pigeon AND Gmail
else → default to Pigeon
```

### Usage in Conversation

When the user says "pigeon it to me [content]", or similar:

1. Determine message type based on content (document/question/message/status)
2. Determine channel from user's words + configuration
3. Send via `pigeon.sh send` (Pigeon) or Gmail MCP (Gmail)
4. If sending a question: poll for reply and surface in conversation
5. Report result: `Sent to [channel]: [title]`

### Example: Blocker Question

User: "Ask the user if we should merge this PR"

```bash
pigeon.sh send --type question \
  --title "Should we merge the API redesign PR?" \
  --body "We've finished the endpoint redesign and tests pass. Ready to ship?"
```

Claude polls for reply, waits up to 5 minutes, surfaces: "User replied: Yes, merge it."

### Example: Document via Gmail

User: "Email me this cost analysis"

Uses Gmail MCP if available (via `mcp__claude_ai_Gmail__create_draft`). Falls back to Pigeon document.

---

## Configuration

User configuration stored in `.local.md` (auto-created by `/pigeon-setup`):

```markdown
# Pigeon Local Settings
stop_notify: true          # Auto-notify on task completion
gmail_channel: false       # Also send docs/messages via Gmail
```

## Dependencies

- `PIGEON_URL` environment variable (set by `/pigeon-setup`)
- `PIGEON_API_KEY` environment variable (secret)
- `curl` and `jq` (checked during setup)
- Optional: Gmail MCP for email delivery
