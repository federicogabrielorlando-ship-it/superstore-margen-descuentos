-- 02_validacion.sql
-- Controles mínimos antes de analizar (criterio JBGE de la rebanada #1).

-- 1) Cantidad de filas: tiene que coincidir con el CSV (9.994)
SELECT COUNT(*) AS filas FROM superstore;

-- 2) Nulos en las columnas que usa la rebanada
SELECT COUNT(*) - COUNT(sub_category) AS nulos_sub_category,
       COUNT(*) - COUNT(sales)        AS nulos_sales,
       COUNT(*) - COUNT(discount)     AS nulos_discount,
       COUNT(*) - COUNT(profit)       AS nulos_profit
FROM superstore;

-- 3) Rangos: el descuento tiene que estar entre 0 y 0.8 y las ventas ser positivas
SELECT MIN(discount) AS desc_min, MAX(discount) AS desc_max,
       MIN(sales)    AS venta_min, MAX(sales)  AS venta_max,
       MIN(profit)   AS profit_min, MAX(profit) AS profit_max
FROM superstore;

-- 4) Totales generales, para compararlos con el CSV abierto en Excel
SELECT ROUND(SUM(sales), 2)  AS ventas_totales,
       ROUND(SUM(profit), 2) AS ganancia_total
FROM superstore;

-- 5) Combinaciones de filas repetidas (las 13 columnas del CSV iguales)
SELECT COUNT(*) AS combinaciones_repetidas, SUM(veces) AS filas_involucradas
FROM (
    SELECT ship_mode, segment, country, city, state, postal_code, region, category,
           sub_category, sales, quantity, discount, profit, COUNT(*) AS veces
    FROM superstore
    GROUP BY ship_mode, segment, country, city, state, postal_code, region, category,
             sub_category, sales, quantity, discount, profit
    HAVING COUNT(*) > 1
) AS repetidas;
