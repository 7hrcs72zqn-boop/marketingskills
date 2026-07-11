# Headless Automation: Python + n8n

For scaled or scheduled production — e.g. a script-writing agent that triggers a new Higgsfield video daily/weekly without a live chat session — drive Higgsfield from the API directly instead of an interactive MCP session.

**Security first:** never paste an API key into a chat, prompt, or public repo. Store it in a local `.env` file (Python) or in n8n's Credentials manager (Header Auth) — never in plain text in a workflow node or commit history. If a key is ever pasted somewhere insecure, revoke it in the Higgsfield dashboard and generate a new one before continuing.

## Python Client Pattern

```bash
pip install requests python-dotenv
```

`.env`:
```bash
HIGGSFIELD_API_KEY=your_key_here
```

`higgsfield_client.py`:

```python
import requests
import json
import os
import time
from typing import Dict

class HiggsfieldClient:
    def __init__(self, api_key: str):
        self.api_key = api_key
        self.base_url = "https://api.higgsfield.ai/v1"
        self.headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json",
        }

    def create_project(self, script: Dict) -> Dict:
        """Create a Canvas-style project from a structured scene script."""
        payload = {
            "name": script["project"],
            "format": script["video_config"]["aspect_ratio"],
            "resolution": script["video_config"]["resolution"],
            "nodes": [],
        }

        first_scene = script["scenes"][0]
        payload["nodes"].append({
            "type": "reference_image",
            "name": "Initial Visual Reference",
            "prompt": first_scene["prompt"],
            "duration": first_scene["duration_seconds"],
            "camera_movement": first_scene["camera_movement"],
            "soul_id": script["character"].get("soul_id"),
            **({"image_url": first_scene["reference_image_url"]}
               if first_scene.get("reference_image_url") else {}),
        })

        for i, scene in enumerate(script["scenes"][1:], 1):
            node = {
                "type": "video_clip",
                "name": f"Scene {scene['number']}",
                "prompt": scene["prompt"],
                "duration": scene["duration_seconds"],
                "camera_movement": scene["camera_movement"],
                "soul_id": script["character"].get("soul_id"),
                "previous_connector": {"node_id": i - 1, "type": "frame_connector"},
            }
            if scene.get("reference_image_url"):
                node["start_image_url"] = scene["reference_image_url"]
            payload["nodes"].append(node)

        response = requests.post(f"{self.base_url}/canvas/create", json=payload, headers=self.headers)
        return response.json() if response.status_code == 201 else {"error": response.text, "status_code": response.status_code}

    def generate_all(self, project_id: str) -> Dict:
        response = requests.post(f"{self.base_url}/canvas/{project_id}/generate-all", headers=self.headers)
        return response.json() if response.status_code == 200 else {"error": response.text}

    def get_status(self, project_id: str) -> Dict:
        response = requests.get(f"{self.base_url}/canvas/{project_id}/status", headers=self.headers)
        return response.json() if response.status_code == 200 else {"error": response.text}

    def export_video(self, project_id: str, resolution: str = "1080p") -> Dict:
        payload = {"resolution": resolution, "output_format": "mp4"}
        response = requests.post(f"{self.base_url}/canvas/{project_id}/export", json=payload, headers=self.headers)
        return response.json() if response.status_code == 200 else {"error": response.text}

    def run(self, script: Dict, timeout_seconds: int = 300) -> Dict:
        project = self.create_project(script)
        if "error" in project:
            return project
        project_id = project.get("canvas_id")

        self.generate_all(project_id)

        started = time.time()
        while time.time() - started < timeout_seconds:
            status = self.get_status(project_id)
            if status.get("status") == "completed":
                break
            time.sleep(5)

        return self.export_video(project_id, script["video_config"].get("resolution", "1080p"))


if __name__ == "__main__":
    api_key = os.getenv("HIGGSFIELD_API_KEY")
    with open("script.json") as f:
        script = json.load(f)
    client = HiggsfieldClient(api_key)
    result = client.run(script)
    print(json.dumps(result, indent=2))
```

Confirm current endpoint paths and payload shape against Higgsfield's live API docs before relying on this in production — treat the client above as a pattern to adapt, not a guaranteed-current contract.

## n8n Workflow Outline

```
Trigger (Manual / Cron)
    ↓
Scriptwriting agent → generates the scene JSON (see scene schema reference)
    ↓
Code node (JavaScript) → validate + build Canvas API payload
    ↓
HTTP Request → POST /canvas/create
    ↓
Wait
    ↓
HTTP Request → POST /canvas/{id}/generate-all
    ↓
Loop + Wait → poll /canvas/{id}/status until completed (cap the retry window)
    ↓
HTTP Request → POST /canvas/{id}/export
    ↓
Notify (Notion, Slack, Telegram, etc.) with the result
```

**Credentials in n8n:**
- Higgsfield: Settings → Credentials → New → Header Auth → `Authorization: Bearer YOUR_KEY`
- Never hardcode the key inside a Code or HTTP Request node — always reference the Credential.

## Validation Node (JavaScript)

```javascript
const script = JSON.parse($input.first().json.script);

if (!script.scenes || script.scenes.length < 3) {
  throw new Error("Script must have at least 3 scenes");
}

const payload = {
  name: script.project,
  format: script.video_config.aspect_ratio,
  resolution: script.video_config.resolution,
  nodes: [],
};

const firstNode = {
  type: "reference_image",
  name: "Initial Visual Reference",
  prompt: script.scenes[0].prompt,
  duration: script.scenes[0].duration_seconds,
  camera_movement: script.scenes[0].camera_movement,
  soul_id: script.character.soul_id,
};
if (script.scenes[0].reference_image_url) {
  firstNode.image_url = script.scenes[0].reference_image_url;
}
payload.nodes.push(firstNode);

script.scenes.slice(1).forEach((scene, index) => {
  const node = {
    type: "video_clip",
    name: `Scene ${scene.number}`,
    prompt: scene.prompt,
    duration: scene.duration_seconds,
    camera_movement: scene.camera_movement,
    soul_id: script.character.soul_id,
    previous_connector: { node_id: index, type: "frame_connector" },
  };
  if (scene.reference_image_url) {
    node.start_image_url = scene.reference_image_url;
  }
  payload.nodes.push(node);
});

return { payload };
```

## When to Use This vs. an Interactive Agent Session

| Situation | Approach |
|---|---|
| One-off ad, creative direction still being worked out | Interactive agent session (MCP tools), so you can review and steer scene by scene |
| Recurring, scheduled video (e.g. weekly seasonal variant) with a settled creative template | n8n/API automation |
| Need to trigger video generation from another system (CMS, CRM event, form submission) | n8n/API automation |
| High-stakes hero ad where every scene needs review | Interactive agent session |
