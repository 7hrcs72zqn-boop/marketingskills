# Marketing Skills — Agent Guidelines

**Repo**: [coreyhaines31/marketingskills](https://github.com/coreyhaines31/marketingskills) · MIT · Creator: Corey Haines

Agent Skills for AI agents following the [Agent Skills spec](https://agentskills.io/specification.md). Skills install to `.agents/skills/`. Also serves as a **Claude Code plugin marketplace** via `.claude-plugin/marketplace.json`.

## Quick Reference — New Skill Checklist

- [ ] Directory: `skills/your-skill-name/` (lowercase, hyphens only)
- [ ] `name` in frontmatter matches directory name exactly
- [ ] `name`: 1–64 chars, `[a-z0-9-]`, no leading/trailing/consecutive hyphens
- [ ] `description`: 1–1024 chars with trigger phrases and scope boundaries
- [ ] `SKILL.md` under 500 lines (move extras to `references/`)
- [ ] No sensitive data or credentials

## Repository Structure

```
marketingskills/
├── .claude-plugin/
│   └── marketplace.json     # Claude Code plugin marketplace manifest
├── skills/skill-name/
│   ├── SKILL.md             # Required — main instructions (<500 lines)
│   ├── references/          # Optional — detailed docs loaded on demand
│   ├── scripts/             # Optional — executable code
│   └── assets/              # Optional — templates, data files
├── tools/
│   ├── clis/                # 51 zero-dependency Node.js CLI tools (Node 18+)
│   ├── composio/            # Composio integration layer
│   ├── integrations/        # Per-tool API guides
│   └── REGISTRY.md          # Tool index with capabilities
├── CONTRIBUTING.md
└── README.md
```

## Skill Frontmatter

```yaml
---
name: skill-name          # Required. Must match directory name exactly.
description: |            # Required. What it does, when to use it, trigger phrases,
                          # and which related skills handle adjacent tasks.
license: MIT              # Optional. Default: MIT.
metadata:                 # Optional. author, version, etc.
  version: 1.0.0
---
```

**Name rules**: `[a-z0-9]` and hyphens · no leading/trailing/consecutive hyphens · 1–64 chars
**Valid**: `cro`, `ab-testing` · **Invalid**: `Page-CRO`, `-page`, `page--cro`

**Description best practice** — include scope boundaries:

```yaml
description: When the user wants to optimize conversions on any marketing page. Use
  when the user says "CRO," "conversion rate optimization," "this page isn't
  converting." For signup flows, see signup. For post-signup activation, see onboarding.
```

## Writing Style for SKILL.md

- **Structure**: H2 for sections, H3 for subsections · bullet lists over paragraphs · max 2–4 sentences per paragraph
- **Tone**: Second person, direct ("You are a CRO expert") · professional, not corporate
- **Formatting**: `**bold**` for key terms · code blocks for templates · tables for reference data · no excessive emojis
- **Principles**: Clarity over cleverness · specific over vague · active voice · one idea per section
- **Length**: If `SKILL.md` exceeds 500 lines, move reference material to `references/guide.md`

## Claude Code Enhancements (Claude Code only)

These patterns use Claude Code's `` !`command` `` syntax — other agents (Cursor, Windsurf, Codex) see literal text, so keep them out of cross-agent `SKILL.md` files. Apply them in your local `.claude/skills/` overrides.

### Dynamic context injection

Claude Code executes `` !`command` `` inline when loading a skill. The model sees the output, not the instruction — zero extra tool calls.

**Auto-inject product context** (most useful — put at top of skill body):

```markdown
Product context: !`cat .agents/product-marketing.md 2>/dev/null || echo "No product context — ask the user about their product before proceeding."`
```

**Other useful injections:**

```markdown
Today's date: !`date +%Y-%m-%d`
Current branch: !`git branch --show-current 2>/dev/null`
Recent commits: !`git log --oneline -5 2>/dev/null`
```

## Git Workflow

**Branch naming**:
- `feature/skill-name` — new skill
- `fix/skill-name-description` — improvement
- `docs/description` — documentation

**Commit messages** ([Conventional Commits](https://www.conventionalcommits.org/)):

```
feat: add skill-name skill
fix: improve clarity in cro
docs: update README
```

## Verifying Skills and CLI Tools

**Skills** — content only, no build step:

```bash
# Check YAML frontmatter manually:
# - name matches directory
# - name: 1-64 chars, lowercase alphanumeric + hyphens
# - description: 1-1024 chars
```

**CLI tools** (`tools/clis/*.js`) — Node.js 18+, zero dependencies:

```bash
node --check tools/clis/<name>.js          # Syntax check
node tools/clis/<name>.js                  # Show usage (no args = help)
node tools/clis/<name>.js <cmd> --dry-run  # Preview request without sending
```

## Tool Integrations

- **Discovery**: Read `tools/REGISTRY.md` for all tools and capabilities
- **Integration details**: `tools/integrations/{tool}.md` — API endpoints, auth, common operations
- **MCP-native tools**: ga4, stripe, mailchimp, google-ads, resend, zapier, zoominfo, clay, supermetrics, coupler, outreach, crossbeam, introw, composio
- **Composio** (for OAuth-heavy tools without native MCP — HubSpot, Salesforce, Meta Ads, LinkedIn Ads, Google Sheets, Slack, Notion): `tools/integrations/composio.md` for setup · `tools/composio/marketing-tools.md` for toolkit mapping

Skill → tool mapping examples:
| Skill | Relevant tools |
|-------|---------------|
| `analytics` | ga4, mixpanel, segment |
| `emails` | customer-io, mailchimp, resend |
| `ads` | google-ads, meta-ads, linkedin-ads |
| `referrals` | rewardful, tolt, dub-co, mention-me |

## Checking for Updates

**Once per session**, on first skill use:
1. Fetch `VERSIONS.md`: `https://raw.githubusercontent.com/coreyhaines31/marketingskills/main/VERSIONS.md`
2. Compare versions against local skill files
3. Notify **only if meaningful** (≥2 skills outdated OR any major version bump):

```
---
Skills update available: X marketing skills have updates.
Say "update skills" to update automatically, or run `git pull` in your marketingskills folder.
```

**If user says "update skills"**: run `git pull` in the marketingskills directory and confirm what changed.

## Claude Code Plugin

Install via Claude Code's plugin system:

```bash
/plugin marketplace add coreyhaines31/marketingskills
/plugin install marketing-skills
```

See [Claude Code plugins docs](https://code.claude.com/docs/en/plugins.md). Manifest: `.claude-plugin/marketplace.json`.
