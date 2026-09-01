# Masa a pesar

Calculadora de laboratorio (una sola página HTML, sin dependencias) para preparar soluciones.

## Qué hace

A partir del **peso molecular** y la **concentración final** deseada, despeja lo que falte:

- **Masa a pesar** — dados concentración y volumen final, cuánto sólido pesar.
- **Volumen necesario** — dada la masa que ya pesaste, a qué volumen final llevarla.

Campo opcional de **pureza del reactivo (%)**: si es menor a 100, corrige la masa
(hay que pesar más) o el volumen (rinde menos) según el modo.

### Unidades

- Concentración: `M`, `mM`, `µM`, `ppm` (ppm interpretado como mg/L en solución acuosa).
- Volumen: `µL`, `mL`, `L`.
- Masa (entrada en modo volumen): `µg`, `mg`, `g`.

El resultado se auto-escala (µg/mg/g o µL/mL/L) y el detalle muestra la fórmula
con todos los valores y unidades sustituidos, más la cantidad de sustancia en mmol.

El separador decimal puede ser coma o punto.

## Fórmulas

```
m = PM · C · V              (para ppm: m = C[mg/L] · V[L])
V = m / (PM · C)            (para ppm: V = m / C[mg/L])

con pureza P (%):  m_a_pesar = m / (P/100)      m_puro = m_pesada · (P/100)
```

## Uso

Abrir `masa-a-pesar.html` en cualquier navegador. Funciona sin conexión.

## Publicación (GitHub Pages)

El repo se publica solo con GitHub Pages desde la rama `main`, carpeta raíz:

- App: `https://alejandrotamborelli-alt.github.io/masa-a-pesar/masa-a-pesar.html`

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

## Notas

Los cálculos asumen reactivo 100 % puro y anhidro. Ajustar por pureza del
reactivo y por sales hidratadas cuando corresponda.
