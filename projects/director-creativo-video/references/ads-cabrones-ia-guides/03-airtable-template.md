# 03 — Tu base de Airtable

> El skill `ads-cabrones-ia` persiste todos tus proyectos en Airtable: prompts, imágenes generadas, videos, voiceover, scripts. Tienes 3 opciones para armar la base.

## Schema requerido

El skill necesita **2 tablas** específicas:

### Tabla `Project` (1 registro por anuncio)

| Campo | Tipo | Notas |
|---|---|---|
| `Project Name` | Single line text | **PRIMARY** |
| `Status` | Single select | Opciones: `Create`, `In Progress`, `Done`, `Skip` |
| `Core Image` | Attachment | Money shot |
| `Core Elements` | Attachment | Concept board grid |
| `Creative Direction` | Long text | Brief original |
| `music prompt` | Long text | Prompt para Suno/Epidemic |
| `script` | Long text | Voiceover continuo |
| `voice id` | Single line text | ElevenLabs voice_id |
| `music file 1` | Attachment | Música opción A (subes manual) |
| `music file 2` | Attachment | Música opción B (subes manual) |
| `voiceover file` | Attachment | MP3 generado por ElevenLabs |

### Tabla `Scenes` (N registros por proyecto)

| Campo | Tipo | Notas |
|---|---|---|
| `id` | Auto / Formula | UUID interno |
| `Project Name` | Link to Project | Relación |
| `scene` | Single line text | Ej: `Scene 1 - Mirada del Líder` |
| `start_image_prompt` | Long text | YAML del Director |
| `end_image_prompt` | Long text | Cambio respecto a start |
| `transition_prompt` | Long text | Movimiento + acción + SFX |
| `start_image` | Attachment | Output GPT Image 2 |
| `end_image` | Attachment | Output GPT Image 2 |
| `scene_video` | Attachment | Output Seedance 2.0 |
| `prompt done` | Checkbox | Director firmó los prompts |
| `image done` | Checkbox | Imágenes generadas |
| `video done` | Checkbox | Video generado |

---

## Opción A — El wizard te crea la base (Recomendado)

Cuando corras el onboarding del skill por primera vez, en la pregunta 4 elige **"Crear una base nueva limpia"**. El wizard hace todo automáticamente:

1. Te pregunta en qué workspace de Airtable crearla
2. Crea la base + las 2 tablas + los campos correctos
3. Guarda el `base_id` en tu config

✅ **Ventaja**: cero trabajo manual.

---

## Opción B — Crear la base manualmente

Si prefieres tener control total o ya tienes tu workspace organizado:

### B.1 — Crear base nueva

1. Ve a [airtable.com](https://airtable.com), entra a tu workspace
2. Click en **"+ Add a base"** → **"Start from scratch"**
3. Nómbrala como quieras (ej: `Ads Cabrones IA - Mi Marca`)
4. Copia el **baseId** de la URL (formato `appXXXXXXXXXX`)

### B.2 — Tabla Project

1. Renombra la primera tabla a `Project`
2. El campo primary se queda como `Name` por default → renómbralo a `Project Name`
3. Añade los campos de la tabla Project listados arriba (botón `+` al final de los campos)
4. Para `Status` — Single select con opciones: Create, In Progress, Done, Skip

### B.3 — Tabla Scenes

1. Click en `+ Add or import` → **"Create empty table"** → Nómbrala `Scenes`
2. Añade los campos de la tabla Scenes listados arriba
3. Para `Project Name` — usa **Link to another record** y selecciona la tabla `Project`

### B.4 — Configurar el skill

Cuando corras el onboarding, en la pregunta 4 elige **"Usar una base existente"** y pega tu `baseId`. El wizard valida que el schema esté correcto. Si faltan campos, te ofrece crearlos automáticamente.

---

## Opción C — Skip Airtable (local-only)

Si no quieres usar Airtable (por privacy o simplicidad):

1. En el wizard, pregunta 4 → elige **"Skip Airtable"**
2. El skill funciona 100% local. Todos los outputs van a `projects/<slug>/`.
3. Si después quieres subir a Airtable, lo haces manualmente con el script `airtable.sh` que viene incluido.

❌ **Pierdes**: vista organizada de proyectos pasados, búsqueda, colaboración con otros, historial de prompts reutilizables.

---

## Tip: Vistas recomendadas

Después de crear la base, agrega estas vistas para organizar tu trabajo:

### En `Project`
- **Backlog**: filter `{Status} = "Create"`
- **In progress**: filter `{Status} = "In Progress"`
- **Archivo**: filter `{Status} = "Done"`, sort by created date desc

### En `Scenes`
- **Por proyecto**: group by `{Project Name}`, sort by `{scene}`
- **Pendientes de video**: filter `AND({image done}, NOT({video done}))`

---

## Troubleshooting

### "Airtable 422 — Unknown field name X"
Tu base no tiene el campo X. Re-corre el wizard con `--reset` y elige "Crear nueva" o añade el campo manualmente.

### "401 Unauthorized"
Tu PAT no tiene los scopes correctos. Ver [05-guia-airtable-pat.md](05-guia-airtable-pat.md).

### "Base not accessible"
Tu PAT no tiene acceso al workspace de la base. Edita el PAT y agrega el workspace.

---

## Próximo paso

Vuelve al **[README principal](README.md)** o continúa con **[04-guia-higgsfield-mcp.md](04-guia-higgsfield-mcp.md)**.
