# Masa a pesar

Calculadora de laboratorio (una sola página HTML, sin librerías) para preparar
soluciones. Interfaz visual: escena con fondo químico y equipos de laboratorio,
campos tipo "píldora" repartidos sobre la escena, que se achica para entrar en
cualquier pantalla (pensada para iPad).

## Qué hace

A partir del **peso molecular** y la **concentración final** deseada, despeja lo que falte:

- **Masa a pesar** — dados concentración y volumen final, cuánto sólido pesar.
- **Volumen necesario** — dada la masa que ya pesaste, a qué volumen final llevarla.

Se cambia de modo tocando el **título**. Los equipos (frasco / matraz / balanza)
se reordenan según el modo.

- **Compuesto**: texto libre, solo de referencia (no entra en la cuenta; aparece en la pizarra).
- **Pureza del reactivo (%)**: opcional; si es menor a 100 corrige la masa
  (hay que pesar más) o el volumen (rinde menos) según el modo.

### Unidades (todas con menú desplegable en la píldora)

- Peso molecular: `g/mol`, `kg/mol`.
- Concentración: `M`, `mM`, `µM`, `ppm` (ppm interpretado como mg/L en solución acuosa).
- Volumen: `µL`, `mL`, `L`.
- Masa: `µg`, `mg`, `g`.

El resultado se auto-escala (µg/mg/g o µL/mL/L). **Al tocar la píldora del
resultado** se abre una pizarra con el detalle del cálculo (fórmula con valores y
unidades + cantidad de sustancia en mmol) sobre el fondo desenfocado:

- tocar la pizarra → copia el detalle **como imagen** al portapapeles (para pegar
  en un documento); si el navegador no lo permite, la descarga como `.png`.
- tocar fuera de la pizarra → vuelve a los datos.

El separador decimal puede ser coma o punto.

## Fórmulas

```
m = PM · C · V              (para ppm: m = C[mg/L] · V[L])
V = m / (PM · C)            (para ppm: V = m / C[mg/L])

con pureza P (%):  m_a_pesar = m / (P/100)      m_puro = m_pesada · (P/100)
```

## Uso

Abrir `index.html` en cualquier navegador. Funciona sin conexión.

## Publicación (GitHub Pages)

El repo se publica solo con GitHub Pages desde la rama `main`, carpeta raíz:

- App: `https://alejandrotamborelli-alt.github.io/masa-a-pesar/`

Cada `push` a `main` actualiza el sitio en ~1 minuto.

### App instalable / offline

`manifest.webmanifest` + `sw.js` (service worker) hacen que, al abrirla una vez
desde ese enlace en el iPad y usar *Compartir → Agregar a pantalla de inicio*,
quede como una app con ícono y funcione sin internet.

**Al publicar un cambio hay que subir `VERSION` en `sw.js`** (`v1` → `v2` → …).
Ese número es lo único que le avisa al dispositivo que debe descargar la versión
nueva; el service worker cachea con estrategia *cache-first*.

Íconos en `icons/` y `apple-touch-icon.png` generados con
`tools/gen-icons.ps1` (System.Drawing, sin dependencias externas).

## Imágenes de la escena

- `assets/` contiene las versiones optimizadas que usa la app
  (`fondo.jpg`, `frasco.png`, `matraz.png`, `balanza.png`, `pizarron.png`).
- `assets/src/` guarda los originales sin comprimir (respaldo).
- `tools/optimize-assets.ps1` regenera las optimizadas desde `src/`
  (reescala + JPEG para el fondo; PowerShell + System.Drawing, sin dependencias).
- Si se cambian imágenes, acordarse de subir `VERSION` en `sw.js`.

## Notas

Los cálculos asumen reactivo 100 % puro y anhidro. Ajustar por pureza del
reactivo y por sales hidratadas cuando corresponda.
