---
name: automatizacion-contenido-ia-claude-higgsfield
description: "Pipeline para generar campañas completas de fotos y videos de producto/moda con IA (Claude Code + Higgsfield CLI + Nano Banana Pro + Seedance 2.0) que aprende y mejora con cada ronda de feedback."
version: 1.0.0
author: Soe Macero + Claude
tags: [ia-generativa, video-ia, imagen-ia, automatizacion, claude-code, higgsfield, marketing-de-producto, contenido-a-escala]
---

# Automatización de Contenido con IA (Claude x Higgsfield)

> ⚠️ **[NOTA]**: Este skill se construyó a partir de la transcripción de audio completa del video (https://youtu.be/FQqkDXq1WEQ, ~66 min, canal GenHQ / Roe Keith). **No pude acceder a la herramienta de análisis visual del video** (el MCP de YouTube requería una aprobación que no está disponible en esta sesión), así que el contenido de pantalla que aparece aquí fue **reconstruido a partir de lo que el instructor narra mientras señala/lee la pantalla** — en este video en particular el instructor lee casi todo textualmente, lo cual ayuda mucho, pero cualquier detalle que NO haya sido dictado en voz alta (colores exactos del UI, orden pixel-perfecto de carpetas, fuente/tipografía, etc.) está marcado como ⭐ [SOLO VISUAL] y NO pudo capturarse. Si necesitas esos detalles exactos, hay que volver a ver el video o reintentar la herramienta visual.

---

## OBJETIVO

Resuelve el problema de **producir contenido de marketing (fotos y video de producto/moda) a escala, con estilo consistente, sin contratar un equipo de producción**, usando Claude (Desktop o Code) como orquestador y Higgsfield (CLI, no MCP) como motor de generación de imagen/video.

Es para: agencias de marketing, marcas de e-commerce/moda, y creadores que necesitan volumen de creativos (para Meta Ads, redes sociales, etc.) sin sacrificar "buen gusto" visual.

Al final tendrás un **sistema de generación de contenido semi-autónomo y autoaprendiz**: le das a Claude acceso a una carpeta con tus referencias (entornos, modelos, productos), Claude genera lotes de imágenes/videos vía Higgsfield, tú das feedback (aprobado/rechazado + nota) en una hoja de cálculo, y Claude usa ese historial para mejorar las siguientes generaciones. El instructor afirma tener **160 anuncios corriendo en Meta Ads**, generados de la noche a la mañana, usando este método.

---

## NIVEL

Intermedio. No requiere saber programar, pero sí instalar software vía terminal y seguir instrucciones técnicas paso a paso (el propio instructor se declara "no técnico" y lo logra).

---

## PRERREQUISITOS

- **Claude Desktop app** o **Claude Code** instalado. [AUDIO 2:43-2:51] "lo que vamos a usar en el video de hoy es realmente el CLI en la app de escritorio de Claude... necesitas tener la app de Claude Desktop instalada."
- Una cuenta de **Higgsfield** (plataforma de generación de imagen/video con los modelos Nano Banana Pro y Seedance 2.0).
- Acceso a una **Terminal** (macOS o Windows) para poder pegar el comando de instalación con contraseña de administrador si Claude no puede ejecutarlo directamente con `sudo`.
- (Opcional pero recomendado) **Google Sheets + Google CLI conectado a Claude** — el instructor aclara que esto es un setup aparte de 30-40 minutos, "hazlo una vez y es para siempre" [AUDIO 42:22-42:26, 42:52-43:07]. ⭐ [SOLO VISUAL] no pude capturar el enlace exacto al tutorial que menciona ("dejaré un link en la descripción").
- (Opcional) **WhisperFlow** — app de dictado por voz que el instructor usa para escribir prompts más rápido (139 ppm hablando vs. 79 ppm escribiendo) [AUDIO 23:26-23:49].
- Imágenes de referencia propias: al menos un set de "entornos" (fondos/escenarios), un "character sheet" por modelo/personaje, y "product sheets" (fotos del producto desde todos los ángulos).
- Créditos/plan de pago en Higgsfield — el plan "Creator" tiene un límite de **8 jobs de Seedance concurrentes** (ver Errores Comunes).

---

## CONCEPTOS CLAVE

- **CLI (Command Line Interface)**: a diferencia de un MCP, corre comandos directamente en tu máquina local, por lo que SÍ puede leer archivos de tu disco y subirlos como referencia — un MCP normal no puede subir imágenes de referencia. [AUDIO 3:02-3:30]
- **MCP**: en este flujo, Higgsfield también ofrece un MCP, pero el instructor insiste: **"asegúrate de estar en la opción CLI, no instales el MCP"** [AUDIO 6:00-6:05].
- **Nano Banana Pro**: modelo de generación de **imagen** usado en este flujo.
- **Seedance 2.0**: modelo de generación de **video** usado en este flujo.
- **UUID (Universal Unique Identifier)**: cada vez que subes una imagen como referencia a Higgsfield, el servidor la codifica en un identificador único (ej. `B43D...`) almacenado en la nube de Higgsfield. Claude usa este UUID —no el archivo en sí— como referencia de imagen en los prompts. Es "lo más importante de toda esta investigación" según el instructor [AUDIO 12:57-13:06, 16:05-16:10]. Cada usuario tiene sus propios UUIDs protegidos; nadie puede acceder a los de otro usuario [AUDIO 15:29-15:51].
- **Batch (lote)**: una sola corrida de generación, ej. "genera 30 imágenes" o "genera 10 videos" cuenta como **un batch** [AUDIO 24:19-24:30].
- **Environment reference / Environment descriptor**: carpeta de imágenes de entornos/escenarios + un archivo `.md` que describe cada imagen en texto, para que el modelo pueda variar la composición sin quedar "esclavizado" a la foto literal del entorno [AUDIO 11:25-11:53].
- **Character sheet / Trainer sheet (sneaker sheet)**: hoja de referencia con todos los ángulos de un personaje/modelo o de un producto específico (ej. el tenis), para mantener consistencia visual.
- **Detail / Editorial images**: fotos de estilo editorial ya elaboradas (no "hojas de referencia" limpias). **Regla crítica**: Seedance las copia como un frame literal dentro del video de salida si se usan como referencia — por eso NUNCA deben usarse como referencia de producto/personaje [AUDIO 30:52-31:21].
- **Handoff document**: documento maestro que resume overview del proyecto, cuentas conectadas, modelos a usar, UUIDs maestros de cada referencia, y las reglas — pensado para que cualquier persona (o el propio Claude en una sesión nueva) retome el proyecto sin perder contexto.
- **Prompt log**: archivo `.md` que registra el texto completo de cada prompt usado en cada generación, por batch.
- **Reference IDs file**: archivo `.md` separado que solo trackea UUID + nombre de archivo de cada referencia subida.
- **Seedance prompt failure log**: bitácora viva de generaciones rechazadas/bloqueadas por guidelines, con la causa raíz y una recomendación para no repetir el error.
- **Image/Video feedback tracker**: hoja de cálculo (CSV/Google Sheets) donde cada imagen o video generado queda registrado con su UUID, prompt, y un estado: **aprobado (verde) / rechazado (rojo) / pendiente (amarillo)**, más una columna de notas. Este es el mecanismo de "autoaprendizaje": Claude lee este archivo antes de la siguiente generación.
- **Routines**: automatizaciones programadas (ej. "a las 6am, antes de que llegue a mi escritorio, genera X videos e imágenes y ponlos en el spreadsheet") [AUDIO 59:23-59:50].

---

## PASO A PASO

### Paso 1 — Instalar la Higgsfield CLI (no el MCP)
1. Ve al sitio de Higgsfield y busca la sección **"New MCP and CLI"**.
2. Asegúrate de seleccionar la opción **CLI** (no el MCP). [AUDIO 5:54-6:05]
3. Copia el comando de instalación que te da la página.
4. Pégalo directamente en el prompt de **Claude Code**.
5. Si Claude te ofrece opciones de instalación y una falla pidiendo contraseña ("run with sudo" da error porque necesita password), **abre tu Terminal directamente**, pega el mismo comando ahí, escribe la contraseña de tu laptop, y espera a que termine. [AUDIO 6:35-7:03]
6. Vuelve a Claude y dile que ya terminaste ("dile a Claude que hemos terminado").
7. **Cómo validar que funcionó**: Claude/la terminal debe mostrar `installed Higgsfield ... is on your path` (y en la instalación por terminal, un mensaje tipo "added 1 package"). [AUDIO 7:27-7:34]

### Paso 2 — Iniciar sesión (sign in)
1. Copia el comando de "sign in" de la página de Higgsfield.
2. Pégalo en Claude.
3. Se abrirá automáticamente una ventana emergente en el navegador — haz clic en **Connect**.
4. **Cómo validar**: la ventana debe mostrar el mensaje **"device authorized"**. Cierra esa pestaña. [AUDIO 7:47-8:15]

### Paso 3 — Instalar los skills de Higgsfield en tu agente
1. Copia el tercer comando ("plug the skills into your agent") y pégalo en el prompt de Claude.
2. Esto instala 4 skills pre-construidos: `Higgsfield generate`, `Higgsfield marketplace cards`, `Higgsfield product photo shoot`, `Higgsfield soul ID`.
3. El más importante para este flujo es **Higgsfield generate**, que permite generar imágenes/video directamente dentro del chat de Claude sin salir a la web de Higgsfield. [AUDIO 8:18-8:51]
4. **Cómo validar**: deberías poder pedirle a Claude que genere una imagen de prueba y que responda usando las herramientas de Higgsfield (no un error de "herramienta no encontrada").

### Paso 4 — Crear tu carpeta plantilla local y dársela a Claude
1. Crea una carpeta local (el instructor la llama **"Claude x GenHQ automation"**).
2. En Claude, haz clic en el botón **+** y elige **Add folder** (agregar carpeta), y selecciona esta carpeta. [AUDIO 25:44-25:59]
3. Dentro de esta carpeta plantilla vas a construir la siguiente estructura (ver detalle abajo). ⭐ [SOLO VISUAL] el orden exacto de carpetas en el explorador de archivos no se puede confirmar sin ver pantalla; el orden aquí sigue el orden en que el instructor las explica:
   ```
   Claude x GenHQ automation/
   ├── environment-references/       (imágenes de entornos + .md descriptor)
   ├── model-references/             (character sheets + product sheets de ropa/accesorios)
   ├── product-references/           (fotos del producto principal, ej. el perfume)
   ├── outputs/                      (carpeta vacía — aquí Claude guarda lo generado)
   ├── prompt-log.md
   ├── reference-ids.md
   ├── seedance-prompt-failure-log.md
   ├── seedance-prompt-foundations.md   (el "framework" de 2+ años de prompting)
   └── handoff.md                    (overview + reglas + UUIDs maestros)
   ```

### Paso 5 — Crear las referencias de entorno + su descriptor
1. Sube **18 imágenes** (o las que tengas) de entornos/escenarios a la subcarpeta `environment-references/`. En el video son entornos "outerworldly", volcánicos, generados con Midjourney. [AUDIO 9:46-10:18]
2. Súbelas a Claude y pide textualmente algo como:
   > *"Create a .md file for me where it writes out a description of each of the [N] images."* [AUDIO 12:34-12:40]
3. Además, instruye a Claude para que **suba cada imagen como referencia a Higgsfield y extraiga su UUID**, y que anote en el mismo `.md`: título, descripción de texto, UUID, y **cuándo usar el prompt de texto vs. la imagen como referencia**. [AUDIO 17:01-18:35]
4. **Cómo validar**: el archivo `.md` resultante debe tener, para cada imagen, un bloque con UUID + título + descripción de texto (según el instructor, así se ve el archivo terminado en su proyecto).

### Paso 6 — Crear las referencias de modelo/personaje y de producto (ropa/accesorios)
1. Sube a `model-references/`: un **character sheet** por modelo, más fotos de detalle de la ropa que porta (logos, bordados, etc.), y "product sheets" de accesorios (ej. tenis).
2. Para generar un **product sheet** desde cero con Nano Banana Pro, el prompt exacto que usa el instructor es:
   > **[PANTALLA/AUDIO 19:58-20:07]**: *"White background, create a product sheet that covers all of the angles of this product. Create six separate images all inside of one photo."*
3. Sube las imágenes a Claude y pide (ejemplo dictado literal del instructor vía WhisperFlow):
   > **[AUDIO 22:30-23:20]**: *"Create me a description of each of the models. It should have a subject focus with a short description of the subject. It should also have an outfit description with a detailed description of the outfit. And then I would also like you to upload each of the images into Higgs Field as a reference and pull out the UUIDs and label each of those with each of the files so that you have an understanding of the UUID that is connected with each of these files... Do the same with both of the two models. Make sure you include the subject, the outfit, and also the image references that belong to each of those subjects, and make sure you pull out the UUIDs."*
4. **Cómo validar**: obtienes un `.md` (el instructor lo guarda como algo tipo "model description") con: subject + outfit description + UUIDs de cada imagen, por cada modelo.

### Paso 7 — Crear las referencias de producto principal
1. Sube fotos del producto principal (en el ejemplo, un perfume) en ángulos: **frente, lado, espalda, perspectiva, abajo, arriba, detalle de la tapa**. [AUDIO 21:08-21:16]
2. Añade descriptores de material/propiedades físicas en texto — el instructor recomienda esto explícitamente:
   > **[AUDIO 21:16-21:38]**: descripción de que la botella "está hecha de obsidiana... el obsidiana es brillante por naturaleza, así que queremos que la luz se refracte en la botella." **Consejo**: incluir siempre notas de reflexión/iluminación del material — "realmente ayudó en los resultados finales".

### Paso 8 — Crear el prompt log
1. Da acceso a Claude a toda la carpeta (botón **+ > Add folder**, selecciona tu carpeta de descargas/proyecto).
2. Pide (prompt casi literal del instructor):
   > **[AUDIO 25:43-26:20]**: *"Go and create a .md file that will store all of your prompts that you do for image and video generation... make sure you keep an active log of every single image that we generate and make sure you're keeping a safe record of all of those in a .md file and update it every single time we do a generation."*
3. **Cómo validar**: el archivo debe mostrar, por cada shot generado, el prompt completo tal cual se envió al modelo.

### Paso 9 — Crear el archivo de Reference IDs (UUIDs)
1. Pide a Claude:
   > **[AUDIO 27:15-27:44]**: *"Add a .md file inside here that tracks all of the UUIDs and makes a note of them with the file name next to it, so that you can reference it later on."*
2. **Cómo validar**: archivo simple de tabla/lista UUID ↔ nombre de archivo.

### Paso 10 — Escribir las reglas (Rules)
Instruye explícitamente estas reglas (puedes copiarlas casi tal cual):
> **[AUDIO 30:25-31:29, cita textual reconstruida]**: *"Rule: character sheet plus trainer sheet only. Never use detail/editorial images as a reference. Detail images... are styled editorial shots — Seedance copies them as a literal frame into the video output [si se usan como referencia]."*

Además, si tienes **varios personajes con distintos productos asociados** (ej. modelo A siempre con el tenis X, modelo B siempre con el tenis Y), agrega reglas de asociación explícitas: *"si usas el personaje A, debes usar el archivo [tenis X] como referencia de calzado; si usas el personaje B, debes usar [tenis Y]."* [AUDIO 31:45-32:34]

### Paso 11 — Crear el Handoff document
Pide a Claude que cree un documento con:
- **Project overview** (ej. *"Automated fashion editorial campaign set entirely in volcanic environments"*)
- Confirmación de que tiene acceso a la cuenta correcta y a la CLI
- Lista de modelos a usar (personajes + outfits)
- **Master log**: UUIDs de modelo 1, modelo 2, trainer sheet, producto — todos en un solo lugar
- Las reglas del Paso 10

> **[AUDIO 37:23-38:16]**: descripción completa de qué debe contener el handoff.

### Paso 12 — Crear el archivo de prompting framework (Seedance/Nano Banana)
Este es "la mina de oro" — el instructor advierte que en este archivo se condensan **2 años de experiencia de prompting**. Si empiezas desde cero, ve documentando aquí tu propia estructura de prompt ganadora (qué funciona para movimiento de cámara, duración, iluminación, etc.) a medida que iteras. [AUDIO 32:43-33:04] ⭐ [SOLO VISUAL] el contenido línea por línea de este archivo específico no se transcribió en audio — el instructor solo lo señala en pantalla sin leerlo textualmente completo.

### Paso 13 — Crear el Seedance Prompt Failure Log
Pide a Claude:
> **[AUDIO 34:31-34:56]**: *"Create a .md file that constantly analyzes all of our Seedance prompts and keeps a note of any failures or rejections from our prompts. For example, if the community guidelines rejects our videos, I want you to make a log of it and then make recommendations so that we can fix it in the future."*

**Cómo validar**: cuando algo falle, el archivo debe registrar timestamp, prompt verbatim, UUID, y la razón/lección aprendida (ver ejemplo real en Errores Comunes #2).

### Paso 14 — Crear la carpeta `outputs`
Simplemente crea una carpeta vacía llamada `outputs` — ahí Claude descargará y organizará todo lo generado. [AUDIO 39:09-39:14]

### Paso 15 — Crear la base de datos / feedback tracker (CSV → Google Sheets)
Pide a Claude (prompt casi literal):
> **[AUDIO 40:19-41:34]**: *"Create a .csv file with Google Sheets where we upload each of the images as a reference with the UUID attached to it and the file name, and then we can have a column that also has the status, which is either red for rejected, green for approved, or yellow for pending approval. And I should be able to click on them and toggle it... Additionally I'd like a note section so I can provide feedback on images and videos, and it might be worth separating those into two separate pages for images and videos."*

Para importarlo en Google Sheets: pestaña nueva → **Google Sheets → File → Import → Upload → Browse** → selecciona tu archivo → doble clic para importarlo. [AUDIO 43:48-44:17]

**Columnas confirmadas por audio** (por cada entrada de video, tal como las lee el instructor): prompt completo, UUIDs de referencia, nombre(s) de archivo, ruta local de descarga, duración, aspect ratio, **status** (aprobado/rechazado/pendiente), **notas**. [AUDIO 48:31-49:16, 80-81 del transcript]

### Paso 16 — (Opcional, recomendado) Conectar Google CLI a Claude para auto-actualizar la hoja
Si no lo haces, tendrás que reimportar el CSV manualmente cada vez. Con la conexión activa, simplemente instruye:
> **[AUDIO 52:52-53:13]**: *"I want you to take the image feedback tracker and live update our Google Sheets document in here every time a new generation happens. You can use the Google CLI to connect this together. Make sure that we automatically update whenever we do an image or video generation."*

### Paso 17 — Generar tu primer batch de prueba (video)
Prompt de ejemplo (casi literal):
> **[AUDIO 45:13-46:29]**: *"I would like you to create 10 videos with Sea Dance 2.0, of model one and model two, all inside of environment 16. And I would like it to be dynamic camera motions and controls, where we have unique camera angles. I would like you to come up with your own ideas for this. The videos should be 15 seconds long, and the aspect ratio should be 16 by 9."*

Refinamiento adicional en el mismo turno:
> **[AUDIO 46:29-47:13]**: *"Let's make sure that we also use the product of the perfume bottle product sheet reference as well. I would like them to be running together, and then they find the perfume bottle in different places inside of this environment, and then there is an end screen at the end of the video, which has the branding of the perfume bottle seamlessly transitioned at the end of the video. Let's have no music and just raw sound effects."*

**Cómo validar que salió bien**: Claude debe mostrar que está leyendo el descriptor de entorno, inspeccionando los UUIDs de producto, aplicando el "framework" de prompts de Seedance, confirmando el modelo (Seedance 2.0) y el costo en créditos antes de correr. Al terminar, el prompt-log y el reference-ids deben actualizarse, y el tracker debe mostrar las 10 entradas con status "pending".

### Paso 18 — Dar feedback y cerrar el loop de aprendizaje
1. Abre el Google Sheet, revisa cada imagen/video.
2. Cambia el status con el dropdown: **Approved / Rejected / Pending**.
3. En rechazados, escribe una nota específica y accionable, ejemplo real del instructor:
   > **[AUDIO 55:51-56:18]**: *"Rejected — the proportions of the product is too large in comparison to the models."*
4. La próxima vez que generes contenido, Claude lee este archivo y ajusta — "aprenderá con el tiempo si la calidad del contenido es buena o mala." [AUDIO 5:36-5:43]

### Paso 19 — Escalar: generar imágenes en batch con variaciones de estilo
Prompt de ejemplo (literal):
> **[AUDIO 58:11-59:12]**: *"Use environment 15 and I would like you to generate 30 images where 15 of them are noir and highly editorial and then I would like 15 motion blur artistic images. I would like them from unique camera angles where depth is really being displayed. Play a lot with blur on the images with things in the foreground and also in the background, and I would also like you to reference and create a couple of close-up product shots of the perfume bottle that is being held by model number two. All of these images should use model number two only. Let's create these images in 9 by 16 aspect ratio so I can use them on my social media story."*

### Paso 20 — (Avanzado) Automatizar con Routines
Configura una rutina programada, ejemplo:
> **[AUDIO 59:23-59:50]**: *"At 6:00 a.m. before I get to my desk, I want you to go and generate X number of videos, X number of images, and review them all, and put them all into the spreadsheet for me so that when I sit down at my desk by 9:00 a.m., all of these images and videos are pre-prepared and ready for me to review."*

---

## EJEMPLOS PRÁCTICOS

### Ejemplo 1 — Batch de 10 videos de producto (perfume + 2 modelos)
- **Input (prompt a Claude)**: ver Paso 17 completo.
- **Output real reportado en el video**: de 10 jobs solicitados, **8 terminaron bien y 1 falló una vez sin razón aparente** (reenviado automáticamente con nuevo ID). El tracker quedó con las 10 entradas, prompts completos, UUIDs de referencia, status "pending" y columna de URL. Los videos mostraban: dos personajes corriendo juntos, descubriendo la botella de perfume en el entorno, con transición a pantalla final de marca. El instructor calificó varios como "sick"/excelentes, pero notó que **las pantallas finales (end screens) necesitaban más iteración** — a veces "alucinaban" el diseño de marca. [AUDIO 47:57-51:11]
- **Explicación**: esto demuestra el ciclo completo: prompt detallado → generación batch → auto-log de fallos → tracker poblado → revisión humana.

### Ejemplo 2 — Batch de 30 imágenes con dos estilos + product shots
- **Input**: ver Paso 19 completo (15 noir/editorial + 15 motion blur + close-ups de producto, formato 9:16).
- **Output reportado**: 30 imágenes generadas y cargadas automáticamente al tracker con prompt, modelo usado, y links. El instructor las califica como "de calidad editorial/Pinterest", muy superiores a "el output genérico que solía dar la IA". [AUDIO 1:05:01-1:06:15]
- **Explicación**: muestra cómo variar el `aspect ratio` (9:16 para redes vs. 16:9 para video horizontal) y combinar dos estilos distintos dentro del mismo batch instruction.

### Ejemplo 3 (bonus, mencionado pero no ejecutado en pantalla) — Generación sin referencia de entorno
El instructor cuenta que en una corrida anterior **olvidó** especificar qué entorno usar, y Claude/Seedance generaron sus propios entornos originales — resultados que calificó como "sorprendentemente geniales" y útiles como **fuente de inspiración/conceptos** para nuevas campañas. **Truco derivado**: pedir explícitamente a Claude *"genera 30 conceptos editoriales/cinematográficos distintos"* sin darle referencia de entorno, para explorar direcciones creativas nuevas. [AUDIO 1:02:40-1:03:51]

---

## TRUCOS DEL INSTRUCTOR

- **"MCPs don't allow you to upload a reference image into a tool like Higgsfield... but a CLI does."** — la razón real por la que todo el flujo exige usar la CLI y no el MCP. [AUDIO 3:19-3:30]
- Usa **WhisperFlow** para dictar en vez de escribir: 139 palabras/min hablando vs. 79 escribiendo — "prácticamente ya no escribo". [AUDIO 23:26-23:49]
- **No cargues fotos "editoriales/detail" como referencia de producto o personaje** — Seedance las clona como frame literal del video. Usa siempre la "sheet" limpia (character sheet / product sheet). [AUDIO 30:52-31:29]
- Da **descriptores de material** (ej. "obsidiana, brillante, refracta la luz") en los product sheets — mejora notablemente el resultado final. [AUDIO 21:16-21:38]
- Si tienes personajes/productos complejos que deben mantenerse "bloqueados" (outfit completo, calzado específico), escribe reglas explícitas de asociación personaje↔producto para que Claude no los mezcle. [AUDIO 31:45-32:41]
- **Corre generaciones durante la noche** — puedes lanzar un batch grande y revisarlo al día siguiente. [AUDIO 59:17-59:20]
- Usa **Routines** para automatizar la generación matutina antes de sentarte a trabajar. [AUDIO 59:23-59:50]
- Una vez conectado Google/Gmail/Calendar a Claude, puedes ir más allá: pedirle que **redacte emails de outreach personalizados** citando contenido aprobado, e incluso que haga **investigación profunda sobre los prospectos** antes de escribirles. [AUDIO 57:00-57:24]
- Cita clave sobre la filosofía del sistema: **"Volume is going to be a huge thing. Learning to create taste with volume is going to be massive... it's your taste — you're the one who has to provide good references."** [AUDIO 59:56-1:00:29] — el sistema escala volumen, pero el gusto/dirección creativa la sigues aportando tú vía las referencias y el feedback.
- Si Seedance no te da un entorno de referencia, puede inventar los suyos — úsalo deliberadamente como generador de conceptos/moodboard. [AUDIO 1:02:40-1:03:51]

---

## ERRORES COMUNES Y SOLUCIÓN

1. **Síntoma**: Al pedirle a Claude que instale la CLI con `sudo`, responde que no puede porque necesita contraseña.
   **Causa**: Claude Code no puede escribir la contraseña de tu sistema por ti dentro del chat.
   **Solución**: copia el mismo comando y pégalo directamente en tu **Terminal** del sistema (no en Claude), escribe tu contraseña ahí, espera el mensaje de instalación exitosa, y luego dile a Claude que ya terminaste. [AUDIO 6:44-7:03]

2. **Síntoma**: Un job de generación de video falla sin ningún mensaje de error claro ("failed once with no reason given, Seedance backend").
   **Causa**: el plan **Creator** de Higgsfield limita a **8 jobs de Seedance concurrentes** — al pedir 10 a la vez, uno se cae.
   **Solución**: Claude reenvía automáticamente el job con un nuevo ID y lo registra en el failure log con la recomendación explícita: **"chunk batches as six generations at a time"** (dividir los lotes en tandas de 6). [AUDIO 47:54-48:28]

3. **Síntoma**: Un video es rechazado por "community guidelines" sin que quede claro por qué.
   **Causa**: alguna palabra/verbiaje específico del prompt disparó el filtro de moderación (ej. términos de "gore" en una escena de horror).
   **Solución**: el Seedance failure log queda registrando el prompt exacto + motivo, para que Claude evite ese verbiaje en futuros prompts similares — es un ciclo de autoaprendizaje del propio sistema, no algo que arreglas manualmente cada vez. [AUDIO 34:56-35:51]

4. **Síntoma**: La hoja de Google Sheets (feedback tracker) no se actualiza sola después de generar contenido nuevo.
   **Causa**: la conexión Google CLI ↔ Claude no está configurada todavía — sin ella, Claude solo puede escribir el CSV local, no empujarlo en vivo a Sheets.
   **Solución**: (a) mientras tanto, reimporta el CSV manualmente vía **File → Import → Upload** cada vez, o (b) completa el setup de Google CLI (única vez, ~30-40 min) y luego pide explícitamente a Claude: *"live update our Google Sheets document... every time a new generation happens... using the Google CLI."* [AUDIO 52:26-53:13]

5. **Síntoma**: Los videos generados copian literalmente la pose/encuadre de una foto de referencia en vez de solo tomar el "estilo".
   **Causa**: se usó una foto **editorial/detail** (no una "sheet" limpia) como referencia de personaje o producto; Seedance la trata como un frame exacto a reproducir.
   **Solución**: agrega/refuerza la regla — usar **solo** character sheet + product/trainer sheet como referencia, nunca fotos editoriales. [AUDIO 30:52-31:29]

6. **Síntoma**: El producto se ve desproporcionado (ej. muy grande) respecto al modelo en la imagen/video final.
   **Causa**: falta de guía explícita de escala/proporción en el prompt o en el product sheet.
   **Solución**: márcalo como **Rejected** en el tracker con una nota concreta (ej. *"the proportions of the product is too large in comparison to the models"*), para que quede registrado y las siguientes generaciones lo corrijan; considera añadir descriptores de escala al `.md` del product sheet. [AUDIO 55:51-56:18]

7. **Síntoma**: Las pantallas finales (end screens) con el logo de marca se ven mal o inconsistentes ("hallucinating a little bit").
   **Causa**: la instrucción sobre el end screen es demasiado vaga, y el modelo improvisa la composición de marca.
   **Solución**: sé mucho más explícito describiendo el end screen deseado, o sube tu propio **PNG transparente** con el logo/tarjeta final y pide que se use exactamente ese asset en cada video. [AUDIO 50:59-51:11, 1:00:58-1:01:17]

---

## CHECKLIST DE IMPLEMENTACIÓN

- [ ] 1. Instalar Claude Desktop/Code.
- [ ] 2. Instalar la Higgsfield **CLI** (no el MCP) — usar Terminal si Claude pide contraseña.
- [ ] 3. Iniciar sesión (sign in) y confirmar "device authorized".
- [ ] 4. Instalar los 4 skills de Higgsfield (usar principalmente "Higgsfield generate").
- [ ] 5. Crear la carpeta plantilla local y dársela a Claude (**+ → Add folder**).
- [ ] 6. Subir referencias de entorno (≥1 imagen, idealmente ~18) y generar su `.md` descriptor con UUIDs.
- [ ] 7. Subir character sheets de modelo(s) + fotos de detalle de ropa/accesorios.
- [ ] 8. Generar product sheets (todos los ángulos) con el prompt de "white background, product sheet, 6 images".
- [ ] 9. Generar el `.md` de descripción de modelos (subject + outfit + UUIDs).
- [ ] 10. Subir referencias del producto principal con descriptores de material/luz.
- [ ] 11. Crear y mantener el **prompt log** `.md`.
- [ ] 12. Crear y mantener el **reference IDs** `.md` (UUID ↔ archivo).
- [ ] 13. Escribir las **reglas** (character+trainer sheet only, nunca detail/editorial images).
- [ ] 14. Crear el **handoff document** (overview + cuentas + modelos + UUIDs maestros + reglas).
- [ ] 15. Documentar tu propio framework de prompting (Seedance/Nano Banana) a medida que aprendes qué funciona.
- [ ] 16. Crear el **Seedance prompt failure log** `.md`.
- [ ] 17. Crear la carpeta `outputs` vacía.
- [ ] 18. Crear el **feedback tracker** CSV/Google Sheets (UUID, archivo, prompt, status, notas — separar imágenes/videos).
- [ ] 19. (Opcional) Conectar Google CLI a Claude para live-update del tracker.
- [ ] 20. Lanzar el primer batch de prueba (10 videos o similar) con prompt detallado (modelo, entorno, producto, duración, aspect ratio, cámara).
- [ ] 21. Revisar resultados: aprobar/rechazar con notas específicas y accionables en el tracker.
- [ ] 22. Repetir generaciones — verificar que la calidad mejora con cada ronda de feedback.
- [ ] 23. (Avanzado) Configurar Routines para generación automática programada.
- [ ] 24. (Avanzado) Conectar Gmail/Calendar/Sheets para automatizar outreach con el contenido aprobado.
