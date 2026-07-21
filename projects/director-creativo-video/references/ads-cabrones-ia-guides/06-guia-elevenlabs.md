# 06 — Obtener API Key de ElevenLabs

> Tiempo estimado: **2 minutos**.

ElevenLabs genera el voiceover del comercial. Es el componente de voz más natural del mercado para narración cinematográfica multilingual.

## Paso 1 — Crear cuenta

1. Ve a [elevenlabs.io](https://elevenlabs.io)
2. **Sign up** con email o Google
3. Completa el onboarding (eliges idiomas favoritos, etc.)

## Paso 2 — Elegir plan

| Plan | Precio | Caracteres/mes | ¿Para qué te alcanza? |
|---|---|---|---|
| **Free** | $0 | 10,000 | ~50 ads de 200 chars cada uno |
| **Starter** | $5 | 30,000 | ~150 ads/mes, voz clonada custom |
| **Creator** | $22 | 100,000 | ~500 ads/mes, mejor calidad |

> **Para empezar**, el plan Free es suficiente. Si vas a producir muchos ads o quieres voz clonada propia, considera Starter.

## Paso 3 — Generar la API key

1. Ya logueado, ve a [elevenlabs.io/app/settings/api-keys](https://elevenlabs.io/app/settings/api-keys)
2. Click en **"Create API Key"**
3. Dale un nombre descriptivo (ej: `ads-cabrones-ia`)
4. **Copia la key inmediatamente** (formato: `sk_xxxxxxxxxxxxxxxx`)

⚠️ La key solo se muestra UNA VEZ. Si la pierdes, tienes que generar una nueva.

## Paso 4 — Pegarla en el wizard del skill

Cuando corras el onboarding, en la pregunta 3 ("ElevenLabs API Key") pegas la key completa. El wizard:
- Valida la key llamando al endpoint `/v1/voices`
- Cuenta cuántas voces tienes disponibles
- La guarda en `.env` con permisos 600

## Paso 5 — Elegir tu voice_id default

En la pregunta 5 del wizard, eliges qué voz usar por default. Opciones premade incluidas:

| Voice | Voice ID | Tipo |
|---|---|---|
| **Brian** ★ | `nPczCjzI2devNBz1zQrb` | Masculino, deep, narrador cinematográfico |
| **Bill** | `pqHfZKP75CvOlQylNhV4` | Masculino, wise, mature, balanced |
| **Sarah** | `EXAVITQu4vr4xnSDxMaL` | Femenina, mature, reassuring |
| **Daniel** | `onwK4e9ZLuTAKqWW03F9` | Masculino británico, broadcaster |

★ = recomendada para ads masculinos cinematográficos en español.

### Usar tu propia voz clonada

Si tienes Starter+ y clonaste tu voz:

1. Ve a [elevenlabs.io/app/voice-lab](https://elevenlabs.io/app/voice-lab)
2. Click en tu voz → copia el `voice_id`
3. En el wizard, elige "Otra" → pega tu `voice_id`

### Buscar voces en español nativas

Las premade son multilingual pero suenan con acento "anglo-mexicano". Si quieres voces nativamente en español:

1. Ve a [elevenlabs.io/app/voice-library](https://elevenlabs.io/app/voice-library)
2. Filter → **Spanish (Spain)** o **Spanish (Latin America)**
3. Escucha samples, encuentra una que te guste
4. Click **"Add to my voices"** para agregar a tu cuenta
5. Copia el `voice_id`
6. En el wizard, elige "Otra" → pega el `voice_id`

## Paso 6 — Verificar (opcional)

```bash
source .env
curl -sS -H "xi-api-key: $ELEVENLABS_API_KEY" \
  "https://api.elevenlabs.io/v1/voices" \
  | python3 -c "import json,sys; d=json.load(sys.stdin); print(f'{len(d[\"voices\"])} voces disponibles')"
```

Debería retornar `23 voces disponibles` (o el número que tengas en tu cuenta).

---

## Costos por ad

Un script típico de comercial 40s tiene ~250 caracteres. A precio de Starter:

```
30,000 chars / mes ÷ 250 chars/ad = 120 ads/mes
$5/mes ÷ 120 ads = $0.04 por ad
```

Insignificante comparado al costo de Higgsfield (~$3-4/ad).

---

## Voice cloning (avanzado)

Si quieres clonar tu propia voz (o la de un narrador profesional):

1. Plan Creator+ requerido
2. Graba 1-3 minutos de audio limpio (cabina, sin ruido)
3. Sube a Voice Lab
4. Espera ~10 minutos de entrenamiento
5. Listo — copia el `voice_id` y úsalo en el skill

> **Tip**: para ads de marca, una voz clonada del fundador o un narrador signature da identidad sonora consistente entre todos tus comerciales.

---

## Troubleshooting

### "401 Unauthorized"
API key inválida o caducada. Genera una nueva.

### "Voice not found"
El `voice_id` que pegaste no existe en tu cuenta. Verifica que lo copiaste completo (20 caracteres).

### "Quota exceeded"
Pasaste tu límite mensual de caracteres. Espera al ciclo siguiente o sube de plan.

### El audio sale con acento raro
- Usa voz multilingual (todas las premade lo son)
- O busca una voz nativa en Voice Library
- Para perfecto: clona tu voz o la de un narrador hispanohablante

---

## Próximo paso

Continúa con **[07-caso-estudio.md](07-caso-estudio.md)** para ver el sistema completo en acción, o vuelve al [README](README.md).
