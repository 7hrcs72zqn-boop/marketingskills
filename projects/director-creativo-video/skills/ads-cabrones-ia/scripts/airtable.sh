#!/usr/bin/env bash
# airtable.sh — wrapper REST API de Airtable
#
# Subcomandos:
#   schema <baseId>                       → describe el schema completo
#   list <baseId> <tableId> [maxRecords]  → lista registros
#   upsert <baseId> <tableId> <jsonBody>  → upsert con merge en campos clave
#   create <baseId> <tableId> <jsonBody>  → crea registros (max 10)
#   update <baseId> <tableId> <recId> <fieldsJson> → actualiza un registro
#
# Variables de entorno:
#   AIRTABLE_PAT  (Personal Access Token con scopes de schema y data)
#
# Output: JSON crudo de la API. Parsea con jq según necesites.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
if [[ -f "$ROOT/../.env" ]]; then
  set -a; source "$ROOT/../.env"; set +a
fi

if [[ -z "${AIRTABLE_PAT:-}" ]]; then
  echo "❌ AIRTABLE_PAT no está configurada en .env" >&2
  exit 1
fi

API="https://api.airtable.com/v0"
META="https://api.airtable.com/v0/meta"

cmd="${1:?subcomando requerido (schema|list|upsert|create|update)}"
shift || true

case "$cmd" in
  schema)
    BASE="${1:?baseId requerido}"
    curl -sS \
      -H "Authorization: Bearer ${AIRTABLE_PAT}" \
      "${META}/bases/${BASE}/tables"
    ;;

  list)
    BASE="${1:?baseId requerido}"
    TABLE="${2:?tableId o tableName requerido}"
    MAX="${3:-100}"
    curl -sS -G \
      -H "Authorization: Bearer ${AIRTABLE_PAT}" \
      --data-urlencode "maxRecords=${MAX}" \
      "${API}/${BASE}/${TABLE}"
    ;;

  upsert)
    BASE="${1:?baseId requerido}"
    TABLE="${2:?tableId o tableName requerido}"
    BODY="${3:?json body requerido}"
    curl -sS -X PATCH \
      -H "Authorization: Bearer ${AIRTABLE_PAT}" \
      -H "Content-Type: application/json" \
      -d "$BODY" \
      "${API}/${BASE}/${TABLE}"
    ;;

  create)
    BASE="${1:?baseId requerido}"
    TABLE="${2:?tableId o tableName requerido}"
    BODY="${3:?json body requerido}"
    curl -sS -X POST \
      -H "Authorization: Bearer ${AIRTABLE_PAT}" \
      -H "Content-Type: application/json" \
      -d "$BODY" \
      "${API}/${BASE}/${TABLE}"
    ;;

  update)
    BASE="${1:?baseId requerido}"
    TABLE="${2:?tableId o tableName requerido}"
    REC="${3:?recordId requerido}"
    FIELDS="${4:?fields json requerido}"
    curl -sS -X PATCH \
      -H "Authorization: Bearer ${AIRTABLE_PAT}" \
      -H "Content-Type: application/json" \
      -d "{\"fields\": ${FIELDS}}" \
      "${API}/${BASE}/${TABLE}/${REC}"
    ;;

  create-table)
    # Crea una tabla con su schema completo
    BASE="${1:?baseId requerido}"
    BODY="${2:?table definition JSON requerido}"
    curl -sS -X POST \
      -H "Authorization: Bearer ${AIRTABLE_PAT}" \
      -H "Content-Type: application/json" \
      -d "$BODY" \
      "${META}/bases/${BASE}/tables"
    ;;

  attach)
    # Sube un archivo local como attachment a un campo existente
    # Uso: airtable.sh attach <baseId> <recordId> <fieldName> <filePath> [contentType]
    BASE="${1:?baseId requerido}"
    REC="${2:?recordId requerido}"
    FIELD="${3:?fieldName requerido}"
    FILE="${4:?filePath requerido}"
    CT="${5:-}"

    if [[ ! -f "$FILE" ]]; then
      echo "❌ Archivo no existe: $FILE" >&2
      exit 1
    fi

    # Adivinar content-type si no se pasa
    if [[ -z "$CT" ]]; then
      case "${FILE##*.}" in
        png) CT="image/png" ;;
        jpg|jpeg) CT="image/jpeg" ;;
        mp3) CT="audio/mpeg" ;;
        mp4) CT="video/mp4" ;;
        wav) CT="audio/wav" ;;
        *) CT="application/octet-stream" ;;
      esac
    fi

    FILENAME=$(basename "$FILE")
    B64=$(base64 < "$FILE" | tr -d '\n')

    # Endpoint content.airtable.com — base64 upload
    curl -sS -X POST \
      -H "Authorization: Bearer ${AIRTABLE_PAT}" \
      -H "Content-Type: application/json" \
      "https://content.airtable.com/v0/${BASE}/${REC}/${FIELD}/uploadAttachment" \
      -d @- <<JSON
{
  "contentType": "${CT}",
  "filename": "${FILENAME}",
  "file": "${B64}"
}
JSON
    ;;

  attach-url)
    # Adjunta un archivo desde una URL pública (típico para outputs Higgsfield)
    # Uso: airtable.sh attach-url <baseId> <tableId> <recordId> <fieldName> <url>
    BASE="${1:?baseId requerido}"
    TABLE="${2:?tableId requerido}"
    REC="${3:?recordId requerido}"
    FIELD="${4:?fieldName requerido}"
    URL="${5:?url requerido}"

    curl -sS -X PATCH \
      -H "Authorization: Bearer ${AIRTABLE_PAT}" \
      -H "Content-Type: application/json" \
      "${API}/${BASE}/${TABLE}/${REC}" \
      -d @- <<JSON
{
  "fields": {
    "${FIELD}": [{"url": "${URL}"}]
  }
}
JSON
    ;;

  download)
    # Descarga un attachment a local
    # Uso: airtable.sh download <attachmentUrl> <outputPath>
    URL="${1:?attachment url requerido}"
    OUT="${2:?output path requerido}"
    curl -sS -L "$URL" -o "$OUT"
    if [[ -s "$OUT" ]]; then
      echo "✅ Descargado: $OUT ($(wc -c < "$OUT" | tr -d ' ') bytes)"
    else
      echo "❌ Descarga vacía" >&2
      exit 2
    fi
    ;;

  *)
    echo "❌ Subcomando desconocido: $cmd" >&2
    echo "   Disponibles: schema, list, upsert, create, update, create-table," >&2
    echo "                attach, attach-url, download" >&2
    exit 1
    ;;
esac
