# Setup

## Installation

Install the YouMind CLI (lightweight, zero dependencies):

```bash
npm install -g @youmind-ai/cli
```

Verify: `youmind --help`

If not found, install it first before proceeding.

## Authentication

Check if `YOUMIND_API_KEY` is already set (without exposing the value):

```bash
[ -n "$YOUMIND_API_KEY" ] && echo "YOUMIND_API_KEY is set" || echo "YOUMIND_API_KEY is not set"
```

If set, proceed to the workflow.

If not set, tell the user to configure it themselves (do NOT ask them to paste the key in chat):

**For OpenClaw users** (recommended — set once, persists forever):

> "You need a YouMind API key. Get one free at https://youmind.com/settings/api-keys
>
> Then add it to your `~/.openclaw/openclaw.json`:
> ```json5
> {
>   skills: {
>     entries: {
>       "youmind-youtube-transcript": {
>         apiKey: "sk-ym-your-key-here"
>       }
>     }
>   }
> }
> ```
>
> Restart the gateway and you're all set!"

**For other platforms** (Claude Code, Cursor, etc.):

> "You need a YouMind API key. Get one free at https://youmind.com/settings/api-keys
>
> Then set it in your shell profile (`~/.bashrc` or `~/.zshrc`):
> ```bash
> export YOUMIND_API_KEY=sk-ym-your-key-here
> ```
>
> Restart your terminal and you're all set!"

Wait for confirmation, then verify again (without echoing the key) before proceeding.
