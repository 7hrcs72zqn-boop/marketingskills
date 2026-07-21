# 07 — Caso de estudio: "El viejo oeste" (Ford F150)

> Primer ad generado end-to-end con el sistema `ads-cabrones-ia` v2. Documenta el proceso completo, decisiones del Director, costos reales y resultados.

---

## El brief

```
Project: El viejo oeste
Marca: Ford F150
Target: Hombre 40 años, redneck con estilo, masculino y elegante
Setting: Wild West americano, desierto al atardecer
Tono: Contemplativo, masculino, "no necesito demostrar nada"
Tagline: "Hecha para liderar el camino"
```

## Inputs (los 3 archivos)

### Money shot
Una imagen wide del hombre apoyado en su F150 en un mirador rocoso al atardecer. Cañones del oeste americano de fondo. Generada previamente con Gemini.

### Concept board
Grid 16:9 con:
- **Personaje**: hombre rugged con sombrero vaquero (5 vistas)
- **Setting**: desierto del oeste, mesetas rocosas, caminos de tierra
- **Producto**: F150 gris oscura desde varios ángulos

> **Nota**: este concept board fue generado SIN blur en las caras — más adelante el sistema sí evitó el flag de Seedance gracias a la Character Bible (ver más abajo).

### Creative direction (texto)
Brief libre de ~500 palabras describiendo el universo "Heartland americano" con foco en la masculinidad madura.

## Lo que hizo el Director Creativo

Generó este JSON estructurado:

```yaml
creative_direction_title: "Dominio Dorado: El Nuevo Estándar"
creative_summary: "Una oda visual a la masculinidad madura..."
music_prompt: "Americana moderno cinematográfico..." # 333 chars
script: "Hay quienes miden el éxito en cifras... nosotros lo medimos en lo que somos capaces de construir... Porque el estilo no es un disfraz. Es una actitud... Nueva F150, hecha para liderar el camino." # 194 chars

character_bible:
  age_range: "40-45"
  build: "Athletic, weathered, broad-shouldered"
  face_features:
    - "Prominent square jaw with thick salt-and-pepper beard"
    - "Deep-set blue-grey eyes with strong crow's feet"
    - "Thick dark eyebrows slightly arched"
    - "Aquiline nose, prominent bridge"
    - "Olive skin, sun-weathered around eyes and cheekbones"
  hair: "Short dark brown with grey at temples, mostly hidden under cowboy hat"
  expression_default: "Calm, contemplative, quiet authority"
  signature_wardrobe:
    - "Worn leather cowboy hat, dark brown"
    - "Plaid flannel shirt in rust and charcoal tones"
    - "Brown leather jacket, vintage cut"
    - "Dark indigo jeans"

scenes: # 4 escenas
  - "Scene 1 - El Hombre y la Tierra"
  - "Scene 2 - La F150 en su Territorio"
  - "Scene 3 - Conexión Táctil"
  - "Scene 4 - El Horizonte Final"
```

### Detección de inconsistencia (importante)

El Director detectó que la creative direction escrita hablaba de "trigo dorado / heartland", pero el concept board mostraba **cañones rocosos del oeste**. Avisó al usuario antes de gastar créditos.

Decisión: ir con cañones (lo que muestran las imágenes), porque el concept board ya estaba aprobado visualmente.

## Pipeline ejecutado

| Paso | Tiempo | Resultado |
|---|---|---|
| 1. Setup + descarga inputs | ~10s | ✅ |
| 2. Director Creativo (Claude multimodal) | ~30s | ✅ JSON estructurado |
| 3. Aprobación del usuario | ~30s | ✅ "Sí, ejecuta TODO" |
| 4. Subir refs a Higgsfield (media_upload) | ~5s | ✅ 2 media_ids estables |
| 5a. 4 imágenes START en paralelo | ~60s | ✅ 4× 2k cinematográficas |
| 5b. 4 imágenes END en paralelo (chained) | ~60s | ✅ |
| 6. 4 videos seedance_2_0 (paralelo) | ~3 min | ✅ 4 clips de 8s |
| 7. Voiceover ElevenLabs | ~3s | ✅ 14.5s, 232 KB |
| 8. ffmpeg (FULL + CUTS) | ~5s | ✅ 2 MP4 finales |
| 9. Persistir en Airtable | ~5s | ✅ Record Done |
| **Total** | **~6 min** | |

## Outputs

### Local

```
projects/el-viejo-oeste/
├── creative/direction.json       (JSON del Director con character_bible)
├── images/                       (8 imágenes 2k = ~75 MB)
│   ├── scene-1-start.png
│   ├── scene-1-end.png
│   ├── scene-2-start.png
│   ├── scene-2-end.png
│   ├── scene-3-start.png
│   ├── scene-3-end.png
│   ├── scene-4-start.png
│   └── scene-4-end.png
├── videos/                       (4 clips de 8s = ~10 MB)
│   ├── scene-1.mp4
│   ├── scene-2.mp4
│   ├── scene-3.mp4
│   └── scene-4.mp4
├── voice/voiceover.mp3           (14.5s, 232 KB)
└── output/
    ├── el-viejo-oeste-FULL.mp4   (32s, 9.1 MB — videos completos + voz)
    └── el-viejo-oeste-CUTS.mp4   (14.5s, 5.8 MB — fragmentos sincronizados)
```

### Airtable

Record `recHtX6nZPzMmChs2` en la tabla Project + 4 records en Scenes, con status=Done. Todos los campos rellenos: prompts, imágenes (URLs Higgsfield), videos, voiceover.

---

## Costos reales

```
Higgsfield:
  - 8 imágenes nano_banana_2 quality=2k: 50 créditos
  - 4 videos seedance_2_0 720p std: 110 créditos
  - Total: 160 créditos consumidos
  - Equivalencia USD: ~$3.20

ElevenLabs:
  - Script: 194 caracteres
  - Plan Free: incluido sin costo adicional
  - Equivalencia USD: ~$0.04 al precio Starter

Total del ad: ~$3.25
```

> **Comparación**: una producción tradicional de un comercial similar (locación, modelo, vehículo, equipo de filmación, edición) cuesta entre $5,000 y $50,000 USD. El sistema es **~1500x más barato**.

---

## Lecciones aprendidas

### ✅ Lo que funcionó muy bien

1. **Consistencia visual entre escenas** — el personaje, la F150 y el setting se mantuvieron coherentes en las 4 escenas gracias a:
   - Character Bible detallada
   - Money shot + concept board como referencias
   - Chaining: cada end_image usa su start_image como ref

2. **Pipeline paralelo** — 4 imágenes + 4 videos generándose simultáneamente. El n8n original con waits sequential tomaba 15+ minutos. Aquí: 6 minutos.

3. **Voiceover natural** — la voz "NDeNvFOosDh4L0JoDYIq" sonó como narrador cinematográfico real.

4. **Versión CUTS** — el corte de 3.6s por escena sincronizado con el voiceover quedó mejor que la versión FULL de 32s, porque eliminó las transiciones débiles del final de cada clip.

### ⚠️ Bugs encontrados (todos con workarounds en v2)

1. **Seedance fuerza generate_audio: true** — los videos salieron con música autogenerada que rompía el flow del voiceover. **Fix v2**: prompts terminan en `"Ambient SFX only — NO music"` + mezcla a 40% volumen en ffmpeg.

2. **URLs Airtable expiran al fetch en Higgsfield** — los 4 primeros calls fallaron con 404. **Fix**: subir refs vía `media_upload` para obtener IDs estables.

3. **Bash + JSON unicode rompe** — escribir JSON a archivo temporal con Python.

### 🔮 Mejoras planeadas

- Auto-retry de seedance flag "sensitive content"
- Variantes batch (3 opciones por escena, usuario elige)
- Detección automática de inconsistencias texto vs imagen al inicio
- Versión CUTS inteligente (visión analiza qué segmento queda mejor)

---

## ¿Cómo replicar este caso?

1. Instala el skill (ver [01-instalacion.md](01-instalacion.md))
2. Crea un brief similar:
   ```
   Target: Hombre 40 años, redneck con estilo
   Producto: Ford F150
   Setting: Cañones del oeste americano, golden hour
   ```
3. Genera money_shot + concept_board con Gemini/ChatGPT
4. Invoca el skill: `vamos a hacer un ad`
5. Aprueba y espera 6 minutos

---

## El resultado final (sin música)

> Para ver los MP4s reales generados en el caso piloto, contacta a Imperio Digital. Por privacidad de la voz clonada del cliente, no se distribuyen públicamente, pero los miembros pueden verlos en la sesión "Ads Cabrones — Caso de estudio en vivo".

Para ver TU primer caso, instala el sistema y genera el tuyo. Toma 6 minutos.

---

## Próximo paso

Vuelve al **[README principal](README.md)** y arranca con **[01-instalacion.md](01-instalacion.md)**.
