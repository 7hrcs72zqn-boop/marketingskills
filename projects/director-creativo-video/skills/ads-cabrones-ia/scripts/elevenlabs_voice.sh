#!/usr/bin/env bash
# elevenlabs_voice.sh — genera voiceover con ElevenLabs
#
# Uso:
#   ./elevenlabs_voice.sh "<voice_id>" "<texto>" "<output.mp3>"
#
# Variables de entorno requeridas:
#   ELEVENLABS_API_KEY  (en .env del proyecto)

set -euo pipefail

# Cargar .env desde la raíz del proyecto (2 niveles arriba de scripts/)
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
if [[ -f "$ROOT/../.env" ]]; then
  set -a; source "$ROOT/../.env"; set +a
fi

if [[ -z "${ELEVENLABS_API_KEY:-}" ]]; then
  echo "❌ ELEVENLABS_API_KEY no está configurada. Añádela a .env" >&2
  exit 1
fi

VOICE_ID="${1:?voice_id requerido como primer arg}"
TEXT="${2:?texto requerido como segundo arg}"
OUT="${3:?output.mp3 requerido como tercer arg}"

# multilingual v2 = mismo modelo que usaba el n8n original (wavespeed)
MODEL_ID="eleven_multilingual_v2"

echo "🎙  Generando voiceover con ElevenLabs..."
echo "    voice_id: $VOICE_ID"
echo "    output:   $OUT"

# JSON-escape del texto para evitar romper el body
TEXT_ESCAPED=$(python3 -c 'import json,sys; print(json.dumps(sys.argv[1]))' "$TEXT")

curl -sS -X POST "https://api.elevenlabs.io/v1/text-to-speech/${VOICE_ID}" \
  -H "xi-api-key: ${ELEVENLABS_API_KEY}" \
  -H "Content-Type: application/json" \
  -H "Accept: audio/mpeg" \
  --output "$OUT" \
  --data @- <<JSON
{
  "text": ${TEXT_ESCAPED},
  "model_id": "${MODEL_ID}",
  "voice_settings": {
    "stability": 0.5,
    "similarity_boost": 1.0,
    "use_speaker_boost": true
  }
}
JSON

if [[ -s "$OUT" ]]; then
  SIZE=$(wc -c < "$OUT" | tr -d ' ')
  echo "✅ Voiceover generado: $OUT ($SIZE bytes)"
else
  echo "❌ Error: el archivo de salida está vacío" >&2
  exit 2
fi
