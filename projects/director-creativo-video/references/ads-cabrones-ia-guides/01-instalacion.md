# 01 — Instalación del Skill

> Tiempo estimado: **10 minutos** (sin contar la creación de cuentas externas).

## Requisitos previos

- macOS o Linux (Windows: usa WSL2)
- [Claude Code](https://claude.com/claude-code) instalado y funcionando
- Cuentas creadas en (las guías 04, 05, 06 te muestran cómo):
  - Higgsfield (con plan Plus o superior)
  - ElevenLabs (free OK)
  - Airtable (free OK)
- `python3` y `bash` disponibles (vienen por default)
- `ffmpeg` (lo instala el wizard si falta)

## Paso 1 — Descomprimir el skill

```bash
# Crea la carpeta global de skills si no existe
mkdir -p ~/.claude/skills

# Descomprime el archivo descargado
tar -xzf ads-cabrones-ia-v2.3.tar.gz -C ~/.claude/skills

# Verifica que se haya creado
ls ~/.claude/skills/ads-cabrones-ia/
# Deberías ver: SKILL.md, references/, scripts/, system/, templates/
```

## Paso 2 — Reiniciar Claude Code

Cierra y vuelve a abrir Claude Code para que detecte el skill nuevo. Después abre una sesión y verifica:

```
> /skills
```

Deberías ver `ads-cabrones-ia` en la lista.

## Paso 3 — Crear la carpeta de tus proyectos

Decide dónde vas a guardar tus ads. Recomendado:

```bash
mkdir -p ~/Documents/ads-cabrones-proyectos
cd ~/Documents/ads-cabrones-proyectos
```

> Cada ad nuevo crea una carpeta `projects/<slug>/` dentro de aquí, con sus inputs/outputs/voz/videos.

## Paso 4 — Invocar el skill (primera vez)

Abre Claude Code en esa carpeta:

```bash
cd ~/Documents/ads-cabrones-proyectos
claude
```

Y di:

```
vamos a hacer un ad cinematográfico
```

El skill detecta que es la primera vez y arranca el **onboarding wizard** automáticamente.

## Paso 5 — Wizard de onboarding (~2 minutos)

El wizard te hará 5 preguntas:

### 1. Caso de uso
| Opción | Cuándo elegir |
|---|---|
| Productos físicos | Autos, perfumes, fashion, tech, comida, lujo |
| Servicios o experiencias | Turismo, restaurantes, eventos, B2B |
| Personal branding | Tú eres la marca (creator, coach, profesional) |
| Variedad | Vas a hacer ads de muchos casos de uso distintos |

### 2. Higgsfield MCP
El wizard verifica conexión llamando `mcp__higgsfield__balance`. Si no responde → ver **[04-guia-higgsfield-mcp.md](04-guia-higgsfield-mcp.md)**.

### 3. ElevenLabs API Key
Pegas tu key. El wizard la valida. Si no tienes → ver **[06-guia-elevenlabs.md](06-guia-elevenlabs.md)**.

### 4. Airtable PAT + Base
Pegas tu Personal Access Token + decides si crear una base nueva o usar una existente. Si no tienes → ver **[05-guia-airtable-pat.md](05-guia-airtable-pat.md)** y **[03-airtable-template.md](03-airtable-template.md)**.

### 5. Voice ID default
Eliges una voz premade (Brian recomendada para narrador masculino) o pegas un `voice_id` de tu Voice Library.

### Confirmación
El wizard escribe:
- `.env` con tus credenciales (permisos 600 — solo tú puedes leer)
- `.ads-cabrones.config.yaml` con preferencias
- `.gitignore` con `.env` añadido

## Paso 6 — Generar tu primer ad

Después del wizard, el skill te pide los 3 inputs:

### Input 1 — Money shot

La **escena que captura la esencia del ad**. Es la imagen "wow" que define el tono. Generalmente una composición wide cinematográfica.

**Cómo crearla**:
- Genera con Gemini/ChatGPT (Nano Banana, GPT Image)
- Sube una foto real (si tienes)
- Diseña en Photoshop/Figma

**Tip**: si tu producto es real (auto, perfume, fashion item), usa una foto profesional del producto en su contexto ideal.

### Input 2 — Concept board

El **grid Personaje/Entorno/Producto** que mantiene consistencia visual.

Descarga la plantilla: `concept-board-template.png` y rellénala con:
- 1 imagen principal del personaje + 4 vistas (cabeza frontal/lateral, 2 poses)
- 1 imagen principal del entorno + 2 vistas alternas
- 1 imagen principal del producto + 2 vistas alternas

⚠️ **IMPORTANTE para evitar el flag de Seedance**: las vistas frontales/close-ups del rostro deben tener **blur ligero** (Gaussian 8-15px) o estar en tres cuartos. Detalle en `templates/concept-board.md` dentro del skill.

### Input 3 — Creative direction (brief)

Texto libre describiendo:
```
Target: [quién es el espectador / personaje]
Producto: [qué vendemos]
Setting: [dónde se graba]
Tono emocional: [opcional]
Tagline: [opcional, si ya tienes]
Script: [opcional, si ya tienes]
```

Ejemplo mínimo:
```
Target: Hombre 40 años, redneck con estilo, masculino y elegante.
Producto: Ford F150.
Setting: Wild West americano, desierto al atardecer.
```

## Paso 7 — Aprobación

El Director Creativo lee tus 3 inputs, genera el JSON estructurado, y te lo presenta. Aprobas (modo auto) o ajustas.

## Paso 8 — Esperas ~6 minutos

El skill ejecuta:
- 8 imágenes en paralelo (~2 min)
- 4 videos en paralelo (~3 min)
- Voiceover (~30s)
- ffmpeg (~30s)
- Persistir Airtable (~10s)

## Paso 9 — Recibes los outputs

```
projects/<slug>/
├── creative/direction.json     ← JSON del Director (con character_bible)
├── images/                     ← 8 imágenes 2k
├── videos/                     ← 4 clips de 8s
├── voice/voiceover.mp3
└── output/
    ├── <slug>-FULL.mp4         ← videos completos + voz + SFX bajo
    └── <slug>-CUTS.mp4         ← fragmentos sincronizados con voz
```

Y el record en Airtable queda con Status=Done.

## Paso 10 — Edición final (manual)

1. Añade tu música desde **Epidemic Sound** (o Suno con el `music_prompt` que te dio el Director)
2. Junta todo en CapCut/Premiere/DaVinci
3. Exporta y publica

---

## Troubleshooting común

### "ffmpeg not found"
```bash
# macOS
brew install ffmpeg

# Linux (Debian/Ubuntu)
sudo apt install ffmpeg
```

### "Higgsfield MCP no responde"
Ve a https://higgsfield.ai/mcp y sigue las instrucciones de instalación. Reinicia Claude Code después.

### "Airtable 422 — campo inexistente"
Tu base no tiene el schema completo. Re-corre el wizard:
```bash
~/.claude/skills/ads-cabrones-ia/scripts/setup.sh --reset
```

### "ElevenLabs 401"
Tu API key venció. Genera una nueva en https://elevenlabs.io/app/settings/api-keys y re-corre el wizard.

### "Seedance: sensitive content"
Tu concept_board tiene caras demasiado nítidas. Aplica blur ligero a las vistas frontales del rostro y vuelve a empezar el ad. Detalle en el skill: `templates/concept-board.md`.

### El audio del video sale como música, no como SFX
El `transition_prompt` no incluyó el sufijo obligatorio. El skill debería forzarlo automáticamente — si no, edita `system/director-creativo.md` y reporta el bug.

---

## Re-correr el setup

Si cambias de cuenta, key o quieres ajustar preferencias:

```bash
~/.claude/skills/ads-cabrones-ia/scripts/setup.sh --reset
```

Esto borra `.ads-cabrones.config.yaml`, hace backup de `.env` actual, y vuelve a correr el wizard.

## ¿Listo?

Si seguiste todos los pasos, ya estás listo para tu primer ad. Vuelve al [README principal](README.md) o salta directo al **[caso de estudio "El viejo oeste"](07-caso-estudio.md)** para ver un ejemplo completo.
