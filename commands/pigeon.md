# /pigeon

Send something to your Pigeon inbox manually.

**Usage:**
- `/pigeon hello world` — Send "hello world" as a message
- `/pigeon` (no args) — Claude infers what to send from conversation context (delegates to skill)

**Examples:**
```
/pigeon build finished, ready for review
/pigeon
```

**Behavior:**
- **With message**: Sends immediately as type `message` to Pigeon channel
- **Without message**: Delegates to Pigeon skill to infer message type, content, and channel from context

**Output:** Confirms the message was sent with its ID.
