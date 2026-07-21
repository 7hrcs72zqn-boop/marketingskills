---
title: Schema Airtable — Ads Cabrones IA
base: appIPJqePWsxuUliB
last_updated: 2026-05-04
---

# Schema Airtable

> Reproducción 1:1 del schema del n8n original. Las dos tablas se relacionan por `Project Name`.

## Tabla 1: `Project` (1 registro por anuncio)

| Campo | Tipo | Notas |
|---|---|---|
| `Project Name` | Single line text | **PRIMARY**, usado para match con Scenes |
| `Status` | Single select | Opciones: `Create`, `In Progress`, `Done` |
| `Core Image` | Attachment | Money shot — la escena que captura la esencia |
| `Core Elements` | Attachment | Concept board (Character/Setting/Product grid) |
| `Creative Direction` | Long text | Brief original del usuario |
| `creative_direction_title` | Single line text | Título generado por el Director |
| `creative_summary` | Long text | Resumen 2-3 oraciones |
| `music prompt` | Long text | Prompt para Suno/Epidemic (referencia) |
| `script` | Long text | Voiceover continuo ~40s |
| `music file 1` | Attachment | Música opción A (subido manual desde Epidemic) |
| `music file 2` | Attachment | Música opción B (subido manual desde Epidemic) |
| `voice id` | Single line text | ElevenLabs voice_id (ej: `iP95p4xoKVk53GoZ742B`) |
| `voiceover file` | Attachment | MP3 generado por ElevenLabs |

## Tabla 2: `Scenes` (N registros por proyecto)

| Campo | Tipo | Notas |
|---|---|---|
| `id` | Single line text | UUID interno (auto) |
| `Project Name` | Link to Project | Relación a la tabla Project |
| `scene` | Single line text | Ej: `Scene 1 - Mirada del Líder` |
| `start_image_prompt` | Long text | YAML estructurado del Director |
| `end_image_prompt` | Long text | Cambio respecto a start |
| `transition_prompt` | Long text | Movimiento de cámara + acción |
| `start_image` | Attachment | Output `nano_banana_2` frame inicial |
| `end_image` | Attachment | Output `nano_banana_2` frame final |
| `scene_video` | Attachment | Output `seedance_2_0` clip 8s |
| `prompt done` | Checkbox | Director firmó los prompts |
| `image done` | Checkbox | Imágenes generadas y aprobadas |
| `video done` | Checkbox | Video generado y aprobado |

## Vistas recomendadas

- **Project / All projects**: tabla completa
- **Project / In Progress**: filter `{Status} != "Done"`
- **Scenes / By project**: group by `{Project Name}`, sort by `{scene}`
- **Scenes / Pending video**: filter `AND({image done}, NOT({video done}))`

## Status flow

```
Create  →  In Progress  →  Done
   ↑          ↑              ↑
 nuevo    director firmó   todos los assets en Airtable
 brief
```
