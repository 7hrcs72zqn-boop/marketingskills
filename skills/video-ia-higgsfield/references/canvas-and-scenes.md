# Canvas, Camera Movements, and Scene Structure

Detailed reference for building multi-scene Higgsfield videos with deliberate camera work and continuity — whether through Higgsfield Canvas directly in the browser, or by scripting the equivalent structure through `generate_image` / `generate_video` calls.

## What Canvas Is

Higgsfield Canvas is a visual board for composing, chaining, and controlling multiple AI-generated clips in one project. Use it (or replicate its structure programmatically) when a video needs more than 1-2 scenes and visual continuity matters.

**Why it matters for direction, not just execution:**
- Keeps visual coherence across scenes instead of each clip looking like a disconnected generation
- Lets you chain clips with an explicit narrative connector rather than hoping cuts line up
- Preserves a character's identity across the whole video via Soul ID
- Lets you iterate on one scene without touching the rest

## Canvas Components

**The board** — a workspace where each node is a clip, a reference image, or a text prompt. Nodes connect with arrows showing narrative flow. Always start with a reference-image node to fix the visual style for the whole project.

**Per-node properties:**
- Text prompt — action, environment, emotion
- Start / end frame image
- Camera movement (see table below)
- Duration — 3 to 10 seconds
- Model (Seedance, Kling, etc.)
- Soul ID — for character consistency

**Scene connectors:**

| Connector | Behavior |
|---|---|
| Simple | One clip follows the next, no continuity guarantee |
| Frame connector (recommended) | The last frame of the previous clip becomes the first frame of the next — smooth visual continuity |
| Character connector | Preserves the subject's visual identity between clips (used with Soul ID) |

## Full Camera Movement Table

| Movement | Effect | Best for |
|---|---|---|
| Dolly In | Smooth approach | Revelation moments |
| Dolly Out | Controlled retreat | Endings, scale reveals |
| Tilt Up | Camera rises | Grandeur, hope |
| Tilt Down | Camera lowers | Reveal, intrigue |
| Pan Left | Horizontal sweep left | Following action |
| Pan Right | Horizontal sweep right | Following action |
| Orbit | Circles the subject | Epic, hero moments |
| Zoom In | Fast approach | Drama, emphasis |
| Zoom Out | Fast retreat | Closing, context |
| Static | No movement | Intimate, dialogue-driven moments |

Camera movement is a large share of a shot's perceived quality — don't leave it as "default" on every scene. Vary it deliberately across the storyboard the way a real DP would: build tension with a slow dolly, punctuate a reveal with a zoom, close on a static hold.

## Scene Schema

Use this structure to script a storyboard — whether you're filling in Canvas nodes by hand, generating scenes one by one through Higgsfield tools, or feeding a workflow/automation pipeline.

```json
{
  "project": "Product Name - Campaign",
  "character": {
    "name": "Ana",
    "description": "Young woman, warm expression, light skin",
    "soul_id": "ana_character_001"
  },
  "scenes": [
    {
      "number": 1,
      "title": "Establishing shot",
      "prompt": "Young woman walking into a modern, sunlit space. Warm overhead lighting, professional environment, cinematic 4K, shallow depth of field.",
      "duration_seconds": 5,
      "camera_movement": "dolly_forward",
      "reference_image_url": "https://.../ref.jpg"
    },
    {
      "number": 2,
      "title": "Detail / proof shot",
      "prompt": "Extreme close-up on the product in use, precise hands, shallow depth of field, warm lighting, detailed 4K, cinematic.",
      "duration_seconds": 6,
      "camera_movement": "tilt_down"
    },
    {
      "number": 3,
      "title": "Payoff",
      "prompt": "Subject reacting with genuine satisfaction, result clearly visible, golden hour lighting, cinematic reveal, emotional, 4K.",
      "duration_seconds": 5,
      "camera_movement": "zoom_out"
    }
  ],
  "video_config": {
    "aspect_ratio": "9:16",
    "resolution": "1080p",
    "total_duration_seconds": 16,
    "visual_style": "cinematic, warm tones"
  },
  "metadata": {
    "target_platform": "Instagram Reels",
    "audience": "Describe the specific audience segment"
  }
}
```

## Prompting Rules for Scene Prompts

- **Minimum 30-40 words per scene prompt.** Short prompts produce generic results.
- **Write in English**, even if the rest of the conversation is in another language — image/video models are meaningfully more precise with English prompts.
- **Always include**: subject, action, environment, lighting, mood, camera framing.
- **Don't request on-screen readable text** — models render it unreliably; add text in post instead.
- **Generate and review in small batches** (2-3 scenes at a time) rather than the whole project at once, so a bad direction gets caught early.

## Visual Style Presets

**Classic cinema:** `35mm film, Kodak color grading, shallow depth of field, vintage color palette`

**Modern urban:** `Cyberpunk lighting, anamorphic lens flare, high contrast, neon accents`

**Natural / documentary:** `Golden hour, handheld camera, natural color palette, organic composition`

**Dramatic:** `Chiaroscuro lighting, slow motion, desaturated tones, cinematic depth`

## Content-Type Presets

**Social (Reels/TikTok):** 9:16, 3-5 nodes of 3-4s each, dynamic movement (pan/zoom/dolly), hook (0-3s) → development (3-10s) → memorable close (10-15s).

**Short film / narrative:** 16:9, 5-10 nodes of 5-8s each, use frame connectors throughout, establishing shot → character → conflict → turn → resolution.

**Product / ad:** Start with the product reference image as the anchor node, 4-6 nodes showing the product in different contexts, prompt style: `product showcase, studio lighting, minimalist background, luxury feel`.

## Common Canvas Errors

| Error | Fix |
|---|---|
| Prompts too short | Write 30-40+ words per clip |
| Jarring visual jumps between scenes | Use frame connectors |
| No Soul ID for a recurring character | Train/select a Soul Character before generating |
| Generating the whole project at once, unreviewed | Generate 2-3 nodes at a time and validate before continuing |
| Ignoring camera movement | Movement is a large share of perceived visual quality — set it deliberately per scene |
| Prompts written in Spanish/other languages | Use English for generation prompts |
| Not budgeting generation time | Multi-scene batches can take several minutes — plan for it |
