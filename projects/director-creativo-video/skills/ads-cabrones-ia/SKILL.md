---
name: ads-cabrones-ia
description: Generador One-Shot de anuncios cinematográficos con IA. Toma 3 inputs (money shot + concept board + creative direction) y genera un comercial completo - imágenes con GPT Image 2 quality high a 2k, videos con Seedance 2.0 a 1080p con DURACIONES VARIABLES por escena (4-15s según peso narrativo, no todos iguales), voiceover con ElevenLabs Voice opcional, música con ElevenLabs Music API, edición FULL + CUTS narrativo intercalado con arco emocional, y persistencia en Airtable. 6-8 escenas sugeridas (puede ser hasta 12 para storytelling emocional). Después de generar pregunta al usuario si alguna escena quedó rara. Funciona para CUALQUIER caso de uso (autos, perfumes, fashion, tech, lujo, comida, servicios, personal branding, brutalist, surreal, pastel, storytelling emocional, etc) — NO replica estética de proyectos previos. Triggers, "ads cabrones", "anuncio cinematográfico", "comercial con IA", "ad para [marca/producto]", "vamos a hacer un ad", "vamos a hacer un comercial", o cuando un proyecto en Airtable tenga Status=Create. La primera vez ejecuta onboarding wizard para capturar credenciales y configurar Airtable.
version: 2.3
last_updated: 2026-05-04
---

# Ads Cabrones IA — Skill agnóstico de marca v2.1

Pipeline: Concept Board → Director Creativo → GPT Image 2 (high) → Seedance 2.0 (1080p pro) → ElevenLabs Voice → ElevenLabs Music → ffmpeg FULL + CUTS intercalado → Airtable. **Una sola aprobación al inicio**, después corre todo.

> Skill **agnóstico de caso de uso y de estética**. NO replica el look de proyectos previos. Cada brief manda su propia vibra (autos, perfumes, fashion, tech, lujo, comida, servicios, brutalist, surreal, minimalista, etc).

---

## 🎯 Cambios v2.3 (vs v2.0)

1. **Default 6-8 escenas** (no fijo 4) — más narrativa + mejor material para CUTS narrativo. Ad estándar 6 escenas, storytelling emocional 8-12.
2. **⏱ DURACIONES VARIABLES POR ESCENA** ✨ v2.3 — cada video tiene su propia duración (4-15s) según peso narrativo. NO todos a 8s. Ahorra costos + mejora ritmo. Ver tabla de guía abajo.
3. **`ending_image_prompt` debe ser cambio MÍNIMO** sobre start (no shot distinto) → resuelve transiciones raras de seedance
4. **Videos a 1080p (mode std)** — calidad máxima soportada por seedance_2_0. `mode: "pro"` no existe (solo std/fast).
5. **Música ElevenLabs Music API integrada** (`music_v1`, ~30-90s con prompt del Director)
6. **CUTS con arco narrativo** — los cuts respetan la progresión de la historia (escena 1 al inicio, escena N al final) con flashbacks/flashforwards. NO random.
7. **Director escribe escenas como ARCO NARRATIVO claro** — Setup → Develop → Climax → Resolution.
8. **Pregunta final**: ¿alguna escena quedó rara? regeneramos
9. **Director desanclado** de la estética "premium aspiracional"
10. **ffmpeg fallback para escenas flag-eadas por Seedance** (ip_detected) — generar video desde STARTs+ENDs con `xfade` + `zoompan` en vez de re-intentar.
11. **Tolerancia a MCP timeout** — el runtime de Higgsfield puede caerse después de uso intenso. Solución: cerrar y reabrir Claude Code, retomar desde el archivo `RESUME-AFTER-RESTART.md` que el skill genera automáticamente.

---

## ⏱ GUÍA DE DURACIONES POR ESCENA — v2.3

> **Clave**: cada `generate_video()` acepta `duration` entre 4-15 segundos. NO uses 8s para todo. Adapta según peso narrativo. Esto **mejora el ritmo** del ad final y **reduce costos** (un video de 5s cuesta ~30% menos que uno de 8s).

### Tabla de duraciones recomendadas por tipo de escena

| Tipo de escena | Duración | Cuándo usar |
|---|---|---|
| **Setup / hook inicial** | 5-6s | Establece atmósfera. Suficiente para que el ojo aterrice. |
| **Inmersión / mood** | 4-5s | Momentos de soledad o atmósfera. No necesitan más. |
| **Desarrollo / paso del tiempo** | 5-6s | Avanza la narrativa pero sin pausa. |
| **Detalle íntimo / macro** | 4-5s | Foco corto, simbólico. |
| **Pivote dramático** | 6-7s | Necesita peso emocional, espacio para que el espectador procese. |
| **Climax emocional** | 8-10s | Es el momento más importante. Dale tiempo. |
| **Resolución / acto deliberado** | 6-8s | Acción narrativa significativa (quitar abrigo, abrazo, etc.) |
| **Hero shot final** | 7-8s | Culminación visual cálida. |
| **Brand reveal / logo fade-in** | 5s | Tipografía + cierre. Más es overstay. |

### Ejemplo: ad de 6 escenas (~36s total)

```
S1 setup hook        : 5s
S2 inmersión         : 5s
S3 desarrollo        : 5s
S4 climax            : 8s   ← más largo, momento clave
S5 resolución        : 7s
S6 brand reveal      : 5s
                       ───
                       35s total · ~$3.50 (vs $4.80 si todos 8s)
```

### Ejemplo: ad emocional de 11 escenas (~68s total) — caso "El Abrigo"

```
S1 La nota               : 6s
S2 La ventana            : 5s
S3 Cumpleaños tarde      : 5s
S4 Graduación            : 6s
S5 Bolsillo macro        : 4s   ← detalle simbólico, corto
S6 Oficina vacía         : 7s   ← peso del momento
S7 La nota encontrada    : 10s  ← climax emocional, máximo
S8 Regreso a casa        : 5s
S9 Quitar el abrigo      : 7s   ← acto ritual deliberado
S10 Hero shot juego      : 8s   ← culminación cálida
S11 Brand reveal         : 5s
                          ───
                          68s total · ~$11 (vs $13 si todos 8s)
```

### Implementación en el pipeline

Cuando el Director Creativo genere el JSON, debe incluir una key `duration` por escena:

```json
{
  "scene": "Scene 1 - El Hook",
  "duration": 6,
  "starting_image_prompt": "...",
  "ending_image_prompt": "...",
  "transition_prompt": "..."
}
```

Y el orquestador en Round D pasa la duración al `generate_video()`:

```python
generate_video(
  model="seedance_2_0",
  prompt=scene["transition_prompt"],
  duration=scene["duration"],  # ← variable, NO hardcoded 8
  resolution="1080p",
  mode="std",
  medias=[...]
)
```

> **Default si el Director no especifica `duration`**: 6s (mejor ratio costo/ritmo que 8s).

---

## 🚪 Fase 0 — Onboarding (PRIMERA EJECUCIÓN)

> Idéntico a v2.0. Wizard de 5 preguntas, ~2 minutos. Detalle en `templates/onboarding-questions.md` y `scripts/setup.sh`.

Detección automática:
```bash
[[ -f ".env" ]] && grep -q "^ELEVENLABS_API_KEY=" .env && grep -q "^AIRTABLE_PAT=" .env \
  && [[ -f ".ads-cabrones.config.yaml" ]] \
  && echo "✅ Setup OK" || echo "🚪 Onboarding requerido"
```

Si falta cualquier pieza → wizard obligatorio antes de continuar.

---

## Inputs (al generar un ad)

```yaml
project_name: string
core_image: path|url                  # Money shot
core_elements: path|url               # Concept board grid Personaje/Entorno/Producto
creative_direction: string            # Brief libre
voice_id: string (opcional, override del default)
num_scenes: int (opcional, default 6)
mode: "auto"|"approval" (opcional, default approval)
generate_music: bool (opcional, default true)
```

---

## Pipeline (12 pasos)

### Paso 1 — Setup

```
- Cargar .env y .ads-cabrones.config.yaml
- Verificar mcp__higgsfield__balance > 300 créditos (mínimo para 1 ad de 6 escenas a 1080p)
- Verificar ffmpeg: which ffmpeg || brew install ffmpeg
- Slug del proyecto: kebab-case del project_name
- Crear estructura: projects/<slug>/{inputs,creative,images,videos,voice,music,output}
- Si inputs vienen de Airtable: descargar Core Image + Core Elements
```

### Paso 2 — Director Creativo

Lee `system/director-creativo.md` como system prompt. **Genera 6 escenas por default**, cada una con:
- `starting_image_prompt` (YAML estructurado)
- `ending_image_prompt` con **cambio mínimo** (1-2 segundos de movimiento, NO shot distinto)
- `transition_prompt` con movimiento sutil + `"Ambient SFX only — [SFX] — NO music"`

**Crítico**: la regla del end_image mínimo está en `system/director-creativo.md`. Si el Director propone end_images con shots distintos, el orquestador del skill debe rechazar y pedir reescribir esa escena.

### Paso 3 — Aprobación (única, modo approval)

Mostrar al usuario:
```
🎬 [creative_direction_title]
[creative_summary]

👤 Character Bible: [resumen]
🎵 Music prompt: [music_prompt completo]
🎙 Script (~Ns): [script]

📋 6 Escenas:
   1. [scene] | START → END (cambio mínimo) | TRANS
   ...

💰 Costo estimado: ~$5-8 (1080p pro + 6 escenas + música)
```

`AskUserQuestion`: aprobar / generar 1 escena de prueba / ajustar / cancelar.

### Paso 4 — Subir refs a Higgsfield

`media_upload` + curl PUT + `media_confirm`. Mismo flow que v2.0.

### Paso 5 — Generación de imágenes (paralelo, 12 calls = 6 START + 6 END)

**Modelo**: `gpt_image_2` con `quality: "high"` y `resolution: "2k"`.

#### Round 5a — 6 imágenes START (paralelo)

```
generate_image(
  model="gpt_image_2",
  prompt=<character_bible> + "\n\n" + scene.starting_image_prompt,
  aspect_ratio="16:9",
  resolution="2k",
  quality="high",
  medias=[refs según escena]
)
```

#### Round 5b — 6 imágenes END (paralelo, chained)

```
generate_image(
  model="gpt_image_2",
  prompt=scene.ending_image_prompt + " Maintain identical character bible, lighting, environment, and composition from reference. Subtle micro-change only.",
  aspect_ratio="16:9",
  resolution="2k",
  quality="high",
  medias=[{role:"image", value: <start_image_job_id>}]
)
```

### Paso 6 — Generación de videos (paralelo, máx 8 concurrent)

**Modelo**: `seedance_2_0` con **`resolution: "1080p"` y `mode: "std"`** (calidad máxima soportada).

⚠️ **Rate limit Higgsfield Plus/Ultra**: máximo 8 jobs concurrentes. Si tienes 11+ escenas, lanza en olas de 8.

⏱ **DURACIÓN VARIABLE POR ESCENA** (v2.3) — usa la `duration` que el Director asigna a cada scene en su JSON, NO hardcodea 8s:

```
generate_video(
  model="seedance_2_0",
  prompt=scene.transition_prompt,
  duration=scene.duration,  # ← VARIABLE (4-15s según peso narrativo)
  aspect_ratio="16:9",
  resolution="1080p",
  mode="std",
  medias=[
    {role:"start_image", value: <start_job_id>},
    {role:"end_image",   value: <end_job_id>}
  ]
)
```

Ver tabla "Duraciones por escena" arriba para guía. Default si Director no especifica: 6s.

> 1080p tarda 2-3 min por video y cuesta ~30% más vs 720p. Para "modo pro" real usar `kling3_0` (no testeado).

### Paso 7 — Voiceover (ElevenLabs Voice)

```bash
./scripts/elevenlabs_voice.sh "$voice_id" "$script" "voice/voiceover.mp3"
```

### Paso 8 — Música (ElevenLabs Music API) ✨ NUEVO

```bash
# Calcular duración total en ms (num_scenes × 8s × 1000)
TOTAL_MS=$(echo "${NUM_SCENES} * 8000" | bc)

./scripts/elevenlabs_music.sh "$music_prompt" "music/soundtrack.mp3" $TOTAL_MS
```

El endpoint `https://api.elevenlabs.io/v1/music` (modelo `music_v1`) toma el `music_prompt` del Director y devuelve un MP3 con la música cinemática. Soporta hasta 600 segundos.

> ⚠️ Si el usuario tiene `voice_enabled: false` en config, skipear este paso. Si quiere música pero no se pudo, marcar como TODO en el reporte final.

### Paso 9 — Edición FULL (videos completos + voz + música + SFX nativo)

```bash
# Concat sin re-encode
cat > /tmp/concat_full.txt <<EOF
file '$(pwd)/videos/scene-1.mp4'
file '$(pwd)/videos/scene-2.mp4'
... (las 6)
EOF
ffmpeg -y -f concat -safe 0 -i /tmp/concat_full.txt -c copy /tmp/full_concat.mp4

TOTAL_DUR=$(ffprobe -v error -show_entries format=duration -of default=nk=1:nw=1 /tmp/full_concat.mp4)

# Mezcla 4 streams: SFX nativo (0.3) + voiceover (1.0) + música (0.5) (música algo más alta porque sostiene el arco)
ffmpeg -y -i /tmp/full_concat.mp4 -i voice/voiceover.mp3 -i music/soundtrack.mp3 \
  -filter_complex "
    [0:a]volume=0.3[sfx];
    [1:a]apad=whole_dur=${TOTAL_DUR},volume=1.0[voz];
    [2:a]apad=whole_dur=${TOTAL_DUR},volume=0.5[mus];
    [sfx][voz][mus]amix=inputs=3:duration=longest:dropout_transition=0[out]
  " \
  -map 0:v -map "[out]" \
  -c:v copy -c:a aac -b:a 192k \
  output/<slug>-FULL.mp4
```

> Si `generate_music: false`: mezcla solo SFX + voz (mismo filter sin la rama [2]).

### Paso 10 — Edición CUTS con arco narrativo ✨ v2.2

> **Cambio v2.2**: el CUTS NO es intercalado random — es un **arco narrativo con cortes rítmicos**. Las escenas se ordenan respetando la progresión de la historia (Scene 1 al inicio, Scene N al final), pero con micro-flashforwards/flashbacks que mantienen ritmo dinámico.

**Principio**: las 6 escenas del Director ya forman un arco (setup → develop → climax → resolution). La versión CUTS debe **respetar ese arco** mientras corta más rápido que el FULL.

**Patrón narrativo recomendado** para 6 escenas en 12 cuts:

```
Fase 1 (setup):     [1, 1, 2]              ← escena 1 domina, primera mirada de escena 2
Fase 2 (develop):   [2, 1, 3, 2]           ← escena 2 dominante, recuerda 1, presenta 3
Fase 3 (climax):    [3, 4, 5]              ← clímax visual con escena del producto
Fase 4 (resolution): [4, 6, 6]             ← cierre con escena hero final

Resultado: [1, 1, 2, 2, 1, 3, 2, 3, 4, 5, 6, 6]
```

Características clave:
- Cada escena domina su fase narrativa (donde le toca contar la historia)
- **Flashbacks cortos** (volver brevemente a una escena anterior) crean ritmo + nostalgia
- **Flashforwards** (peek de escena futura antes de tiempo) crean anticipación
- Última escena se repite al final para cerrar fuerte
- NUNCA dos cuts consecutivos de la misma escena son redundantes (use offset distinto del clip original)

**Algoritmo Python — versión narrativa**:

```python
def build_narrative_pattern(num_scenes, num_cuts):
    """
    Genera un patrón que sigue el arco narrativo: scene 1 al inicio, scene N al final.
    Con micro-flashbacks/flashforwards para ritmo dinámico.
    """
    # Curva narrativa: escena dominante en cada momento
    # Posición narrativa de cada cut (0 a 1)
    positions = [i / (num_cuts - 1) for i in range(num_cuts)]
    
    pattern = []
    for pos in positions:
        # Escena dominante en esta posición narrativa
        dominant = round(pos * (num_scenes - 1)) + 1  # 1..num_scenes
        
        # Aleatoriedad narrativa: 70% escena dominante, 30% flashback/flashforward
        import random
        if random.random() < 0.3:
            # Flashback (escena anterior) o flashforward (siguiente) con peso al pasado
            offset = random.choice([-1, -1, +1]) if random.random() < 0.7 else random.choice([-2, +1])
            scene = max(1, min(num_scenes, dominant + offset))
        else:
            scene = dominant
        
        # Evitar 3 cuts consecutivos iguales
        if len(pattern) >= 2 and pattern[-1] == scene and pattern[-2] == scene:
            scene = max(1, min(num_scenes, scene + (1 if scene < num_scenes else -1)))
        
        pattern.append(scene)
    
    return pattern

# Para 6 escenas y 12 cuts, ejemplo de output:
# [1, 1, 2, 2, 1, 3, 3, 4, 4, 5, 6, 6]
# o con más random: [1, 2, 1, 3, 2, 3, 4, 3, 5, 4, 6, 6]
```

> Para reproducibilidad usa `random.seed(<hash del project_name>)` para que el mismo proyecto siempre genere el mismo patrón.

**Para 4 escenas (ad corto, fallback)**:
```
Pattern: [1, 1, 2, 1, 2, 3, 2, 3, 4, 3, 4, 4]
```

```bash
# Por cada cut, extraer el fragmento desde un punto aleatorio del clip original
for idx in 1..NUM_CUTS; do
  scene=${pattern[$idx]}
  # Punto de inicio aleatorio entre 0.5s y (8 - cut_dur - 0.5s)
  start=$(python3 -c "import random; print(round(random.uniform(0.5, 8 - $cut_dur - 0.5), 2))")
  ffmpeg -y -ss $start -t $cut_dur -i videos/scene-$scene.mp4 \
    -c:v libx264 -preset slow -crf 16 \
    -c:a aac -b:a 128k -filter:a "volume=0.3" \
    /tmp/cut-$idx.mp4
done

# Concat los 12 cuts
cat > /tmp/concat_cuts.txt <<EOF
$(for i in $(seq 1 12); do echo "file '/tmp/cut-$i.mp4'"; done)
EOF
ffmpeg -y -f concat -safe 0 -i /tmp/concat_cuts.txt -c copy /tmp/cuts_concat.mp4

# Mezclar con voiceover + música
ffmpeg -y -i /tmp/cuts_concat.mp4 -i voice/voiceover.mp3 -i music/soundtrack.mp3 \
  -filter_complex "
    [0:a]volume=0.3[sfx];
    [1:a]volume=1.0[voz];
    [2:a]volume=0.5[mus];
    [sfx][voz][mus]amix=inputs=3:duration=longest[out]
  " \
  -map 0:v -map "[out]" -c:v copy -c:a aac -b:a 192k \
  output/<slug>-CUTS.mp4
```

> **Resultado**: ad de ~Vs con ritmo dinámico, intercalando fragmentos de las 6 escenas. Mucho más cercano al feel de un comercial real editado en post.

### Paso 11 — Persistir en Airtable

Mismo flow que v2.0 pero ahora con 6 scenes records + adjuntar también `music file 1` con la música generada.

### Paso 12 — Reporte final + pregunta de regeneración ✨ NUEVO

Mostrar:
```
✅ Ad "<project_name>" generado

📁 Local: projects/<slug>/
├── creative/direction.json
├── images/  (12 imágenes 2k)
├── videos/  (6 clips de 8s a 1080p pro)
├── voice/voiceover.mp3
├── music/soundtrack.mp3   ← ✨ generada con ElevenLabs Music
└── output/
    ├── <slug>-FULL.mp4    (~48s, 6 clips completos + voz + música + SFX)
    └── <slug>-CUTS.mp4    (~Vs, intercalado dinámico de fragmentos)

☁️ Airtable: ...

💰 Costo: ~$X.XX
```

Después, **AskUserQuestion**:
```
"¿Alguna escena quedó rara y quieres que la regeneremos?"
opciones:
  - "No, todo bien — terminamos"
  - "Escena 1 — regenerar imagen + video"
  - "Escena 2 — regenerar imagen + video"
  - "Escena 3 — regenerar imagen + video"
  - "Escena 4 — regenerar imagen + video"
  - "Escena 5 — regenerar imagen + video"
  - "Escena 6 — regenerar imagen + video"
  - "Varias escenas — te digo cuáles"
  - "Otra cosa (ajustar prompt, cambiar voz, etc.)"
```

Si elige regenerar:
1. Pedir al usuario qué cambiar exactamente (más wide, menos close, otro ángulo, etc.)
2. Ajustar el `starting_image_prompt` y/o `ending_image_prompt` y/o `transition_prompt`
3. Re-correr Pasos 5+6 SOLO para esa escena
4. Re-correr Paso 9+10 (FULL + CUTS) con la escena nueva
5. Update Airtable
6. Volver a preguntar (loop hasta que el usuario diga "todo bien")

---

## Costos por anuncio (6 escenas, 16:9 1080p pro)

| Recurso | Cantidad | Costo aprox |
|---|---|---|
| Imágenes gpt_image_2 quality=high 2k | 12 | ~120 créditos |
| Videos seedance_2_0 1080p pro 8s | 6 | ~210 créditos |
| Voiceover ElevenLabs (~300 chars) | 1 | ~$0.06 |
| Música ElevenLabs Music (~48s) | 1 | ~$0.10 |
| **Total** | | **~$7-8** |

> Higgsfield Plus (~600 créditos/mes) cubre ~2 ads completos. Para producción regular considerar plan superior.

---

## Errores recuperables

| Error | Recovery |
|---|---|
| Higgsfield 404 fetch ref | media_upload primero |
| Higgsfield rate limit | wait 60s, reintenta |
| Imagen falla | regenerar solo esa escena |
| Video falla | regenerar; si persiste, fallback a `cinematic_studio_video_v2` |
| **Seedance flag "sensitive"** | regenerar start_image con menos foco facial |
| **Transición rara seedance** | regenerar end_image con prompt MÁS sutil (cambio mínimo) |
| ElevenLabs 401 | rotar API key |
| ElevenLabs Music falla | continuar sin música, marcar TODO en reporte |
| Airtable 422 | check schema |

---

## Bugs conocidos (referencia rápida)

1. **seedance_2_0 fuerza generate_audio: true** → SFX-only en prompt + mezcla 30% en ffmpeg
2. **seedance_2_0 flag "sensitive content"** → Character Bible + concept_board con caras blurred
3. **Transiciones raras de seedance** → end_image debe ser **cambio MÍNIMO**, no shot distinto (regla v2.1 en director)
4. **URLs Airtable expiran al fetch en Higgsfield** → media_upload primero
5. **Bash + JSON unicode** → escribir JSON a archivo temporal con Python, NUNCA inline string interpolation con caracteres especiales

Detalle en `references/lecciones-aprendidas.md`.

---

## Archivos del skill

```
~/.claude/skills/ads-cabrones-ia/
├── SKILL.md                              ← este archivo
├── system/
│   ├── director-creativo.md              ← v2.1 con regla end_image mínimo + 6 escenas + sin anclar estética
│   └── airtable-schema.md
├── templates/
│   ├── concept-board.md
│   ├── creative-direction.md
│   └── onboarding-questions.md
├── scripts/
│   ├── setup.sh                          ← wizard onboarding
│   ├── airtable.sh                       ← REST wrapper
│   ├── elevenlabs_voice.sh
│   └── elevenlabs_music.sh               ← ElevenLabs Music API (música cinemática)
└── references/
    └── lecciones-aprendidas.md           ← bugs + workarounds + lección end_image
```
