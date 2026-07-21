#!/usr/bin/env bash
# elevenlabs_music.sh — opcional: generar música con ElevenLabs Music API
#
# Por defecto, la música la elige el usuario en Epidemic Sound.
# Este script existe por si en algún momento queremos generar música automáticamente.
#
# Uso:
#   ./elevenlabs_music.sh "<music_prompt>" "<output.mp3>" [duration_ms]
#
# Variables de entorno requeridas:
#   ELEVENLABS_API_KEY

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
if [[ -f "$ROOT/../.env" ]]; then
  set -a; source "$ROOT/../.env"; set +a
fi

if [[ -z "${ELEVENLABS_API_KEY:-}" ]]; then
  echo "❌ ELEVENLABS_API_KEY no está configurada" >&2
  exit 1
fi

PROMPT="${1:?music prompt requerido}"
OUT="${2:?output.mp3 requerido}"
DURATION_MS="${3:-40000}"  # 40 segundos default

echo "🎵 Generando música con ElevenLabs Music..."
echo "    duración: ${DURATION_MS}ms"
echo "    output:   $OUT"

PROMPT_ESCAPED=$(python3 -c 'import json,sys; print(json.dumps(sys.argv[1]))' "$PROMPT")

curl -sS -X POST "https://api.elevenlabs.io/v1/music" \
  -H "xi-api-key: ${ELEVENLABS_API_KEY}" \
  -H "Content-Type: application/json" \
  -H "Accept: audio/mpeg" \
  --output "$OUT" \
  --data @- <<JSON
{
  "prompt": ${PROMPT_ESCAPED},
  "music_length_ms": ${DURATION_MS},
  "model_id": "music_v1"
}
JSON

if [[ -s "$OUT" ]]; then
  SIZE=$(wc -c < "$OUT" | tr -d ' ')
  echo "✅ Música generada: $OUT ($SIZE bytes)"
else
  echo "❌ Error: archivo vacío" >&2
  exit 2
fi
