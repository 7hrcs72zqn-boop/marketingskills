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

## Clips ya generados en la sesión remota (legítimos, listos para usar)

Con la red bloqueada no se pudo armar el MP4 final, pero sí se generaron 10 piezas legítimas
(sin inventar clientas): 5 clips animados sobre fotos reales del usuario (identidad preservada,
solo micro-movimiento agregado), 2 clips de Soe (su identidad real vía reference element), y 2
tarjetas gráficas de texto (sin personas). Detalle completo con URLs y job_ids en
`/tmp/le-cliniq-libertad-ana/creative/clips_reales.json` de la sesión remota (efímero — si ya no
existe, hay que regenerar usando los job_ids de abajo como referencia, o descargar directo de
Higgsfield con `show_generations`/`job_display` por id).

| # | Escena | Fuente | video/image_job | Duración |
|---|---|---|---|---|
| 1 | Antes | foto real `c55ebbb5` animada | `7bc25ed7-4d45-4ff7-a86f-4709dfb737cb` | 4s |
| 2 | Soe en consulta | identidad real de Soe | `9bf15bcf-290b-43d7-b2d2-89939a920277` | 6s |
| 3 | Diseño 1 | foto real `a3605d1e` animada | `70e04959-f805-40f1-8c9d-9dc0497b5d46` | 4s |
| 4 | Diseño 2 | foto real `3ba8c863` animada | `bf8c5972-89ac-4143-a63d-21f718f9e41c` | 4s |
| 5 | Proceso de microblading | **video real sin regenerar** | `a43e857a-87e8-450a-bc5b-98f87dcf7935` | — |
| 6 | Después | foto real `29a1d6e4` animada | `53ba5706-44df-4ebd-a8a7-1bb144f699a8` | 4s |
| 7 | Espejo (money shot) | foto real `b9d05ae1` animada | `48124265-3488-44e5-9b16-ebd0f739e185` | 5s |
| 8 | Soe + CTA urgencia | identidad real de Soe | `76119a41-8d02-478a-a681-d8c995b832d2` | 4s |
| 9 | Pack Independencia (gráfico) | texto, sin personas | `0e30cd65-d699-4a5a-aba5-b16e3a32d1e5` | 3s (held) |
| 10 | Contacto final (gráfico) | texto, sin personas | `1ddc321c-2ad0-446e-8f45-85c4b7ffef45` | 2s (held) |

Duración total aprox: ~26s. CTA de escena 8 (agregar como texto en post, no está grabado en
audio): **"Últimos cupos disponibles antes de cerrar agenda de Julio"**.

## Próximos pasos al retomar en local

1. Confirmar con el usuario las descripciones pendientes de assets aún sin usar (arriba: 3 fotos +
   5 videos) — puede que quieran sumar más escenas con esos.
2. Descargar los 10 clips/imágenes de la tabla de arriba desde Higgsfield (por job_id, con
   `job_display` o directo de la URL) — funciona en local.
3. Concatenar en orden con ffmpeg (imágenes 9 y 10 como held frame con `zoompan`/`loop`).
4. Voiceover ElevenLabs (voz de Soe) leyendo el script completo + música ElevenLabs Music
   (dark luxury, ~26-30s).
5. Mezclar audio (SFX nativo 0.3 + voz 1.0 + música 0.5) y exportar MP4 final.
6. Si el usuario quiere sumar los assets pendientes de confirmar, regenerar/incorporar esas
   escenas antes del paso 3.
