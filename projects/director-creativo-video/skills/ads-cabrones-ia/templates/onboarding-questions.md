---
title: Onboarding Questions Template
purpose: Cuestionario que el skill ejecuta la primera vez que se invoca en un proyecto/máquina nueva
last_updated: 2026-05-04
---

# Onboarding — Preguntas del Wizard

> Este archivo define las preguntas exactas y cómo procesar las respuestas durante el onboarding del skill `ads-cabrones-ia`. Léelo antes de hacer el wizard.

---

## Objetivo

Capturar en ~2 minutos:
1. Caso de uso del usuario (productos físicos, servicios, personal branding, variedad)
2. Verificación de Higgsfield MCP
3. ElevenLabs API Key (o skip)
4. Airtable PAT + base ID (crear nueva, usar existente, o skip)
5. Voice ID default (si ElevenLabs activado)

Output:
- `.env` (credenciales, permisos 600)
- `.ads-cabrones.config.yaml` (preferencias)
- `.gitignore` (con `.env` añadido si no estaba)

---

## Pregunta 1 — Caso de uso

**Trigger**: bienvenida inicial.

**Mensaje al usuario**:
```
👋 Bienvenido a Ads Cabrones IA de Imperio Digital.

Este sistema genera anuncios cinematográficos completos (4 escenas de 8s + voz)
en ~6 minutos con un costo de ~$3-5 por ad.

Para personalizar el sistema te haré 5 preguntas (~2 minutos).
```

**Tool**: `AskUserQuestion`

```yaml
question: "¿Qué tipo de ads vas a generar principalmente con este sistema?"
header: "Caso de uso"
multiSelect: false
options:
  - label: "Productos físicos"
    description: "Autos, perfumes, fashion, tech, comida, lujo. El Director enfatiza detalle del objeto + lifestyle del consumidor."
  - label: "Servicios o experiencias"
    description: "Turismo, restaurantes, eventos, B2B. El Director enfatiza emoción del cliente + resultado del servicio."
  - label: "Personal branding o creator content"
    description: "El creator ES la marca. Más close-ups del talento, Character Bible muy detallada."
  - label: "Variedad — múltiples casos de uso"
    description: "El brief de cada ad determina el enfoque. Sin defaults preconfigurados."
```

**Procesar**: guardar la respuesta como `use_case` en `.ads-cabrones.config.yaml`.

---

## Pregunta 2 — Higgsfield MCP (verificación, no pregunta)

**Trigger**: después de pregunta 1.

**Llamada**: `mcp__higgsfield__balance`

**Resultados**:
- ✅ Si responde con créditos → mostrar balance al usuario, continuar
- ❌ Si error → 
  ```
  No puedo conectar a Higgsfield MCP. 
  
  Necesitas instalarlo siguiendo: https://higgsfield.ai/mcp
  Después reinicia Claude Code y vuelve a invocar este skill.
  
  Por ahora abortamos el onboarding.
  ```

---

## Pregunta 3 — ElevenLabs API Key

**Mensaje al usuario**:
```
2️⃣ ElevenLabs API Key
   Necesario para generar el voiceover del comercial.
   
   Si no tienes una: crea gratis en https://elevenlabs.io/app/settings/api-keys
   (plan gratuito da 10,000 caracteres/mes — suficiente para ~50 ads)
   
   Pégala aquí o escribe "skip" si prefieres añadir audio manual:
```

**Tool**: input directo (no AskUserQuestion, porque el valor es libre)

**Procesar**:
- Si user pega algo que NO es "skip":
  - Validar: `curl -sS -H "xi-api-key: $KEY" "https://api.elevenlabs.io/v1/voices"` 
  - Si retorna voices → guardar en `.env` como `ELEVENLABS_API_KEY=...`, marcar `voice_enabled: true`
  - Si error 401 → pedir de nuevo
- Si user dice "skip" → marcar `voice_enabled: false` en config

---

## Pregunta 4 — Airtable PAT

**Mensaje al usuario**:
```
3️⃣ Airtable Personal Access Token
   Necesario para guardar tus proyectos, prompts y assets.
   
   Crea uno en: https://airtable.com/create/tokens
   Scopes mínimos:
     ✓ data.records:read, data.records:write
     ✓ schema.bases:read, schema.bases:write
     ✓ Acceso al workspace donde quieres tu base
   
   Pégalo aquí (o "skip" para trabajar local-only):
```

**Procesar**:
- Si user pega algo que NO es "skip":
  - Guardar en `.env` como `AIRTABLE_PAT=...`
  - Continuar a Pregunta 4b
- Si "skip" → marcar `airtable_enabled: false`, saltar 4b, ir a 5

---

## Pregunta 4b — Base Airtable

**Trigger**: solo si Airtable activado.

**Tool**: `AskUserQuestion`

```yaml
question: "¿Tienes una base Airtable existente o creo una nueva?"
header: "Base Airtable"
multiSelect: false
options:
  - label: "Crear una base nueva limpia (Recomendado)"
    description: "Yo creo la base con el schema completo (Project + Scenes con todos los campos). Listo para usar inmediatamente."
  - label: "Usar una base existente"
    description: "Tú me pasas el baseId (ej: appXXX) y yo verifico que tenga el schema correcto. Si faltan campos, te ofrezco añadirlos."
  - label: "Skip Airtable, solo local"
    description: "Trabajo solo en archivos locales. Puedes subir a Airtable manualmente después."
```

**Procesar según opción**:

### "Crear nueva base"
1. Pregunta: "¿En qué workspace creo la base? (te muestro tus workspaces si das un momento)"
2. Listar workspaces: `GET https://api.airtable.com/v0/meta/workspaces`
3. Crear base: `POST https://api.airtable.com/v0/meta/bases` con el schema del template (ver `system/airtable-schema.md`)
4. Guardar `airtable_base_id` en config

### "Usar existente"
1. "Pégame el baseId (formato: appXXXXXXXXXX):"
2. Validar: `airtable.sh schema $base_id`
3. Si schema completo → ✅
4. Si schema incompleto → "Te faltan estos campos: X, Y, Z. ¿Los creo automáticamente?"
5. Guardar `airtable_base_id` en config

### "Skip"
- Marcar `airtable_enabled: false`

---

## Pregunta 5 — Voice ID default

**Trigger**: solo si ElevenLabs activado.

**Mensaje al usuario**:
```
5️⃣ ¿Qué voz quieres usar por default?

Voces multilingual recomendadas (compatibles con español):
```

**Tool**: `AskUserQuestion`

```yaml
question: "¿Cuál voz quieres como default para tus ads?"
header: "Voice default"
multiSelect: false
options:
  - label: "Brian — masculino, deep, narrador cinematográfico ★"
    description: "voice_id: nPczCjzI2devNBz1zQrb. Voz profunda, resonante, comforting. Ideal para narración masculina cinematográfica."
  - label: "Bill — masculino, wise, mature"
    description: "voice_id: pqHfZKP75CvOlQylNhV4. Voz masculina madura, balanceada. Buena para tono institucional."
  - label: "Sarah — femenina, mature, reassuring"
    description: "voice_id: EXAVITQu4vr4xnSDxMaL. Voz femenina cálida y confiable."
  - label: "Daniel — masculino británico, broadcaster"
    description: "voice_id: onwK4e9ZLuTAKqWW03F9. Voz masculina británica, formal."
  - label: "Otra — pego un voice_id de mi library"
    description: "Para voces clonadas o de Voice Library de ElevenLabs."
```

**Si "Otra"**:
- "Pégame el voice_id (formato típico: 20 caracteres alfanuméricos):"
- Capturar input
- Validar: `curl -sS -H "xi-api-key: $KEY" "https://api.elevenlabs.io/v1/voices/$voice_id"` retorna 200
- Guardar como `default_voice_id`

---

## Pregunta 6 — Confirmación final

**Mensaje al usuario** (muestra resumen):
```
✅ Setup completo. Tu configuración:

  Caso de uso:     {use_case}
  Higgsfield MCP:  ✓ {credits} créditos disponibles
  ElevenLabs:      {✓ voz {voice_name} / ⊝ skip}
  Airtable:        {✓ base {base_id} / ⊝ local-only}

Voy a guardar:
  .env                          ← credenciales (permisos 600)
  .ads-cabrones.config.yaml     ← preferencias del skill
  .gitignore                    ← añade .env si no estaba

¿Confirmas?
```

**Tool**: `AskUserQuestion` (sí/no)

**Si confirma** → escribir archivos + mostrar:
```
🎉 Setup terminado!

Para generar tu primer ad:
  1. Prepara: money_shot.png + concept_board.png + brief de creative direction
  2. Invoca el skill diciendo "vamos a hacer un ad" o equivalente

¿Quieres generar tu primer ad ahora? Si sí, dame los 3 inputs.
```

**Si no confirma** → preguntar qué quiere ajustar y volver al paso correspondiente.

---

## Formato del archivo `.ads-cabrones.config.yaml`

```yaml
# Generado por ads-cabrones-ia onboarding
# No editar manualmente — re-correr setup.sh si quieres cambiar
version: 2.0
created_at: "2026-05-04T15:30:00Z"

use_case: "Productos físicos"  # o "Servicios", "Personal branding", "Variedad"

higgsfield:
  enabled: true  # siempre, es el core
  
elevenlabs:
  enabled: true
  default_voice_id: "nPczCjzI2devNBz1zQrb"
  default_voice_name: "Brian"

airtable:
  enabled: true
  base_id: "appXXXXXXXXXXXX"
  project_table: "Project"
  scenes_table: "Scenes"

# Defaults por caso de uso (no editar, lo usa el Director)
director_defaults:
  num_scenes: 4
  aspect_ratio: "16:9"
  resolution_image: "2k"
  resolution_video: "720p"
  quality_image: "high"
  language: "es"
```

---

## Re-correr el onboarding

Si el usuario cambia de cuenta, key o quiere ajustar preferencias:

```
$ ./scripts/setup.sh --reset
```

Esto borra `.ads-cabrones.config.yaml`, hace backup de `.env` actual a `.env.bak`, y re-corre el wizard.
