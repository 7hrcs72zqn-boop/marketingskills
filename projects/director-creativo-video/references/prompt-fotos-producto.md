# Prompt — 8 fotos profesionales de producto/resultado (Le CliniQ)

Plantilla copy-paste y adapta, basada en el flujo estándar de fotos de producto en distintos contextos, reencuadrada para Le CliniQ (servicio de micropigmentación, no un objeto físico).

```
A continuación te paso fotos de resultados de Le CliniQ.
[Adjuntá 1-2 fotos reales: cejas terminadas (antes/después) o a Soe trabajando]

Necesito 8 fotos profesionales en distintos contextos para una
campaña publicitaria de Le CliniQ Medical Center (Chiclayo, Perú).

- Modelo: gpt_image_2 vía Higgsfield MCP
- Calidad: low (queremos descubrir, después hacemos upscale)
- Resolución: 1k
- Aspect ratio: 16:9 horizontal (Reels, Ads Meta, TikTok, IG)

Estética de marca a respetar en TODAS: "dark luxury" — fondo oscuro
#0d0c0b, dorado #c9a84c, crema #f5f0e8, dorado texto suave #e8d5a3.
Piel con textura real, sin filtro, resultado de cejas natural — nunca
genérico ni de spa low-cost.

8 ángulos distintos:
1. Macro del resultado (cejas terminadas), fondo crema #f5f0e8, luz
   cenital suave — estilo editorial de belleza / e-commerce
2. Macro extremo de los hairstrokes individuales (técnica pelo a
   pelo), cinematográfico, foco selectivo
3. Rostro de clienta en perfil 3/4 contra fondo oscuro #0d0c0b /
   mármol negro, luz lateral dura dorada — dramático, editorial
4. Rostro de mujer (Ana o Kris) recién despierta, piel natural, sin
   maquillaje, luz ambiente cálida — "se ducha y está lista"
5. Mujer arreglándose frente al espejo por la mañana, rutina sin
   esfuerzo, lifestyle luxury, tonos dorado/crema
6. Instrumental premium (demógrafo, pigmentos importados) sobre
   superficie oscura, consultorio Le CliniQ desenfocado al fondo
7. Retrato de clienta al aire libre, luz dorada de atardecer, cejas
   resaltadas naturalmente — aspiracional
8. Plano cenital de pigmentos y herramental premium sobre superficie
   dorada/crema, sombra dura geométrica — flatlay editorial

Mostrame los 8 prompts antes de generar para validar 2-3.
Después dale a generar todas en paralelo.
```

## Nota — Reels / TikTok / Stories

Reels, TikTok e IG Stories son formato **vertical 9:16**. Este set está en 16:9 (feed de Facebook/IG, YouTube, banners de Meta Ads, según lo pedido). Para publicar el mismo contenido en formato vertical, usar `reframe` de Higgsfield sobre los outputs ya generados en vez de regenerar desde cero.
