---
title: Campaña Independencia 2026 — "Libertad Sin Esfuerzo" (Le CliniQ)
status: en pausa — retomar en Claude Code local
last_updated: 2026-07-22
---

# Campaña Independencia — "Libertad Sin Esfuerzo"

Comercial de microblading 9D para Fiestas Patrias 2026. Trabajo iniciado en una sesión remota
(claude.ai/code) que no puede terminarse ahí por restricciones de red — ver abajo. Este archivo es
el punto de retoma para Claude Code local.

## ⚠️ Corrección crítica — leer primero

En la sesión remota se generaron por error 7 imágenes START + 7 END + 5 videos (GPT Image 2 /
Seedance 2.0) **inventando una clienta ficticia "Ana"**, reutilizando su cara en varias escenas
como si fuera una sola persona. El usuario rechazó esto explícitamente:

> "no era necesario que generes imagenes nuevas, por eso te subí todas las imagenes que
> necesitabas... no hay relación con ana, hay muchas clientas diferentes"

**No usar esas imágenes/videos generados para las escenas de clientas.** La única excepción
legítima es el avatar de **Soe Macero** (la especialista real, ver abajo) — son sus propias fotos
reales, no una clienta inventada.

## ⚠️ Por qué no se pudo terminar en la sesión remota

El proxy de red de esa sesión bloqueó (403):
- `api.elevenlabs.io` (voiceover + música)
- `d8j0ntlcm91z4.cloudfront.net` (CDN de Higgsfield, para descargar assets generados)

Las llamadas MCP a Higgsfield (`generate_image`, `generate_video`, `motion_control`) sí
funcionaron — el bloqueo es solo para tráfico HTTPS directo desde la sesión. En Claude Code local
esto no debería ser un problema.

## Assets reales confirmados por el usuario (usar estos, no inventar)

| media_id (Higgsfield) | Contenido real |
|---|---|
| `c55ebbb5-fb9e-4501-a310-a84563759d0d` | Antes de la clienta |
| `a3605d1e-b0c6-4fa0-a43f-3393603884d7` | Diseño |
| `3ba8c863-bb5b-47e0-ad11-5847381566d6` | Diseño (segunda foto) |
| `29a1d6e4-1e4b-40ef-adf4-66108299a03e` | Después |
| `b9d05ae1-0c9d-4da2-84e6-886d7587b140` | Clienta viéndose al espejo (money shot) |
| video `a43e857a-87e8-450a-bc5b-98f87dcf7935` | Video real del proceso de microblading |

**Pendiente de confirmar con el usuario al retomar** (no asumir):
- `666e80ff-d49f-4792-9ce4-a1cc92493cc8` (IMG_5738.jpg)
- `30f995f6-b140-4a8b-9ca3-ab52d254b680` (soe guantes.png)
- `f7a133d3-8ba5-4083-a595-590943214464` (asumido headshot de Soe — confirmar)
- 5 videos sin describir: `dcd2b84a-1b2e-4bdc-b294-38d3aeed6a5d`,
  `287531a1-8240-496b-9261-139888c6462b`, `2ab8479d-3f45-4621-a2eb-ca07fcdb762b`,
  `9e80b104-b786-499f-9d2d-cfd2c0816ea0`, `39b517ef-4f6d-444a-9c54-c4588148fd66`

## Identidad de Soe Macero (legítima, no inventada)

- Reference element Higgsfield: `97b66bf1-fd28-4980-b0ae-8e527b8456fe` ("soe-ucg-avatar"), basado
  en media real `62812c75-4b20-4291-9c83-18921de32841` (foto real de Soe corregida: cabello
  castaño oscuro largo hasta la cintura, sin tatuajes, 50kg, manos delicadas).
- NO tiene tatuajes. Herramienta SIEMPRE sobre ceja, NUNCA frente (ver
  `lecciones-aprendidas-imagenes.md`).

## Credenciales

No se commitean aquí (`.env` está en `.gitignore`). El usuario ya las tiene:
- ElevenLabs API key
- Voice ID de Soe (voz clonada, ElevenLabs)

Pedirlas de nuevo al usuario si no están en un `.env` local al retomar.

## Configuración

- Modo LOW COST: quality=low, 1k imágenes, 720p video — generación nativa en baja calidad, NO
  comprimir un output de alta calidad después.
- Subir a HIGH COST (quality=high, 2k/1080p) solo tras aprobación explícita del usuario.
- Skill: `ads-cabrones-ia` v2.3 en `../skills/ads-cabrones-ia/`.

## Próximos pasos al retomar en local

1. Confirmar con el usuario las descripciones pendientes de assets (arriba).
2. Replantear el guion de escenas usando SOLO assets reales confirmados — tratar como reel
   documental/testimonial de varias clientas reales, no una sola persona ficticia.
3. Descargar fotos/video reales desde Higgsfield CDN (funciona en local).
4. Animar con `motion_control` (Kling 3.0) usando el video real `a43e857a` como referencia de
   movimiento sobre las fotos reales, si se necesita movimiento sutil.
5. Voiceover ElevenLabs (voz de Soe) + música ElevenLabs Music.
6. Edición ffmpeg FULL + CUTS (funciona en local).
