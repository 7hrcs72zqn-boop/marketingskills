#!/usr/bin/env bash
# setup.sh — Wizard de onboarding interactivo para Ads Cabrones IA
#
# Uso:
#   ./setup.sh           → corre el wizard completo si no hay config
#   ./setup.sh --reset   → reinicia el setup (backup de .env, borra config)
#   ./setup.sh --check   → solo verifica el estado actual
#
# Output:
#   .env                          (ELEVENLABS_API_KEY, AIRTABLE_PAT)
#   .ads-cabrones.config.yaml     (preferencias del skill)
#   .gitignore                    (añade .env si no estaba)

set -euo pipefail

CONFIG_FILE=".ads-cabrones.config.yaml"
ENV_FILE=".env"

# ─────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────

color_green() { printf '\033[0;32m%s\033[0m\n' "$1"; }
color_red() { printf '\033[0;31m%s\033[0m\n' "$1"; }
color_yellow() { printf '\033[1;33m%s\033[0m\n' "$1"; }
color_blue() { printf '\033[0;34m%s\033[0m\n' "$1"; }

# Verifica si un valor está en .env
env_has_key() {
  local key="$1"
  [[ -f "$ENV_FILE" ]] && grep -q "^${key}=" "$ENV_FILE"
}

# Set/update key en .env
env_set() {
  local key="$1"
  local value="$2"
  touch "$ENV_FILE"
  chmod 600 "$ENV_FILE"
  if grep -q "^${key}=" "$ENV_FILE" 2>/dev/null; then
    sed -i.bak "s|^${key}=.*|${key}=${value}|" "$ENV_FILE"
    rm -f "${ENV_FILE}.bak"
  else
    printf '%s=%s\n' "$key" "$value" >> "$ENV_FILE"
  fi
}

ensure_gitignore() {
  touch .gitignore
  if ! grep -q "^\.env$" .gitignore 2>/dev/null; then
    echo ".env" >> .gitignore
  fi
  if ! grep -q "^${CONFIG_FILE}$" .gitignore 2>/dev/null; then
    # config no es secret pero puede tener IDs sensibles
    echo "$CONFIG_FILE" >> .gitignore
  fi
}

# ─────────────────────────────────────────
# Modo --check
# ─────────────────────────────────────────

if [[ "${1:-}" == "--check" ]]; then
  echo "Estado del setup en $(pwd):"
  if [[ -f "$ENV_FILE" ]]; then
    echo "  .env: ✓ existe"
    env_has_key ELEVENLABS_API_KEY && echo "    ELEVENLABS_API_KEY: ✓" || echo "    ELEVENLABS_API_KEY: ✗"
    env_has_key AIRTABLE_PAT && echo "    AIRTABLE_PAT: ✓" || echo "    AIRTABLE_PAT: ✗"
  else
    echo "  .env: ✗ no existe"
  fi

  if [[ -f "$CONFIG_FILE" ]]; then
    echo "  $CONFIG_FILE: ✓ existe"
  else
    echo "  $CONFIG_FILE: ✗ no existe"
  fi
  exit 0
fi

# ─────────────────────────────────────────
# Modo --reset
# ─────────────────────────────────────────

if [[ "${1:-}" == "--reset" ]]; then
  color_yellow "⚠️  Reset solicitado."
  if [[ -f "$ENV_FILE" ]]; then
    cp "$ENV_FILE" "${ENV_FILE}.bak.$(date +%s)"
    echo "  Backup de .env guardado como .env.bak.<timestamp>"
  fi
  rm -f "$CONFIG_FILE"
  echo "  Config borrada. Continúa con el wizard..."
  echo ""
fi

# ─────────────────────────────────────────
# Detección de setup completo
# ─────────────────────────────────────────

if [[ "${1:-}" != "--reset" ]] && [[ -f "$CONFIG_FILE" ]] && env_has_key ELEVENLABS_API_KEY && env_has_key AIRTABLE_PAT; then
  color_green "✅ Setup ya completo. Para reiniciar: ./setup.sh --reset"
  cat "$CONFIG_FILE"
  exit 0
fi

# ─────────────────────────────────────────
# Wizard
# ─────────────────────────────────────────

color_blue "════════════════════════════════════════════════"
color_blue "  Ads Cabrones IA — Onboarding Wizard"
color_blue "════════════════════════════════════════════════"
echo ""
echo "Voy a hacerte 5 preguntas (~2 minutos) para configurar el sistema."
echo "Después de esto, generar un ad cinematográfico tomará ~6 min y costará ~\$3-5."
echo ""

# ── Pregunta 1: caso de uso ──
color_blue "1️⃣  ¿Qué tipo de ads vas a generar principalmente?"
echo ""
echo "  1) Productos físicos (autos, perfumes, fashion, tech, comida, lujo)"
echo "  2) Servicios o experiencias (turismo, restaurantes, eventos, B2B)"
echo "  3) Personal branding o creator content"
echo "  4) Variedad — múltiples casos de uso"
echo ""
read -p "Tu opción (1-4): " USE_CASE_NUM

case "$USE_CASE_NUM" in
  1) USE_CASE="Productos físicos" ;;
  2) USE_CASE="Servicios o experiencias" ;;
  3) USE_CASE="Personal branding o creator content" ;;
  4) USE_CASE="Variedad" ;;
  *) USE_CASE="Variedad" ;;
esac
color_green "  → $USE_CASE"
echo ""

# ── Pregunta 2: Higgsfield (verificación) ──
color_blue "2️⃣  Verificando Higgsfield MCP..."
echo ""
echo "  ⚠️  Este script no puede llamar al MCP directamente."
echo "  Por favor, en Claude Code, ejecuta: mcp__higgsfield__balance"
echo "  Si ves créditos disponibles, continúa."
echo ""
read -p "  ¿Higgsfield MCP responde con créditos? (s/n): " HF_OK
if [[ "$HF_OK" != "s" && "$HF_OK" != "S" ]]; then
  color_red "❌ Instala el MCP desde https://higgsfield.ai/mcp y vuelve a correr setup.sh"
  exit 1
fi
color_green "  ✓ Higgsfield MCP confirmado"
echo ""

# ── Pregunta 3: ElevenLabs ──
color_blue "3️⃣  ElevenLabs API Key"
echo ""
echo "   Necesario para el voiceover. Crea una key gratis en:"
echo "   https://elevenlabs.io/app/settings/api-keys"
echo ""
read -p "   Pégala aquí (o 'skip'): " EL_KEY

VOICE_ENABLED=false
if [[ "$EL_KEY" != "skip" && -n "$EL_KEY" ]]; then
  # Validar
  echo "   Validando..."
  COUNT=$(curl -sS -H "xi-api-key: $EL_KEY" "https://api.elevenlabs.io/v1/voices" \
    | python3 -c "import json,sys; print(len(json.load(sys.stdin).get('voices',[])))" 2>/dev/null || echo "0")

  if [[ "$COUNT" -gt 0 ]]; then
    color_green "   ✓ Key válida — $COUNT voces disponibles"
    env_set ELEVENLABS_API_KEY "$EL_KEY"
    VOICE_ENABLED=true
  else
    color_red "   ✗ Key inválida o ElevenLabs no responde"
    read -p "   ¿Skip ElevenLabs por ahora? (s/n): " SKIP_EL
    if [[ "$SKIP_EL" == "s" ]]; then
      VOICE_ENABLED=false
    else
      color_red "Re-corre el setup cuando tengas la key correcta."
      exit 1
    fi
  fi
else
  color_yellow "   ⊝ Skipped — el sistema generará todo menos voiceover"
fi
echo ""

# ── Pregunta 4: Airtable ──
color_blue "4️⃣  Airtable Personal Access Token"
echo ""
echo "   Necesario para guardar proyectos. Crea uno en:"
echo "   https://airtable.com/create/tokens"
echo "   Scopes: data.records:read/write, schema.bases:read/write"
echo ""
read -p "   Pégalo aquí (o 'skip'): " AT_PAT

AIRTABLE_ENABLED=false
AIRTABLE_BASE=""
if [[ "$AT_PAT" != "skip" && -n "$AT_PAT" ]]; then
  env_set AIRTABLE_PAT "$AT_PAT"
  AIRTABLE_ENABLED=true

  echo ""
  color_blue "4️⃣b ¿Base Airtable existente o nueva?"
  echo "  1) Tengo una base existente — te paso el baseId"
  echo "  2) Crear una base nueva (manual via Airtable UI primero, después pégame el ID)"
  read -p "  Tu opción (1-2): " BASE_OPT

  if [[ "$BASE_OPT" == "1" || "$BASE_OPT" == "2" ]]; then
    read -p "  baseId (formato appXXXXXXXX): " AIRTABLE_BASE

    # Validar
    echo "  Validando..."
    SCHEMA_RESP=$(curl -sS -H "Authorization: Bearer $AT_PAT" \
      "https://api.airtable.com/v0/meta/bases/${AIRTABLE_BASE}/tables" 2>&1)

    if echo "$SCHEMA_RESP" | python3 -c "import json,sys; d=json.load(sys.stdin); exit(0 if 'tables' in d else 1)" 2>/dev/null; then
      TABLES=$(echo "$SCHEMA_RESP" | python3 -c "import json,sys; print(len(json.load(sys.stdin)['tables']))")
      color_green "  ✓ Base válida — $TABLES tablas"
    else
      color_red "  ✗ No puedo acceder a la base. Verifica scopes del PAT."
      exit 1
    fi
  fi
else
  color_yellow "   ⊝ Skipped — el sistema trabajará local-only"
fi
echo ""

# ── Pregunta 5: Voice default (solo si ElevenLabs activo) ──
DEFAULT_VOICE_ID="nPczCjzI2devNBz1zQrb"
DEFAULT_VOICE_NAME="Brian"

if $VOICE_ENABLED; then
  color_blue "5️⃣  ¿Voz default para tus ads?"
  echo ""
  echo "  1) Brian — masculino, deep, cinematográfico ★ (default)"
  echo "  2) Bill — masculino, wise, mature"
  echo "  3) Sarah — femenina, mature, reassuring"
  echo "  4) Daniel — masculino británico, broadcaster"
  echo "  5) Otra — pego un voice_id de mi library"
  echo ""
  read -p "  Tu opción (1-5, default 1): " VOICE_OPT

  case "$VOICE_OPT" in
    2) DEFAULT_VOICE_ID="pqHfZKP75CvOlQylNhV4"; DEFAULT_VOICE_NAME="Bill" ;;
    3) DEFAULT_VOICE_ID="EXAVITQu4vr4xnSDxMaL"; DEFAULT_VOICE_NAME="Sarah" ;;
    4) DEFAULT_VOICE_ID="onwK4e9ZLuTAKqWW03F9"; DEFAULT_VOICE_NAME="Daniel" ;;
    5)
      read -p "  voice_id: " DEFAULT_VOICE_ID
      DEFAULT_VOICE_NAME="Custom"
      ;;
    *) ;;
  esac
  color_green "  → $DEFAULT_VOICE_NAME ($DEFAULT_VOICE_ID)"
  echo ""
fi

# ── Escribir config ──
color_blue "Guardando configuración..."

ensure_gitignore

cat > "$CONFIG_FILE" <<EOF
# Generado por ads-cabrones-ia setup.sh
# No editar manualmente — corre 'setup.sh --reset' para cambiar

version: 2.0
created_at: "$(date -u +%Y-%m-%dT%H:%M:%SZ)"

use_case: "${USE_CASE}"

higgsfield:
  enabled: true

elevenlabs:
  enabled: ${VOICE_ENABLED}
  default_voice_id: "${DEFAULT_VOICE_ID}"
  default_voice_name: "${DEFAULT_VOICE_NAME}"

airtable:
  enabled: ${AIRTABLE_ENABLED}
  base_id: "${AIRTABLE_BASE}"
  project_table: "Project"
  scenes_table: "Scenes"

director_defaults:
  num_scenes: 4
  aspect_ratio: "16:9"
  resolution_image: "2k"
  resolution_video: "720p"
  quality_image: "high"
  language: "es"
EOF

chmod 644 "$CONFIG_FILE"

# ── Resumen ──
echo ""
color_green "════════════════════════════════════════════════"
color_green "  ✅ Setup completo!"
color_green "════════════════════════════════════════════════"
echo ""
echo "  Caso de uso:    $USE_CASE"
echo "  ElevenLabs:     $($VOICE_ENABLED && echo "✓ $DEFAULT_VOICE_NAME" || echo "⊝ skipped")"
echo "  Airtable:       $($AIRTABLE_ENABLED && echo "✓ $AIRTABLE_BASE" || echo "⊝ skipped")"
echo ""
echo "  Archivos creados:"
echo "    $ENV_FILE                       (permisos 600)"
echo "    $CONFIG_FILE  (preferencias)"
echo "    .gitignore                  (con .env y config protegidos)"
echo ""
color_blue "🎬 Para generar tu primer ad:"
echo "  1. Prepara: money_shot.png + concept_board.png + brief"
echo "  2. En Claude Code, di: 'vamos a hacer un ad' o pega tu brief"
echo ""
