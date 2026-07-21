---
title: Plantilla Creative Direction (input al Director)
purpose: Brief inicial que arranca el One-Shot
last_updated: 2026-05-04
---

# Creative Direction — Plantilla de input

> Este es el **único texto** que necesitas escribir antes de correr el sistema. Todo lo demás (script, prompts de imagen/video, music prompt, scene breakdown) lo genera el Director Creativo en una sola pasada.

---

## Brief mínimo (lo más simple)

```
Target: [quién es el espectador / el personaje del anuncio]
Producto: [qué estamos vendiendo, marca + modelo]
Setting: [dónde se graba — paisaje, locación, atmósfera]
```

### Ejemplo ultra-mínimo

```
Target: Hombre 40 años, redneck con estilo, masculino y elegante.
Producto: Ford F150.
Setting: Wild West americano, desierto al atardecer.
```

Con eso solo, el Director ya genera 5 escenas, music prompt y script de 40s.

---

## Brief avanzado (más control creativo)

```
Target: ...
Producto: ...
Setting: ...

Tono emocional: [contemplativo / energético / nostálgico / aspiracional / etc.]

Referencias visuales: [películas, comerciales, fotógrafos que te inspiran]

Tagline: [si ya tienes una, escríbela exacto]

Script (opcional): [si ya tienes el voiceover, pégalo. El Director lo respeta tal cual]

Número de escenas: [default 5, máx 8 recomendado para ~40s]

Música: [tipo / referencia — solo si quieres orientar la dirección musical]
```

### Ejemplo completo

```
Target: Hombre 40 años, redneck de mucho estilo, camisa cuadros, masculino pero elegante.
Producto: Ford F150 nueva generación.
Setting: Wild West americano, polvo, atardecer, vacío visual.

Tono emocional: contemplativo y masculino, sensación de "no necesito demostrar nada".
Referencias visuales: estética de comerciales de Marlboro vintage + cinematografía de Deakins (Sicario, Skyfall).
Tagline: "Hecha para liderar el camino."

Script: Hay quienes miden el éxito en cifras... Nosotros lo medimos en lo que somos capaces de construir... Porque el estilo no es un disfraz, es una actitud... Nueva F150, hecha para liderar el camino.

Número de escenas: 5
Música: slide acústico profundo, percusión tribal, energía sostenida sin estridencias.
```

---

## Reglas a tener en cuenta

- **Tres bloques siempre**: Character + Setting + Product. Si falta uno, el output va a sentirse desbalanceado.
- **Tagline al final del script**: el Director cierra siempre con Marca + Tagline (salvo que digas lo contrario).
- **No uses `—`** en el script. Usa `...` para pausas.
- **No uses comillas dobles** dentro del script (rompe el JSON).
- **40 segundos ≈ 5 escenas de 8s**. Si quieres más corto (15s reel), pide 2-3 escenas.
