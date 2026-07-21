# 05 — Generar Personal Access Token de Airtable

> Tiempo estimado: **3 minutos**.

El skill usa la **REST API oficial de Airtable** (no el MCP), por lo que necesita un Personal Access Token (PAT) con scopes específicos.

## Paso 1 — Crear el token

1. Inicia sesión en [airtable.com](https://airtable.com)
2. Ve a [airtable.com/create/tokens](https://airtable.com/create/tokens)
3. Click en **"Create new token"**

## Paso 2 — Configurar el token

### Nombre del token
Algo descriptivo, ej: `ads-cabrones-ia` o `claude-code-ads`.

### Scopes (permisos)

**OBLIGATORIOS** — marca estos 4:

- ✅ `data.records:read`
- ✅ `data.records:write`
- ✅ `schema.bases:read`
- ✅ `schema.bases:write`

**Opcionales pero recomendados**:
- `workspacesAndBases:read` — útil para que el wizard pueda listar tus workspaces al crear bases nuevas

### Acceso a bases

Aquí es donde controlas a qué bases puede acceder el token.

**Opción A — Acceso a TODAS tus bases**:
- Selecciona "All bases in workspace [tu workspace]"
- Más permisivo, pero más cómodo si vas a usar el skill con varias bases

**Opción B — Acceso solo a la base del skill**:
- Si ya creaste la base manualmente (ver [03-airtable-template.md](03-airtable-template.md))
- Selecciona solo esa base
- Más restrictivo y seguro

> **Tip**: si no creaste la base aún y vas a usar el wizard para crearla automáticamente, necesitas la Opción A (acceso a todo el workspace).

## Paso 3 — Crear y copiar el token

1. Click en **"Create token"**
2. Airtable muestra el token UNA SOLA VEZ
3. **Cópialo inmediatamente** y guárdalo en un password manager o lugar seguro

> ⚠️ Si pierdes el token, debes crear uno nuevo (no se puede recuperar).

## Paso 4 — Pegarlo en el wizard del skill

Cuando corras el onboarding, en la pregunta 4 ("Airtable Personal Access Token"), pegas el token completo. El wizard:
- Lo valida llamando al API
- Lo guarda en `.env` con permisos 600 (solo tú lo lees)

## Paso 5 — Verificar

Si quieres verificar manualmente que el token funciona:

```bash
# En tu terminal, dentro del proyecto donde corriste el wizard
source .env
curl -sS -H "Authorization: Bearer $AIRTABLE_PAT" \
  "https://api.airtable.com/v0/meta/whoami" | python3 -m json.tool
```

Debería retornar:
```json
{
  "id": "usrXXXXXXXXX",
  "email": "tu@email.com"
}
```

✅ Si ves tu email → el token funciona.

---

## Rotar el token (cuando convenga)

**Cuándo rotar**:
- Crees que se filtró en algún log o screenshot
- Pasaron 6+ meses (buena práctica)
- Cambias de proyecto/marca y quieres tokens separados

**Cómo rotar**:
1. Ve a [airtable.com/create/tokens](https://airtable.com/create/tokens)
2. Click en el token actual → "Regenerate" o "Delete"
3. Crea uno nuevo con los mismos scopes
4. Re-corre el wizard del skill: `~/.claude/skills/ads-cabrones-ia/scripts/setup.sh --reset`

---

## Troubleshooting

### "401 Unauthorized"
- Token inválido o expirado → genera uno nuevo
- O scopes insuficientes → edita el token y agrega los scopes faltantes

### "403 Forbidden — base not accessible"
- El token no tiene acceso al workspace de la base
- Edita el token y agrega el workspace

### "Token has insufficient scopes"
- Te falta `schema.bases:write` (necesario para que el wizard cree bases nuevas)
- O `data.records:write` (necesario para guardar proyectos)
- Edita el token y marca los scopes correctos

---

## Próximo paso

Continúa con **[06-guia-elevenlabs.md](06-guia-elevenlabs.md)** o vuelve al [README](README.md).
