# Higgsfield

AI creative studio for cinematic video ads and multi-scene story video. Generates images, animates them into video clips, and produces voice and music — all from a product photo and a creative brief. Used by the `video-ia-higgsfield` skill.

## Capabilities

| Integration | Available | Notes |
|-------------|-----------|-------|
| API | Yes | REST API for Canvas projects, generation, and export |
| MCP | Yes | Official MCP server exposes image, video, voice, music, and post-production tools directly to agents |
| CLI | - | - |
| SDK | - | - |

## Authentication

- **Type**: API Key (for direct API/automation use)
- **Header**: `Authorization: Bearer {api_key}`
- **Get key**: [higgsfield.ai](https://higgsfield.ai) dashboard → API / Developer section
- Store the key in `.env` locally or in your automation platform's credential manager (e.g. n8n Header Auth) — never in chat, code comments, or a public repo.

## MCP Server Setup

Higgsfield provides an MCP server that exposes generation and editing tools directly to an MCP-compatible agent.

1. In the Higgsfield dashboard, open the MCP section and copy the server URL.
2. In your agent (e.g. Claude Code / Claude Desktop): Settings → Connectors → Add custom connector → name it "Higgsfield" and paste the URL.
3. Reconnect / restart the agent session.

Once connected, the MCP server exposes tools for:
- Image generation (`generate_image`) and video animation (`generate_video`)
- Character consistency across scenes (Soul ID, `show_characters`)
- Voice (`create_voice`, dubbing, voice swap) and music (`generate_audio`)
- Post-production (`upscale_image`/`upscale_video`, `reframe`, `remove_background`, `outpaint_image`, `motion_control`)
- Packaged, made-to-brief workflows for ads/explainers/UGC/podcasts (`get_workflow_instructions`)
- Pre-publish QA (`virality_predictor`) and account/credit checks (`balance`, `show_plans_and_credits`)

Every generation is saved automatically to the Assets panel in the Higgsfield dashboard, organized by session.

## API Quick Start (Canvas project pattern)

For headless/scheduled automation outside an interactive agent session, drive a Canvas-style project directly via the API. See [the video-ia-higgsfield skill's n8n-automation reference](../../skills/video-ia-higgsfield/references/n8n-automation.md) for a full Python client and n8n workflow pattern. Confirm current endpoint paths against Higgsfield's live API docs before relying on this in production.

```bash
curl -X POST https://api.higgsfield.ai/v1/canvas/create \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Product Ad - Campaign",
    "format": "9:16",
    "resolution": "1080p",
    "nodes": [ ... ]
  }'
```

## Common Marketing Use Cases

| Use Case | Approach |
|----------|----------|
| Cinematic product ad from a single photo | Creative brief (story, exaggerated attribute, style) → storyboard → generate images/video per scene → voice + music → assemble |
| Seasonal campaign variants | Reuse product references and Soul ID, swap the story per occasion |
| Audience-specific variants | Same product, different story/tone per segment, produced in parallel |
| UGC-style or explainer video | Check `get_workflow_instructions` for a packaged workflow before building manually |
| Multilingual version of an existing ad | `dubbing` / `voice_change` on the finished cut |

## Character Consistency (Soul ID)

Train or select a Soul ID once per recurring character and reuse it across every scene's `generate_image`/`generate_video` call. This keeps the same face and presence consistent without a fresh reference image per shot.

## Pricing

Costs are credit-metered per generation (image, video seconds, resolution). As a reference point, an 8-scene, 1080p cinematic ad with a premium video model runs roughly $20-25; dropping to 720p roughly halves video cost. Check [higgsfield.ai](https://higgsfield.ai) and `show_plans_and_credits` for current rates — they change over time.

## Rate Limits

Generation throughput depends on plan tier and concurrent job limits. Check `balance` and `show_plans_and_credits` before a large multi-scene batch, and budget several minutes for an 8+ scene project to fully generate.

## Relevant Skills

- video-ia-higgsfield
- video
- ad-creative
- social
