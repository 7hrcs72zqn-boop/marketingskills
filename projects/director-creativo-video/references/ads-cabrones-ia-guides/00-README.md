# 🎬 Ads Cabrones IA — Sistema completo

> Genera anuncios cinematográficos completos con IA en ~6 minutos por ~$3-5/ad. Sistema de Imperio Digital basado en Claude Code + Higgsfield + ElevenLabs + Airtable.

## ¿Qué incluye este paquete?

```
imperio-deliverables/
├── README.md                              ← este archivo (índice)
├── ads-cabrones-ia-v2.3.tar.gz              ← skill completo (30 KB)
├── concept-board-template.png             ← grid vacío para llenar con tus assets
│
├── 01-instalacion.md                      ← cómo instalar el skill paso a paso
├── 03-airtable-template.md                ← cómo armar tu base Airtable
│
├── 04-guia-higgsfield-mcp.md              ← conectar Higgsfield (2 min)
├── 05-guia-airtable-pat.md                ← generar Personal Access Token de Airtable (3 min)
├── 06-guia-elevenlabs.md                  ← obtener API key de ElevenLabs (2 min)
│
└── 07-caso-estudio.md                     ← ejemplo real "El viejo oeste" (Ford F150)
```

---

## ⚡ Quick Start (10 minutos)

Si ya conoces Claude Code y tienes cuentas en Higgsfield/ElevenLabs/Airtable:

```bash
# 1. Descomprime el skill en tu carpeta global de skills
mkdir -p ~/.claude/skills
tar -xzf ads-cabrones-ia-v2.3.tar.gz -C ~/.claude/skills

# 2. Reinicia Claude Code para que detecte el skill nuevo

# 3. Crea una carpeta para tu proyecto y entra en Claude Code
cd ~/proyectos/mi-primer-ad
claude

# 4. Invoca el skill
> vamos a hacer un ad cinematográfico

# El skill detecta primera ejecución y corre el wizard de onboarding (~2 min).
# Después te pide los 3 inputs: money_shot.png + concept_board.png + brief.
```

Si necesitas la guía detallada → **[01-instalacion.md](01-instalacion.md)**

---

## 🎯 ¿Qué hace este sistema?

Toma 3 inputs y genera un anuncio cinematográfico completo:

```
📥 INPUTS (manuales)
   ├── money_shot.png        ← la escena que captura la esencia del ad
   ├── concept_board.png     ← grid Personaje/Entorno/Producto
   └── brief.md              ← creative direction libre

⚙️  PIPELINE (automático, ~6 min)
   1. Director Creativo (Claude multimodal) genera JSON estructurado
   2. APROBACIÓN única del usuario
   3. GPT Image 2 → 8 imágenes 2k cinematográficas
   4. Seedance 2.0 → 4 videos de 8s con SFX naturales
   5. ElevenLabs → voiceover multilingual
   6. ffmpeg → 2 versiones MP4 (FULL 32s + CUTS 14s)
   7. Airtable → persiste todo (prompts, imágenes, videos, voz)

📤 OUTPUTS
   ├── projects/<slug>/output/<slug>-FULL.mp4    ← videos completos
   ├── projects/<slug>/output/<slug>-CUTS.mp4    ← fragmentos sincronizados
   ├── projects/<slug>/voice/voiceover.mp3
   └── Airtable record con Status=Done
```

**Tú solo añades**: la música (Epidemic Sound, Suno, tu librería) y la edición fina si quieres ajustes pixel-perfect.

---

## 🛠 Requisitos

| Servicio | Plan necesario | Costo aprox/mes |
|---|---|---|
| **Claude Code** | Pro o API | $20/mes |
| **Higgsfield** | Plus o superior | $30/mes (Plus incluye ~600 créditos = ~3 ads) |
| **ElevenLabs** | Free OK para empezar | $0 (10k chars/mes) o $5/mes (30k chars) |
| **Airtable** | Free OK para empezar | $0 |
| **macOS o Linux** | con `ffmpeg` y `python3` | — |

**Costo por ad**: ~$3.50-5.00 (Higgsfield + ElevenLabs).

---

## 📚 Empezar aquí

1. **[01-instalacion.md](01-instalacion.md)** — Instalar el skill en tu Claude Code
2. **[04-guia-higgsfield-mcp.md](04-guia-higgsfield-mcp.md)** — Conectar Higgsfield (si aún no lo tienes)
3. **[05-guia-airtable-pat.md](05-guia-airtable-pat.md)** — Generar tu Personal Access Token
4. **[06-guia-elevenlabs.md](06-guia-elevenlabs.md)** — Obtener API key
5. **[03-airtable-template.md](03-airtable-template.md)** — Armar tu base de Airtable
6. **[07-caso-estudio.md](07-caso-estudio.md)** — Ver ejemplo completo

Después: invoca el skill diciendo *"vamos a hacer un ad"* y deja que el wizard te guíe.

---

## ❓ Preguntas frecuentes

**¿Tengo que saber programar?**  
No. El skill maneja todo. Solo necesitas pegar tus 3 inputs y aprobar la dirección creativa.

**¿Funciona en Windows?**  
Sin probar. Los scripts son bash + Python — debería funcionar en WSL2. Si encuentras issues, repórtalo en el canal de la comunidad.

**¿Puedo usar mi propia voz clonada de ElevenLabs?**  
Sí. En el wizard de onboarding, al elegir voice, selecciona "Otra" y pegas el `voice_id` de tu Voice Library.

**¿Y si quiero música autogenerada en vez de Epidemic Sound?**  
El sistema **no genera música por default** (decisión de calidad). Pero puedes generar una con `scripts/elevenlabs_music.sh` o usar Suno con el `music_prompt` que el Director te entrega.

**¿Cómo edito el comercial final si hay errores?**  
Las dos versiones MP4 (FULL y CUTS) son punto de partida. Abre en CapCut/Premiere/DaVinci, mete tu música, ajusta cortes finos, exporta.

**¿El skill aprende de mis ads pasados?**  
No automáticamente. Pero todos los proyectos quedan en Airtable y puedes pedirle a Claude que analice tus mejores ads pasados al armar uno nuevo (similar a lo que hace `bencord-thumbnails-pro` con outliers).

---

## 🐛 Reportar bugs / sugerencias

Canal de Imperio Digital → #ads-cabrones-ia (o donde corresponda en tu config).

Bugs conocidos y workarounds documentados en `references/lecciones-aprendidas.md` dentro del skill.

---

## 📜 Versión & changelog

**v2.3** (2026-05-04) — actual ⭐
- ⏱ **Duraciones variables por escena** ✨ — cada `generate_video()` acepta `duration` 4-15s. NO todos a 8s. Mejora ritmo + reduce costos ~30%.
- **6-8 escenas sugeridas** (no fijo 6). Storytelling emocional puede ir a 8-12.
- Director Creativo ahora incluye `"duration"` en cada scene del JSON
- Tabla de duraciones por tipo de escena (setup 5-6s, climax 8-10s, brand reveal 5s, etc.)
- **ffmpeg fallback** documentado para escenas flag-eadas por Seedance (`ip_detected`) — usa STARTs+ENDs con xfade + zoompan
- **Tolerancia a MCP timeout** — el skill genera `RESUME-AFTER-RESTART.md` automáticamente cuando el MCP runtime cae
- Lecciones del caso "El Abrigo" (comercial emocional 11 escenas, fórmula Cannes Lions)

**v2.2** (2026-05-04)
- **CUTS narrativo** ✨ — los cuts respetan el arco de la historia (no random intercalado). Curva narrativa con 70% escena dominante + 30% flashback/flashforward.
- Director Creativo refuerza **arco narrativo** explícito en las 6 escenas (setup → develop → climax → resolution).
- Lección: si las escenas son sueltas, el CUTS no cuenta historia.

**v2.1** (2026-05-04)
- Default **6 escenas** (no 4)
- `ending_image_prompt` con **cambio MÍNIMO** (resuelve transiciones raras de seedance)
- Videos a **1080p** (mode std — `pro` no soportado por seedance_2_0)
- **Música ElevenLabs Music API** integrada (`music_v1`)
- **Pregunta final** post-generación: ¿alguna escena quedó rara?
- Director **desanclado** de estética premium aspiracional

**v2.0** (2026-05-04)
- Cambió de nano_banana_2 a **GPT Image 2** (mejor text rendering)
- Añadió **Onboarding Wizard** para multi-tenant
- Añadió **Character Bible** para consistencia facial sin usar fotos reales
- Añadió **SFX-first audio strategy** (videos sin música autogenerada)
- Sistema 100% **agnóstico de caso de uso**
- Documentó workarounds para 6 bugs conocidos

**v1.0** (2026-05-04, mismo día)
- Migración inicial del workflow n8n + Airtable + Suno/Veo3 al stack Claude Code + Higgsfield MCP

---

## 🙏 Créditos

Sistema desarrollado por **Imperio Digital** con base en el workflow n8n original de Bencord. Compatible con:

- [Claude Code](https://claude.com/claude-code) — agente
- [Higgsfield](https://higgsfield.ai) — generación de imagen y video
- [ElevenLabs](https://elevenlabs.io) — voiceover multilingual
- [Airtable](https://airtable.com) — persistencia y orquestación

> Esta dirección creativa fue desarrollada por Imperio Digital
