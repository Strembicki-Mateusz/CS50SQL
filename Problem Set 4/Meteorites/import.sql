CREATE TABLE meteorites_temp (
    name TEXT,
    id TEXT,
    nametype TEXT,
    recclass TEXT,
    mass REAL,
    fall TEXT,
    year TEXT,
    reclat REAL,
    reclong REAL
);

.mode csv
.import --csv --skip 1 meteorites.csv meteorites_temp


DELETE FROM meteorites_temp
WHERE nametype = 'Relict';


UPDATE meteorites_temp
SET mass = NULL
WHERE mass = '';

UPDATE meteorites_temp
SET reclat = NULL
WHERE reclat = '';

UPDATE meteorites_temp
SET reclong = NULL
WHERE reclong = '';

UPDATE meteorites_temp
SET year = NULL
WHERE year = '';


UPDATE meteorites_temp
SET
    mass = ROUND(mass, 2),
    reclat = ROUND(reclat, 2),
    reclong = ROUND(reclong, 2);


CREATE TABLE meteorites (
    id INTEGER,
    name TEXT,
    class TEXT,
    mass REAL,
    discovery TEXT,
    year NUMERIC,
    lat REAL,
    long REAL,
    PRIMARY KEY("id")
);


INSERT INTO meteorites (name, class, mass, discovery, year, lat, long)
SELECT
    name,
    recclass AS class,
    mass,
    fall AS discovery,
    year,
    reclat AS lat,
    reclong AS long
FROM meteorites_temp
WHERE year IS NOT NULL
ORDER BY year, name;




DROP TABLE meteorites_temp;
