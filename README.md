# YouMind Skills

AI agent skills powered by [YouMind](https://youmind.com). Extract knowledge, create content, and manage your learning — all from your favorite AI coding tools.

## Available Skills

| Skill | Description |
|-------|-------------|
| [youmind](skills/youmind/) | Base CLI skill — search, inspect, and call YouMind APIs |
| [youmind-youtube-transcript](skills/youmind-youtube-transcript/) | Batch extract YouTube video transcripts — up to 5 at once, no yt-dlp needed |

*More skills coming soon: image generation, link saving, notes, documents, slides...*

## Quick Install

```bash
# Install a specific skill
npx skills add YouMind-OpenLab/skills --skill youmind-youtube-transcript

# See all available skills
npx skills add YouMind-OpenLab/skills --list

# Install everything
npx skills add YouMind-OpenLab/skills --all
```

Also available on [ClawHub](https://clawhub.ai):
```bash
clawhub install youmind-youtube-transcript
```

## Prerequisites

All skills require the [YouMind CLI](https://www.npmjs.com/package/@youmind-ai/cli):

```bash
npm install -g @youmind-ai/cli
export YOUMIND_API_KEY=sk-ym-xxx
```

Get your API key at **https://youmind.com/settings/api-keys**

## Works With

These skills work with any AI agent that supports the skill format:

- [OpenClaw](https://openclaw.ai)
- [Claude Code](https://claude.ai/code)
- [Cursor](https://cursor.sh)
- [Codex](https://openai.com/codex)
- [Gemini CLI](https://github.com/google-gemini/gemini-cli)
- Any tool supporting `npx skills add`

## Contributing

See [shared/PUBLISHING.md](shared/PUBLISHING.md) for the publishing guide.

## License

MIT
