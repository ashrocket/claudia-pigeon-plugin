# Publishing Guide

## Step 1: Create GitHub Repository

1. Go to [github.com/new](https://github.com/new)
2. Create repo: `claudia-pigeon-plugin`
3. Owner: `ashrocket`
4. Make it **Public**
5. Do NOT initialize with README (we have one)

## Step 2: Push to GitHub

```bash
cd ~/ashcode/claudia-pigeon-plugin

# Add remote
git remote add origin https://github.com/ashrocket/claudia-pigeon-plugin.git

# Push main branch
git branch -M main
git push -u origin main
```

## Step 3: Verify Repository

Check that GitHub shows:
- ✅ All files present
- ✅ Commits visible in history
- ✅ README renders correctly
- ✅ plugin.json in `.claude-plugin/` directory

## Step 4: Register with Claude Code Plugin Registry

### Option A: Via claude.ai

1. Visit [claude.ai/code/plugins](https://claude.ai/code/plugins)
2. Click "Submit Plugin"
3. Enter:
   - **Name:** claudia-pigeon
   - **GitHub URL:** https://github.com/ashrocket/claudia-pigeon-plugin
   - **Description:** Send messages, questions, and documents to your phone via push notification. Get replies without returning to the laptop.

### Option B: Via Claude Code CLI

```bash
claude plugins submit ashrocket/claudia-pigeon-plugin
```

## Step 5: Installation Test

After registration (wait ~1 hour for sync), test:

```bash
claude plugins add ashrocket/claudia-pigeon-plugin
/pigeon-setup
/pigeon-check
```

Expected output: Setup completes, check passes.

## Versioning & Updates

- Update `version` in `.claude-plugin/plugin.json`
- Commit and push to GitHub
- Registry auto-syncs within 1 hour

**Version scheme:** `MAJOR.MINOR.PATCH` (semantic versioning)

Example:
- `1.0.0` → `1.0.1` (bug fixes)
- `1.0.0` → `1.1.0` (new features)
- `1.0.0` → `2.0.0` (breaking changes)

## Success Criteria

✅ Plugin is public on GitHub  
✅ Plugin appears in registry  
✅ `claude plugins add ashrocket/claudia-pigeon-plugin` works  
✅ `/pigeon-setup` runs without errors  
✅ `/pigeon hello` sends message to phone  
✅ Natural language triggers work ("pigeon it to me")  

## Support

For issues:
- File issues on GitHub at https://github.com/ashrocket/claudia-pigeon-plugin/issues
- Reference TESTING.md for diagnostics
- Include output of `/pigeon-check` in bug reports
