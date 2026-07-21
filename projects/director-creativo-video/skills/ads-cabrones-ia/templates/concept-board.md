---
title: Plantilla Concept Board
purpose: Grid visual de referencia para mantener consistencia + evitar face flag de Seedance
last_updated: 2026-05-04
---

# Concept Board — Plantilla

El concept board es la **imagen matriz** que alimenta al Director Creativo y a `gpt_image_2` en cada generación de escena. Mantiene **consistencia visual** del personaje, entorno y producto a lo largo de todas las escenas del anuncio.

## Estructura del grid (16:9 o 9:16)

```
┌─────────────────────────────────────────────┐
│              CHARACTER                      │
├──────────────┬──────────────┬───────────────┤
│              │ Vista frontal│ Vista lateral │
│   Imagen     │ de la cabeza │ de la cabeza  │
│  principal   │ (semi-blur)* │ (semi-blur)*  │
│  cuerpo      ├──────────────┼───────────────┤
│  entero      │ Ángulo y     │ Ángulo y      │
│              │ pose 1       │ pose 2        │
└──────────────┴──────────────┴───────────────┘

┌─────────────────────────────────────────────┐
│                SETTING                      │
├──────────────────┬──────────────────────────┤
│                  │ Vista entorno 1          │
│  Imagen          ├──────────────────────────┤
│  principal       │ Vista entorno 2          │
│  del entorno     │                          │
└──────────────────┴──────────────────────────┘

┌─────────────────────────────────────────────┐
│                PRODUCT                      │
├──────────────────┬──────────────────────────┤
│                  │ Vista producto 1         │
│  Imagen          ├──────────────────────────┤
│  principal       │ Vista producto 2         │
│  del producto    │                          │
└──────────────────┴──────────────────────────┘
```

\* **Face blur recomendado** — ver sección abajo.

---

## ⚠️ Face Blur — Workaround del flag de Seedance

### El problema

Seedance 2.0 tiene un sistema de moderación que **flaggea como "sensitive content"** cuando detecta caras humanas reales en las imágenes de referencia. Esto rompe la generación de video de la escena.

### La solución (3 capas)

**Capa 1 — Caras blurred en el concept board**:
- Las **vistas frontales y close-ups del rostro** en el cuadrante CHARACTER deben tener un **blur ligero** (radius 8-15px Gaussian) o estar en **tres cuartos** / **perfil parcial** (no plenamente frontales).
- La **imagen principal de cuerpo entero** sí puede ser nítida, porque la cara aparece pequeña y el modelo se enfoca en la silueta + vestuario.
- Las "Ángulo y pose 1/2" pueden ser de espalda, perfil, o con la cara semi-oculta por sombrero/cabello/objeto.

**Capa 2 — Character Bible exhaustiva** (en `direction.json`):
- El Director genera una ficha facial detallada (mandíbula, ojos, cejas, nariz, piel, etc.)
- gpt_image_2 puede recrear caras consistentes a partir de esa descripción textual sin necesitar fotos reales

**Capa 3 — Prompts con menos foco facial cuando es posible**:
- Si Seedance flaggea aún así, regenerar el `start_image` con `Composition: wider shot` o `Subject: ... seen from three-quarter angle, hat brim casting shadow over upper face`

### Cómo aplicar el blur en el concept board

**Opción A — Photoshop / Figma**:
- Selecciona las 2 vistas de cabeza
- Filter > Blur > Gaussian Blur, radius 8-12px
- Mantén el resto del grid nítido

**Opción B — Generación con AI (Gemini, ChatGPT)**:
Pídele al modelo de generación:
> "In the CHARACTER quadrant, the front and side head views should be slightly out of focus or partially obscured (hat shadow, three-quarter angle, soft blur). The full-body shot can stay sharp. The SETTING and PRODUCT quadrants should be fully sharp."

**Opción C — ffmpeg (si ya tienes el grid generado)**:
```bash
# Esta opción requiere conocer las coords exactas de las viewports en el grid
# Mejor usar A o B
```

---

## Cómo armar el concept board

### Opción A — Generar todo con IA (recomendado para empezar)

En Gemini / ChatGPT con generación de imagen:
1. Genera el **personaje** describiendo target (edad, género, vestuario, actitud) — pide vista frontal, lateral, cuerpo completo y 2 poses. **Pide explícitamente las vistas de cabeza con blur ligero o tres cuartos**.
2. Genera el **setting** — pide imagen principal + 2 ángulos distintos del mismo lugar.
3. Sube fotos del **producto** real (o generálas si es ficticio).
4. Pega esta plantilla como referencia y pídele que **componga el grid completo en una sola imagen 16:9 o 9:16**.

### Opción B — Photoshop / Figma / Canva

Si tienes assets propios (fotos del talento, fotos del producto, locación real), arma el grid manualmente. Aplica blur a las vistas de cabeza siguiendo la sección anterior.

### Opción C — Higgsfield Marketing Studio

Para ads con producto real:
1. Sube el producto a Higgsfield Marketing Studio (`show_marketing_studio` con URL del producto)
2. Genera variantes del producto en distintos ángulos
3. Combina con character + setting en grid externo

---

## Qué pasa con el concept board en el sistema

1. **Director Creativo lo analiza** (multimodal) para extraer el lenguaje visual base + escribir la `character_bible`.
2. **`gpt_image_2` lo usa como referencia** junto al money shot al generar cada escena. Esto mantiene consistencia.
3. **Se guarda en Airtable** como `Core Elements` adjunto al proyecto.
4. **El skill detecta caras nítidas vs blurred** y avisa al usuario si las caras están demasiado nítidas y podrían trigger el flag de Seedance.

---

## Tips

- **Aspect ratio**: 16:9 para ads horizontales (YouTube, web), 9:16 para reels (TikTok, Stories)
- **Calidad alta** — los modelos son sensibles a detalle (skin texture, fabric, lighting consistency)
- **Lighting consistente entre los tres bloques**: si el setting es atardecer, el character debe estar iluminado como atardecer
- **Producto bien iluminado**, fondo limpio, ángulos que muestren el detalle clave (logo, forma, textura)
- **Caras**: blur ligero en vistas frontales (anti-flag Seedance), o usa fotos donde la persona NO sea el foco principal
