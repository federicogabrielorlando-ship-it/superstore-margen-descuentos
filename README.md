# Descuentos que destruyen margen: análisis de rentabilidad en retail

## Problema de negocio
La empresa aplica descuentos sin distinguir por producto. Una parte de las ventas se hace con descuentos mayores al 20% y, en conjunto, esas ventas dan pérdida. El equipo comercial necesita saber dónde se concentra esa pérdida para poner topes de descuento solo donde hacen falta, en lugar de una regla general que también frene las ventas que sí son rentables.

**Pregunta de negocio:** ¿qué subcategorías de producto concentran las pérdidas generadas por descuentos superiores al 20%?

## Datos
- **Fuente:** Sample Superstore, versión publicada en Kaggle como `SampleSuperstore.csv` (incluida en `data/`).
- **Tamaño:** 9.994 líneas de pedido y 13 columnas (modo de envío, segmento, ubicación, región, categoría, subcategoría, ventas, cantidad, descuento y resultado).
- **Aclaración:** esta versión no trae fechas ni identificador de línea. Los totales coinciden con la versión original del dataset (ventas US$ 2.297.200,86; resultado US$ 286.397,02).

## Stack
- **PostgreSQL 16:** carga, validación y consultas (`sql/`).
- **Excel:** porcentajes, acumulado y gráfico (`resultados/rebanada1.xlsx`).
- **Git y GitHub:** versionado.
- Planificado para los próximos sprints: Python (pandas) para automatizar la carga y Power BI para el tablero.

## Metodología
El proyecto sigue CRISP-DM organizado en sprints de una semana. Cada sprint recorre el ciclo completo en pequeño y termina con algo que se puede mostrar.

- **Sprint 1 (rebanada delgada #1, este entregable):** definición de la métrica y el umbral (comprensión del negocio), carga y validación mínima (comprensión de los datos), agregación por subcategoría (modelado), participación sobre la pérdida y control de totales (evaluación) y gráfico (despliegue).
- **Sprint 2:** margen por tramo de descuento y estimación del margen recuperable con un tope del 20%.
- **Sprint 3:** corte por región y segmento, script de Python reproducible y tablero en Power BI.

Definiciones usadas:
- Descuento alto: `discount > 0.20`.
- Resultado: suma de `profit` (negativo = pérdida).
- Participación en la pérdida: pérdida de la subcategoría sobre la suma de las pérdidas de todas las subcategorías que pierden (US$ 137.559).

## Hallazgos clave
- Las líneas con descuento mayor al 20% son el 13,9% de las líneas y el 15,8% de las ventas, y dejan un resultado de −US$ 135.376 (−37,3% sobre lo vendido).
- Binders, Tables y Machines explican el 71,8% de esa pérdida: US$ 98.764 de US$ 137.559.
- En Binders (−107%) y Appliances (−255%) cada dólar vendido con descuento alto genera más de un dólar de pérdida.
- Copiers es la única subcategoría con descuento alto que da resultado positivo (+US$ 2.183).

**Recomendación:** suspender durante cuatro semanas los descuentos mayores al 20% en Binders, Tables y Machines, medir el efecto en ventas y resultado y, en paralelo, verificar si esas subcategorías pierden también sin descuento.

**Alcance:** el análisis muestra dónde se concentra la pérdida, pero todavía no prueba que el descuento sea la única causa. Eso se evalúa en el sprint 2.

## Estructura del repositorio
```
data/SampleSuperstore.csv      dataset original
sql/01_carga.sql               carga en PostgreSQL (staging en texto y tabla tipada)
sql/02_validacion.sql          controles de filas, nulos, rangos, totales y repetidos
sql/03_rebanada.sql            consulta de la rebanada y control cruzado de totales
resultados/rebanada1.csv       salida de la consulta
resultados/rebanada1.xlsx      porcentajes, acumulado y gráfico
resultados/grafico_rebanada1.png  gráfico de pérdida por subcategoría
presentacion/presentacion.pdf  presentación ejecutiva
```

## Cómo ejecutarlo
Requisitos: PostgreSQL 14 o superior y `psql`.

```
git clone https://github.com/federicogabrielorlando-ship-it/superstore-margen-descuentos.git
cd superstore-margen-descuentos
createdb superstore
psql -d superstore -f sql/01_carga.sql
psql -d superstore -f sql/02_validacion.sql
psql -d superstore -f sql/03_rebanada.sql
```

Los comandos se ejecutan desde la carpeta raíz del repositorio, porque `01_carga.sql` lee `data/SampleSuperstore.csv` con una ruta relativa. El resultado de la última consulta es el que está en `resultados/rebanada1.csv`; el archivo de Excel toma esos valores.

## Autor
Federico Orlando · Data Analyst
