# Masa a pesar

Calculadora de laboratorio (una sola página HTML, sin dependencias) para preparar soluciones.

## Qué hace

A partir del **peso molecular** y la **concentración final** deseada, despeja lo que falte:

- **Masa a pesar** — dados concentración y volumen final, cuánto sólido pesar.
- **Volumen necesario** — dada la masa que ya pesaste, a qué volumen final llevarla.

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
```

## Uso

Abrir `masa-a-pesar.html` en cualquier navegador. Funciona sin conexión.

## Notas

Los cálculos asumen reactivo 100 % puro y anhidro. Ajustar por pureza del
reactivo y por sales hidratadas cuando corresponda.
