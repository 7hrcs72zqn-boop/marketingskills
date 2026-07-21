---
title: Lecciones aprendidas — Bugs, workarounds y decisiones de diseño
project_piloto: El viejo oeste (Ford F150) — 2026-05-04
last_updated: 2026-05-04
---

# Lecciones aprendidas

> Documenta bugs descubiertos, workarounds aplicados y decisiones de diseño durante el desarrollo del skill `ads-cabrones-ia`.

---

## 🐛 Bug 1 — Seedance 2.0 fuerza `generate_audio: true`

**Síntoma**: los videos generados con `seedance_2_0` salen con audio autogenerado (música tipo orquestal cinematográfica) aunque la doc del modelo dice "no generate_audio param".

**Comprobación**: el response del server siempre incluye `"generate_audio": true` en `params`, sin importar si pasamos `generate_audio: false`. El parámetro está oculto y forzado del lado server.

**Impacto**: la música autogenerada **rompe** el voiceover de ElevenLabs si haces concat directo. El audio se mezcla mal con la voz, distrae de la narración, y choca con el feel de la marca.

**Workaround (3 capas)**:

### Capa 1 — Prompt explícito en `transition_prompt`

El system prompt del Director Creativo **OBLIGA** a terminar cada `transition_prompt` con:

```
"Ambient SFX only — [SFX relevantes en inglés] — NO music."
```

Esto guía al modelo a producir SFX en vez de música cinemática. SFX por contexto:

| Contexto | SFX sugeridos |
|---|---|
| Outdoor / paisaje | wind, distant birds, rustling fabric |
| Vehículo | gentle engine rumble, tire-on-dirt, mechanical hums |
| Interior íntimo | subtle room tone, fabric movement, breath |
| Producto físico | material textures (leather creak, glass clink) |
| Tech / industrial | mechanical hums, electronic clicks |
| Comida | subtle kitchen sounds, sizzle, gentle clinks |
| Lujo / fashion | silk rustle, soft footsteps on marble |

### Capa 2 — Mezcla en ffmpeg (paso 8)

Aún con prompt explícito, el SFX nativo puede ser excesivo. Mezclamos a 40% volumen:

```bash
ffmpeg -i video.mp4 -i voiceover.mp3 \
  -filter_complex "[0:a]volume=0.4[sfx];[1:a]volume=1.0[voz];[sfx][voz]amix=inputs=2:duration=longest[out]" \
  -map 0:v -map "[out]" output.mp4
```

### Capa 3 — Fallback: mute total

Si el audio nativo resulta ser claramente música (no SFX) — el prompt no funcionó esta vez:

```bash
ffmpeg -i video.mp4 -i voiceover.mp3 \
  -map 0:v -map 1:a -c:v copy -c:a aac \
  output.mp4
```

### Alternativas para v3 del skill

- **Cambiar a `cinematic_studio_video_v2`** — tiene `sound: bool` declarado oficialmente, respetable
- **Generar SFX cinemáticos aparte** con ElevenLabs Sound Effects API y mezclar con `amix`

---

## 🐛 Bug 2 — Seedance 2.0 flag "sensitive content" con caras humanas reales

**Síntoma**: cuando el `start_image` o `end_image` muestra una cara humana real con detalle alto (close-up frontal nítido), Seedance 2.0 retorna error de "sensitive content" y rechaza generar el video.

**Causa**: sistema de moderación interno de Seedance/Bytedance. Detecta caras y aplica scoring. Caras frontales de alta resolución triggers más fácilmente que perfiles, tres cuartos, o caras semi-ocultas.

**Impacto**: una escena con close-up del rostro queda sin video. Hay que regenerar.

**Workaround (3 capas defensivas)**:

### Capa 1 — Concept board con caras blurred

En el grid `Core Elements` (concept board), las **vistas frontales y close-ups del rostro** deben tener blur ligero (Gaussian 8-15px) o estar en tres cuartos. Detalle en `templates/concept-board.md`.

### Capa 2 — Character Bible exhaustiva

El Director genera una `character_bible` con 5-7 rasgos faciales **muy específicos** (mandíbula, ojos, cejas, nariz, piel, etc.). Esta ficha se prepende a cada `starting_image_prompt`. Resultado: gpt_image_2 puede recrear caras consistentes a partir de la descripción textual sin necesitar fotos reales del talento.

### Capa 3 — Prompts con menos foco facial

Si Seedance flaggea aún así:
1. Regenerar `start_image` con `Composition: wider shot` o `cara semi-oculta por sombrero/objeto`
2. Reintentar el video
3. Si persiste: degradar a `cinematic_studio_video_v2`

### Alternativa para v3 del skill

- **Detectar el flag automáticamente** y regenerar la imagen con el prompt ajustado (sin intervención humana)
- **Usar siempre poses tres-cuartos** para escenas con close-up de rostro

---

## 🐛 Bug 3 — URLs de Airtable expiran al pasar a Higgsfield

**Síntoma**: al pasar URLs de attachments de Airtable como referencias en Higgsfield (`medias[].value`), el server de Higgsfield retorna 404 al intentar fetch.

**Causa**: las URLs de Airtable son firmadas con timestamps cortos. Para Higgsfield, las URLs pasan validación inicial pero al intentar descargar, ya están expiradas.

**Workaround**: subir las imágenes a Higgsfield primero usando `media_upload` para obtener `media_id` estable, luego pasar el `media_id` como `value`.

```python
# 1. Reservar slots
mcp__higgsfield__media_upload(files=[
    {"filename": "money_shot.png", "content_type": "image/png"},
    {"filename": "concept_board.png", "content_type": "image/png"}
])
# → devuelve presigned URLs y media_ids

# 2. Upload bytes via curl PUT a las presigned URLs
curl -X PUT --data-binary @money_shot.png "<presigned_url>"

# 3. Confirmar
mcp__higgsfield__media_confirm(type="image", media_ids=["..."])

# 4. Usar media_id estable en generate_image
generate_image(medias=[{"role": "image", "value": "<media_id>"}])
```

---

## 🐛 Bug 4 — Bash + JSON unicode + comillas

**Síntoma**: shell scripts que pasan JSON con `...` (ellipsis) o emojis al curl/airtable.sh fallan con errores `JSONDecodeError` o `character not in range`.

**Causa**: zsh interpreta caracteres unicode dentro de heredocs y comillas dobles, produciendo escapes raros que llegan corruptos al JSON.

**Workaround**: escribir el JSON con Python a archivo temporal, luego pasar `-d @/tmp/file.json`:

```bash
python3 <<'PYEOF' > /tmp/payload.json
import json
print(json.dumps({"fields": {"script": "Hay quienes... usan IA"}}))
PYEOF

curl -X PATCH -d @/tmp/payload.json https://api.airtable.com/v0/...
```

NO uses inline string interpolation cuando el contenido tenga unicode o quotes.

---

## 🐛 Bug 5 — gpt_image_2 / nano_banana_2 puede romper consistencia entre start y end

**Síntoma**: si el `ending_image_prompt` es muy corto o muy distinto, el end frame puede tener iluminación, pose o environment ligeramente diferente al start, rompiendo la transición.

**Workaround**: siempre añadir al `ending_image_prompt` una frase tipo:

```
"Maintain identical character bible, lighting, and environment from reference."
```

Esto refuerza el chained edit y mantiene consistencia.

---

## 🐛 Bug 6 — gpt_image_2 quality default es "low"

**Síntoma**: si no se pasa `quality`, gpt_image_2 genera con `quality: "low"` que es notablemente inferior para uso cinematográfico.

**Workaround**: siempre pasar `quality: "high"` para escenas finales. `quality: "medium"` para iteración rápida.

```
generate_image(
  model="gpt_image_2",
  quality="high",  # ← obligatorio para output cinematográfico
  resolution="2k",
  ...
)
```

---

## ✅ Lo que funcionó perfecto

1. **gpt_image_2 / nano_banana_2 con 2 refs (money_shot + concept_board)** → consistencia visual excelente desde la primera generación. Personaje + setting + producto fluyen entre escenas.

2. **seedance_2_0 con start_image + end_image** → transiciones naturales. Mejor que veo3.1 first/last frames del n8n original (más control).

3. **ElevenLabs multilingual_v2 con voice_id custom** → calidad pro. Latency baja (~2s para 250 chars).

4. **Pipeline paralelo en Claude Code** → 4 imágenes START + 4 END + 4 videos en paralelo redujo el tiempo total a ~6 minutos end-to-end. El n8n original con waits y switches tomaba 15+ minutos.

5. **Airtable REST API directa con curl** → ~igual de rápida que el MCP oficial pero sin esperar OAuth/restart. Para PATs, batch operations en `records[]` muy eficientes.

6. **Versión CUTS sincronizada con voiceover** → mejor que FULL para finales pulidos. Cortar primeros 3-4s de cada clip elimina las transiciones de salida débiles.

---

## 🆕 Lecciones v2.3 (caso "El Abrigo" — comercial emocional 11 escenas)

### 1. ⏱ Duraciones variables por escena son CLAVE para ritmo + costos

En el caso ATERNA todos los videos eran 8s — eso da ritmo monótono y aumenta costo ~30%. En "El Abrigo" se usaron duraciones de 4-10s según peso narrativo:
- S5 (macro bolsillo) = 4s · simbólico, no necesita más
- S7 (clímax la nota) = 10s · momento más importante, dale tiempo
- S11 (brand reveal) = 5s · cierre limpio

**Implementación v2.3**: cada `scene` en el JSON del Director ahora incluye campo `"duration"` (4-15s). El orquestador pasa esa duración al `generate_video()`.

### 2. 🚫 Seedance flag "ip_detected" en escenas con luto/muerte

Escenas como "oficina vacía del padre fallecido" o que sugieren pérdida pueden trigger el flag `ip_detected` de Seedance. **Re-generar el prompt no siempre lo arregla** (probamos 2 versiones, ambas flaggeadas).

**Workaround v2.3**: ffmpeg fallback usando los STARTs+ENDs como imágenes con `xfade` + `zoompan`:
```bash
ffmpeg -y \
  -loop 1 -t 4 -i scene-N-start.png \
  -loop 1 -t 4 -i scene-N-end.png \
  -filter_complex "
    [0:v]scale=1920:1080,zoompan=z='1.0+0.005*on':d=120:s=1920x1080:fps=30,trim=duration=4[v0];
    [1:v]scale=1920:1080,zoompan=z='1.025+0.005*on':d=90:s=1920x1080:fps=30,trim=duration=4[v1];
    [v0][v1]xfade=transition=fade:duration=1.5:offset=2.5,format=yuv420p[v]
  " \
  -map "[v]" -c:v libx264 -preset slow -crf 18 -t 7 \
  scene-N.mp4
```

Resultado: video de 7s con micro-zoom subtle + crossfade entre las dos imágenes. Resuelve el flag manteniendo la narrativa.

### 3. ⚠️ MCP Higgsfield runtime timeout en uso intenso

Después de ~30 min generando, el MCP de Higgsfield puede caerse en el runtime de Claude Code (server side OK, sólo el binding cliente). Reintentos automáticos NO lo recuperan.

**Workaround**: `Cmd+Q` Claude Code y reabrir. El skill v2.3 genera automáticamente un archivo `RESUME-AFTER-RESTART.md` en el proyecto con todo el contexto técnico (job IDs, prompts pendientes, refs) para retomar exactamente desde donde quedó.

### 4. 🎯 Rate limit Higgsfield Plus/Ultra: 8 jobs concurrentes

El plan tiene un límite duro de 8 jobs concurrentes (videos + imágenes). Para 11+ escenas hay que lanzar en olas de 8.

**Implementación v2.3**: el orquestador detecta error "Rate limit reached" y espera el primer job en completarse antes de lanzar el siguiente.

### 5. 🎬 Fallback de S6 mantenía la narrativa

Aunque el video S6 fue 100% generado con ffmpeg desde imágenes (no con Seedance), en el FULL final no se nota la diferencia. Lección: cuando un modelo de video falla, **un crossfade ffmpeg con micro-zoom de 7s desde las imágenes 2k es indistinguible** en el contexto de un comercial cinematográfico.

### 6. 6-12 escenas según tipo de ad

- **Ad de producto estándar** (auto, perfume): 6 escenas (~36s)
- **Ad emocional storytelling**: 8-12 escenas (~50-70s)
- **Reel corto**: 3-4 escenas (~15-20s)
- **Long-form documental**: 12-15 escenas (~80-100s)

---

## Lección v2.2: CUTS narrativo > random intercalado

**Síntoma del v2.1**: el CUTS intercalado random (`[1, 3, 2, 4, 1, 3, 2, 4, 3, 1, 4, 2]`) producía un ad de 22s que se sentía como **fragmentos sueltos**, sin contar historia. Cuts entre escenas eran rítmicos pero no narrativos.

**Insight**: en cine real, el **arco narrativo manda** sobre el ritmo de cortes. Un ad de 22s necesita inicio (setup) → desarrollo → clímax → resolución, igual que el ad de 32s. La diferencia es que en CUTS los cuts son más rápidos, NO que el orden sea random.

**Solución v2.2** (en SKILL.md paso 10):
- Curva narrativa: cada cut tiene una "posición narrativa" (0 a 1) que determina la escena dominante
- 70% de las veces se elige la escena dominante de esa posición
- 30% de las veces se hace un flashback (escena anterior) o flashforward (siguiente)
- Resultado: un patrón como `[1, 1, 2, 2, 1, 3, 2, 3, 4, 5, 6, 6]` que cuenta la historia mientras corta rápido

**Implicación para el Director Creativo**: las 6 escenas DEBEN formar un arco narrativo identificable, no ser escenas sueltas. Si no, el CUTS narrativo no funciona. La regla está reforzada en `system/director-creativo.md` v2.2.

---

## 🔮 Mejoras planeadas para v2.3+

1. **Onboarding wizard** ✅ implementado en v2.0 (`scripts/setup.sh`)
2. **Character Bible** ✅ implementado en v2.0 (en director-creativo.md)
3. **SFX-first approach** ✅ implementado en v2.0 (transition_prompt obligatorio)
4. **end_image cambio mínimo** ✅ implementado en v2.1 (resuelve transiciones raras)
5. **Música ElevenLabs Music API** ✅ implementado en v2.1
6. **CUTS narrativo** ✅ implementado en v2.2

Pendientes:

7. **Auto-retry de seedance flag** — detectar el error "sensitive content" y regenerar la imagen automáticamente con prompt ajustado
8. **Variantes batch** — generar 2-3 variantes de cada start_image y dejar al usuario elegir antes de continuar al end_image
9. **Sound Effects via ElevenLabs SFX API** — añadir capa SFX cinemática real al MP4 final, mezclada con `amix`
10. **Detección automática de inconsistencias texto-imagen** — comparar concept_board vs creative_direction al inicio (caso "trigo dorado" vs "cañones") y avisar antes de gastar créditos
11. **CUTS inteligente con visión** — analizar cada video con visión y elegir el segmento con más impacto visual de cada clip (en vez de offsets fijos como ahora)

---

## 📊 Métricas del proyecto piloto

```
Proyecto: El viejo oeste (Ford F150)
Inputs:   1 money shot + 1 concept board + brief
Output:   8 imágenes 2k + 4 videos 8s 720p + voiceover 14.5s + 2 MP4 finales
Costo:    160 créditos Higgsfield (~$3.20) + ~$0.05 ElevenLabs = ~$3.25
Tiempo:   ~6 minutos end-to-end
Calidad:  Consistencia personaje/setting/producto excelente.
```
