# /proximamente — snapshot estático para exposición

Copia offline de `https://veratv-prep.svapan.antel.com.uy/proximamente`
(HTML ya renderizado + CSS + fuentes + iconos + imágenes). No necesita red.

## Levantarlo

```bash
./serve.sh          # python3 -m http.server 8080
```

## Páginas

| URL | Qué es |
|---|---|
| `demo.html` | **La demo de la charla.** Slider de ancho + toggle CON/SIN responsive |
| `viewports.html` | Grilla comparativa fija (1280 / 768 / 414 / 375), para capturas |
| `index.html` | La página tal cual está en prep |
| `index.html?roto` | Sin **ninguna** regla `@media` de ancho, + `roto.css` (ancho mínimo) |
| `index.html?fix` | Prototipo de arreglo de las cards (`fix.css`) |

## Cómo se generó el modo `?roto`

Se eliminaron de los dos CSS todos los bloques `@media` cuya condición menciona
`min-width` o `max-width`. Se conservaron `print`, `prefers-reduced-motion`,
`hover`, etc. — lo que se borra es sólo la adaptación al ancho.

| Archivo | Bloques quitados | Peso perdido |
|---|---|---|
| `17299aaf54854c43.css` (global) | 217 | 31 KB (23%) |
| `bfee94bdc91992a6.css` (página) | 17 | 2,3 KB (33%) |
| | **234** | |

Los resultados quedan en `*.sin-responsive.css`. Si se re-baja el CSS de prep,
hay que regenerarlos (la función está documentada en el historial de la sesión).

## Exageración para la charla (`roto.css`)

Además de quitar las media queries, el modo `?roto` carga `roto.css`, que le
declara a la card `min-width: 1100px` — un ancho mínimo de escritorio, el vicio
clásico de maquetar mirando sólo el monitor propio. Debajo de ~1160px de
viewport la card ya no entra: desborda el contenedor y la página pide scroll
horizontal. La fecha y la hora quedan literalmente fuera de la pantalla.

El umbral está elegido para que **1280 y 1440 se vean impecables** y la rotura
arranque justo en laptop.

## Lo que demuestra — medido en el navegador

| Viewport | CON responsive | SIN responsive |
|---|---|---|
| 1440 | card 1318px · entra | card 1318px · entra ← **idénticos** |
| 1280 | card 1158px · entra | card 1158px · entra ← **idénticos** |
| 1152 | card 1032px · entra | card 1100px · se sale 10px |
| 1024 | card 982px · entra | card 1100px · **se sale 138px** |
| 768 | card 726px · entra | card 1100px · **se sale 394px** |
| 414 | **se apila** · texto 346px | card 1100px · **se sale 688px** |

En desktop no se nota absolutamente nada. Desde laptop para abajo la card deja
de caber y no hay ningún ajuste que la salve: se sale de la pantalla y se lleva
la fecha y la hora con ella.

Sin `roto.css` (sólo quitando las media queries) la rotura es más sutil pero
igual de real: la imagen tiene `flex-shrink: 0`, así que a 414px aplasta el
bloque de texto hasta **32px** de ancho. Como la card tiene `overflow: hidden`,
no aparece scroll ni aviso: el contenido simplemente desaparece.

## Nota aparte: el defecto real en prep

A 768px la card **también falla con responsive** (texto cortado). El único
breakpoint es `@media (max-width: 700px)`, así que entre 700 y ~900px la card
sigue en fila con el h4 en `white-space: nowrap`. Eso es un bug real de
`proximamente.module.scss`, no algo fabricado para la charla. `?fix` lo prueba.
# responsive
