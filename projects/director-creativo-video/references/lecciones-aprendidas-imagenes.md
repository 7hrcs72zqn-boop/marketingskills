# Lecciones aprendidas — generación de imagen/video con gpt_image_2 (Higgsfield)

Errores recurrentes detectados en las escenas de procedimiento (Soe + clienta) y cómo evitarlos. Consultar antes de reusar el prompt de "Close-up beauty procedure scene".

## 1. El pen tool termina tatuando/tocando la FRENTE, no la ceja

**Síntoma:** el modelo dibuja o marca con tinta la frente de la clienta en vez de trabajar sobre la ceja, o posiciona la punta del pen tool sobre la frente.

**Fix obligatorio en el prompt:**
- Especificar colocación anatómica estricta: *"the pen tool tip is positioned EXACTLY at the eyebrow hair line, touching only the brow itself — NEVER on the forehead, NEVER above the brow on the smooth forehead skin."*
- Repetir en `Action` y en `Subject` que el tool trabaja "on the eyebrow (not the forehead)".

## 2. La imagen sale con el "tatuaje" ya hecho (marca de tinta visible)

**Síntoma:** el resultado muestra pigmento/tinta visible en la piel, como si el procedimiento ya estuviera terminado — no queremos eso, queremos una escena que **simule** el trabajo en proceso, sin marca real.

**Fix obligatorio en el prompt:**
- Aclarar explícitamente que es una acción simulada/mimada: *"This is a SIMULATED/mimed action shot — the pen tool touches the brow performing the motion of the technique, but deposits no ink and leaves no visible mark anywhere on the face."*
- Reforzar con negativos explícitos en `Refinements`: `no ink, no pigment marks, no tattoo`.
- Repetir "completely clean skin" / "unmarked" en `Composition` Y en `Action`.

## 3. La clienta termina pareciéndose a la especialista (caras mezcladas)

**Síntoma:** con solo 1 foto de referencia de la clienta, el modelo mezcla sus rasgos con los de Soe (la especialista).

**Fix:** usar 3+ fotos de referencia solo de la clienta (ángulos distintos), y en el prompt aclarar explícitamente qué imagen de referencia corresponde a cada persona: *"Reference image 1 is the SPECIALIST... Reference images 2-4 are the CLIENT... match the client's face specifically to these references, not to the specialist's face."*

## Plantilla base corregida (usar como punto de partida)

Ver el job `0b74f838-d28e-4961-8106-28550474cc5f` (gpt_image_2, quality low, 1k, 16:9) para el prompt completo ya corregido con los 3 fixes aplicados.
