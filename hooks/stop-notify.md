# Stop Hook — Auto-Notify on Task Completion

Automatically sends a status update to your Pigeon inbox when Claude finishes a task.

**Trigger:** Fires when Claude produces a final response (Stop hook).

**Guard Rails**

Only fires if ALL of these are true:

1. **Minimum complexity**: Conversation had 3+ tool calls in the current turn (skips trivial responses)
2. **User not watching**: No user input in last 30 seconds (respects active interaction)
3. **Opt-in enabled**: `stop_notify: true` in `.local.md` (set by `/pigeon-setup`)

**Behavior**

1. Generate 1-2 sentence summary of what was done
2. Extract project name from working directory or use default
3. Send as `type: status` to Pigeon channel
4. Title: project name or context
5. Body: brief summary (files changed, tests run, etc.)

**Example Notification**

> **kureapp-node** — Added pagination to /api/clients endpoint, updated tests. 3 files changed.

**Configuration**

In `.local.md`:

```markdown
# Auto-notify when Claude finishes work
stop_notify: true
```

Set to `false` to disable.

**Why Stop Hook?**

- PostToolUse fires on every tool call (too noisy)
- Stop fires once when Claude is done (right signal, right frequency)
