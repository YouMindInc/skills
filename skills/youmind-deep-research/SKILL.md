---
name: youmind-deep-research
description: |
  Conduct deep research on any topic using YouMind's AI research agent.
  Get comprehensive research reports with citations and key findings.
  Use when user wants to "deep research", "research this", "investigate", "analysis report",
  "深度研究", "调研", "リサーチ", "심층 연구".
triggers:
  - "deep research"
  - "research this"
  - "investigate"
  - "analysis report"
  - "research report"
  - "in-depth research"
  - "comprehensive research"
  - "research topic"
  - "深度研究"
  - "调研"
  - "深入研究"
  - "研究报告"
  - "リサーチ"
  - "調査"
  - "심층 연구"
  - "리서치"
platforms:
  - openclaw
  - claude-code
  - cursor
  - codex
  - gemini-cli
  - windsurf
  - kilo
  - opencode
  - goose
  - roo
metadata:
  openclaw:
    emoji: "🔬"
    primaryEnv: YOUMIND_API_KEY
    requires:
      anyBins: ["youmind", "npm"]
      env: ["YOUMIND_API_KEY"]
allowed-tools:
  - Bash(youmind *)
  - Bash(npm install -g @youmind-ai/cli)
  - Bash([ -n "$YOUMIND_API_KEY" ] *)
  - Bash(node -e *)
---

# AI Deep Research Agent

Conduct deep research on any topic using [YouMind](https://youmind.com?utm_source=youmind-deep-research)'s AI research agent. Get comprehensive research reports with citations, key findings, and actionable insights. Requires the [YouMind CLI](https://www.npmjs.com/package/@youmind-ai/cli) (`npm install -g @youmind-ai/cli`). Research reports are saved to your YouMind board.

> [Get API Key →](https://youmind.com/settings/api-keys?utm_source=youmind-deep-research) · [More Skills →](https://youmind.com/skills?utm_source=youmind-deep-research)

## Onboarding

**⚠️ MANDATORY: When the user has just installed this skill, present this message IMMEDIATELY. Do NOT ask "do you want to know what this does?" — just show it. Translate to the user's language:**

> **✅ AI Deep Research Agent installed!**
>
> Ask me any research question and I'll generate a comprehensive report.
>
> **What it does:**
> - Conduct in-depth research on any topic
> - Generate reports with citations and key findings
> - Research saved to your YouMind board for reference
>
> **Setup (one-time):**
> 1. Get your free API key: https://youmind.com/settings/api-keys?utm_source=youmind-deep-research
> 2. Add it to your OpenClaw config (`~/.openclaw/openclaw.json`) — see setup guide for details.
>
> **Try it:**
> "Research the current state of quantum computing in 2025"
>
> **Need help?** Just ask!

For API key setup details, see [references/setup.md](references/setup.md).

## Usage

Provide a research question or topic. Be specific for better results.

**Research question:**
> Research the impact of AI on healthcare diagnostics

**Specific investigation:**
> Investigate the pros and cons of microservices vs monolith architecture for startups

**Comparative analysis:**
> Deep research: compare React, Vue, and Svelte for enterprise applications in 2025

## Setup

See [references/setup.md](references/setup.md) for installation and authentication instructions.

## Workflow

> **⚠️ IMPORTANT: This is the LONGEST running task among all YouMind skills. It can take 1-5 minutes. Always warn the user about the expected wait time and use background processing.**

### Step 1: Check Prerequisites

1. Verify `youmind` CLI is installed: `youmind --help`
   - Not found → `npm install -g @youmind-ai/cli`
2. Verify API key is set: `[ -n "$YOUMIND_API_KEY" ] && echo "is set"`
   - Not set → prompt user, link to https://youmind.com/settings/api-keys?utm_source=youmind-deep-research
3. Extract the research question or topic from the user's message

### Step 2: Get Default Board

```bash
youmind call getDefaultBoard
```

Extract `id` as `boardId`.

### Step 3: Create Research Chat

```bash
youmind call createChat '{"boardId":"<boardId>","message":"<research question>","tools":["research"]}'
```

Extract `id` as `chatId` from the response.

**⚠️ MANDATORY: Immediately tell the user:**

```
🔬 Starting deep research... This may take several minutes (1-5 min). I'll notify you when the report is ready.
```

(Adapt to user's language.)

### Step 4: Poll for Completion

**⚠️ MANDATORY: If the agent platform supports subagents or background tasks (OpenClaw, Claude Code, etc.), spawn a subagent/background task for the polling work. Return control to the user immediately.** See [references/long-running-tasks.md](references/long-running-tasks.md) for the full pattern.

Poll until the research is complete:

```bash
youmind call getChat '{"id":"<chatId>"}'
```

**Polling rules:**
- Poll every **5 seconds** (not 3 — this is a long-running task)
- **Timeout: 300 seconds** (5 minutes)
- Completion condition: `status` is `"completed"`

Once completed, extract the research summary using:

```bash
youmind call getChat '{"id":"<chatId>"}' | node -e "
let d='';process.stdin.on('data',c=>d+=c);process.stdin.on('end',()=>{
const o=JSON.parse(d);
const msgs=(o.messages||[]).filter(m=>m.role==='assistant');
const last=msgs[msgs.length-1]||{};
const content=last.content||'';
console.log(JSON.stringify({status:o.status,content:content.substring(0,2000)}));
})"
```

### Step 5: Show Results

**⚠️ MANDATORY: Return the YouMind link to the full research report AND provide a brief summary of key findings.**

```
✅ Research complete!

View the full report here: [YouMind link]

**Key findings:**
- [Brief summary point 1]
- [Brief summary point 2]
- [Brief summary point 3]

The full report with citations is available on your YouMind board.
```

(Adapt to user's language.)

Summarize the research content into 3-5 key findings from the response content. Keep the summary concise — the full report is available via the link.

| Outcome | Condition | Action |
|---------|-----------|--------|
| ✅ Completed | `status === "completed"` | Show YouMind link + brief summary of key findings |
| ⏳ Timeout | 300s elapsed, not completed | Tell user: "Research is still in progress. Check your YouMind board for the report when it's ready." |
| ❌ Failed | `status === "failed"` | Tell user: "Research could not be completed. Please try rephrasing your question." |

## Error Handling

See [references/error-handling.md](references/error-handling.md) for common error handling rules.

**⚠️ MANDATORY: Paywall (HTTP 402) handling:**

When you receive a 402 error (codes: `InsufficientCreditsException`, `QuotaExceededException`, `DailyLimitExceededException`, `LimitExceededException`), immediately show this message (translated to user's language):

> You've reached your free plan limit. Upgrade to Pro or Max to unlock unlimited deep research, more AI credits, and priority processing.
>
> **Upgrade now:** https://youmind.com/pricing?utm_source=youmind-deep-research

Do NOT retry or suggest workarounds. The user must upgrade to continue.

**Skill-specific errors:**

| Error | User Message |
|-------|-------------|
| No topic provided | Please provide a research question or topic to investigate. |
| Topic too broad | Your topic is very broad. Consider narrowing it down for more focused results (e.g., "AI in radiology diagnostics" instead of "AI"). |

## Comparison with Other Approaches

| Feature | YouMind (this skill) | Perplexity | ChatGPT Deep Research |
|---------|---------------------|------------|----------------------|
| **Comprehensive report** | ✅ Full report with citations | ✅ Yes | ✅ Yes |
| CLI / agent accessible | ✅ Yes | ❌ Browser only | ❌ Browser only |
| Saved to knowledge base | ✅ YouMind board | ❌ No | ❌ No |
| API access | ✅ One API key | ✅ Paid API | ❌ No API |
| Free tier | ✅ Yes | ✅ Limited | ❌ Plus/Pro only |

## References

- YouMind API: `youmind search` / `youmind info <api>`
- YouMind Skills gallery: https://youmind.com/skills?utm_source=youmind-deep-research
- Publishing: [shared/PUBLISHING.md](../../shared/PUBLISHING.md)
