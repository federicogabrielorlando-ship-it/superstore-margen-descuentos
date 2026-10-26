-- 03_rebanada.sql
-- Rebanada delgada #1
-- Pregunta: ¿qué subcategorías acumulan la mayor pérdida en las ventas
-- con descuento mayor al 20%?

-- Consulta principal: resultado por subcategoría, solo líneas con descuento > 20%
SELECT sub_category                 AS subcategoria,
       COUNT(*)                     AS lineas,
       ROUND(SUM(sales), 2)         AS ventas,
       ROUND(SUM(profit), 2)        AS resultado     -- negativo = pérdida
FROM superstore
WHERE discount > 0.20
GROUP BY sub_category
ORDER BY resultado ASC;                              -- primero las que más pierden

-- Control cruzado (DoD): el total del filtro tiene que ser igual
-- a la suma de las filas de la consulta anterior
SELECT COUNT(*)              AS lineas,
       ROUND(SUM(sales), 2)  AS ventas,
       ROUND(SUM(profit), 2) AS resultado
FROM superstore
WHERE discount > 0.20;

-- Referencia: resultado de toda la empresa (con y sin descuento)
SELECT ROUND(SUM(profit), 2) AS resultado_total_empresa
FROM superstore;
