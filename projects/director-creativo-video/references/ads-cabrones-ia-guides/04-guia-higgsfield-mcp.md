# 04 — Conectar Higgsfield MCP

> Tiempo estimado: **2 minutos**.

Higgsfield es el motor que genera las imágenes (GPT Image 2) y los videos (Seedance 2.0) del skill. Se conecta a Claude Code vía MCP.

## Paso 1 — Crear cuenta en Higgsfield

1. Ve a [higgsfield.ai](https://higgsfield.ai)
2. Crea una cuenta o inicia sesión
3. Asegúrate de tener un plan **Plus** o superior (Free no incluye créditos suficientes para ads completos)

> **Por qué Plus**: un anuncio típico (4 escenas, 8 imágenes 2k + 4 videos 8s) consume ~160 créditos. Free no alcanza.

## Paso 2 — Conectar el MCP a Claude Code

Higgsfield ofrece un MCP oficial. Sigue las instrucciones en:

👉 **[https://higgsfield.ai/mcp](https://higgsfield.ai/mcp)**

Resumen del flujo (puede variar según la docs oficial):

1. En tu cuenta Higgsfield, generas un token o copias el comando de instalación
2. Ejecutas en tu terminal:
   ```bash
   claude mcp add --transport http higgsfield https://mcp.higgsfield.ai/mcp \
     --header "Authorization: Bearer <tu_token>"
   ```
3. Reinicias Claude Code
4. Ejecutas `/mcp` y autorizas si pide OAuth

## Paso 3 — Verificar la conexión

Abre Claude Code y ejecuta:

```
> mcp__higgsfield__balance
```

Deberías ver algo como:

```json
{
  "email": "tu@email.com",
  "credits": 600,
  "subscription_plan_type": "plus"
}
```

✅ Si ves créditos → el MCP está conectado y funcional.

❌ Si ves un error → revisa las instrucciones oficiales o reportalo en el canal de la comunidad.

## Paso 4 — Tips de uso

### Cuántos créditos por ad

Promedio para un ad de 4 escenas, 16:9, 720p:

| Recurso | Cantidad | Créditos aprox |
|---|---|---|
| Imágenes gpt_image_2 quality=high 2k | 8 | ~80 |
| Videos seedance_2_0 720p 8s | 4 | ~110 |
| **Total** | | **~190 créditos** |

Si tu plan Plus te da 600 créditos/mes, eso son **~3 ads completos** por mes. Si necesitas más, considera:

- Plan superior con más créditos
- Bajar `quality` de imágenes a `medium` (~50% del costo)
- Bajar `resolution` de videos a 480p si no es para uso final

### Modelos que usa el skill

- **`gpt_image_2`** (OpenAI vía Higgsfield) — imágenes con quality=high, resolution=2k
- **`seedance_2_0`** (Bytedance vía Higgsfield) — videos con start+end frames, 720p, 8s

Ambos están disponibles en plan Plus.

### Gestión de créditos

Antes de cada ad, el skill verifica `mcp__higgsfield__balance` y avisa si tienes <200 créditos. Si pasa eso, recarga antes de continuar.

---

## Troubleshooting

### "MCP not connected"
- Verifica que copiaste el comando exacto de la doc oficial
- Reinicia Claude Code después de instalar
- Ejecuta `claude mcp list` para ver el estado

### "Insufficient credits"
- Recarga en tu cuenta de Higgsfield
- O sube de plan

### "Model not available"
- Tu plan no incluye GPT Image 2 o Seedance 2.0
- Contacta soporte de Higgsfield para verificar tu plan

---

## Próximo paso

Continúa con **[05-guia-airtable-pat.md](05-guia-airtable-pat.md)** o vuelve al [README](README.md).
