-- 01_carga.sql
-- Carga del dataset Sample Superstore en PostgreSQL.
-- Primero se importa todo como texto (tabla de staging) para que ningún
-- valor raro haga fallar la carga; después se convierte a los tipos correctos.

DROP TABLE IF EXISTS staging_superstore;
DROP TABLE IF EXISTS superstore;

-- 1) Tabla de staging: todas las columnas como texto
CREATE TABLE staging_superstore (
    ship_mode     TEXT,
    segment       TEXT,
    country       TEXT,
    city          TEXT,
    state         TEXT,
    postal_code   TEXT,
    region        TEXT,
    category      TEXT,
    sub_category  TEXT,
    sales         TEXT,
    quantity      TEXT,
    discount      TEXT,
    profit        TEXT
);

-- Se ejecuta desde psql, parado en la carpeta del repositorio
\copy staging_superstore FROM 'data/SampleSuperstore.csv' WITH (FORMAT csv, HEADER true)

-- 2) Tabla final con tipos definidos
CREATE TABLE superstore (
    id            SERIAL PRIMARY KEY,   -- el CSV no trae identificador de línea
    ship_mode     TEXT,
    segment       TEXT,
    country       TEXT,
    city          TEXT,
    state         TEXT,
    postal_code   TEXT,                  -- texto: es un código, no un número
    region        TEXT,
    category      TEXT,
    sub_category  TEXT,
    sales         NUMERIC(12,4),
    quantity      INTEGER,
    discount      NUMERIC(4,2),          -- proporción: 0.20 = 20%
    profit        NUMERIC(12,4)          -- ganancia (o pérdida si es negativa) de la línea
);

INSERT INTO superstore (ship_mode, segment, country, city, state, postal_code,
                        region, category, sub_category, sales, quantity, discount, profit)
SELECT ship_mode, segment, country, city, state, postal_code,
       region, category, sub_category,
       CAST(sales AS NUMERIC), CAST(quantity AS INTEGER),
       CAST(discount AS NUMERIC), CAST(profit AS NUMERIC)
FROM staging_superstore;
