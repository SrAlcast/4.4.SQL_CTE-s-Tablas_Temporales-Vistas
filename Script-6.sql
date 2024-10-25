--Ejercicio 1. Queries Generales

--1.1. Calcula el promedio más bajo y más alto de temperatura.
SELECT 
    MIN(promedio) AS promedio_mas_bajo, 
    MAX(promedio) AS promedio_mas_alto
FROM (
    SELECT id_municipio, AVG(temperatura) AS promedio
    FROM tiempo
    GROUP BY id_municipio) AS subquery;

--1.2. Obtén los municipios en los cuales coincidan las medias de la sensación térmica y de la temperatura. 
select id_municipio, avg(sensacion_termica) as sensación_térmica_promedio, AVG(temperatura) as temperatura_promedio
from tiempo t 
group by id_municipio 
having avg(sensacion_termica) = AVG(temperatura)

--1.3. Obtén el local más cercano de cada municipio
SELECT  m.nombre, l.name, l.distance 
FROM lugar l
INNER JOIN (
    SELECT id_municipio, MIN(distance) AS min_distance
    FROM lugar
    GROUP BY id_municipio) subquery ON l.id_municipio = subquery.id_municipio AND l.distance = subquery.min_distance
inner join municipios m on l.id_municipio =m.id_municipio ;

--1.4. Localiza los municipios que posean algún localizador a una distancia mayor de 2000 y que posean al menos 25 locales.

SELECT l.id_municipio, COUNT(l.id_lugar) AS num_locales
FROM lugar l
WHERE l.distance > 2000
GROUP BY l.id_municipio
HAVING COUNT(l.id_lugar) >= 25;


--1.5. Teniendo en cuenta que el viento se considera leve con una velocidad media de entre 6 y 20 km/h, 
--moderado con una media de entre 21 y 40 km/h, fuerte con media de entre 41 y 70 km/h y muy fuerte 
--entre 71 y 120 km/h. Calcula cuántas rachas de cada tipo tenemos en cada uno de los días. 
--Este ejercicio debes solucionarlo con la sentencia CASE de SQL (no la hemos visto en clase, 
--por lo que tendrás que buscar la documentación). 
SELECT fecha,
    SUM(CASE WHEN racha_max BETWEEN 6 AND 20 THEN 1 ELSE 0 END) AS rachas_leves,
    SUM(CASE WHEN racha_max BETWEEN 21 AND 40 THEN 1 ELSE 0 END) AS rachas_moderadas,
    SUM(CASE WHEN racha_max BETWEEN 41 AND 70 THEN 1 ELSE 0 END) AS rachas_fuertes,
    SUM(CASE WHEN racha_max BETWEEN 71 AND 120 THEN 1 ELSE 0 END) AS rachas_muy_fuertes
FROM tiempo
GROUP BY fecha;



--## Ejercicio 2. Vistas
--2.1. Crea una vista que muestre la información de los locales que tengan incluido el código postal en su dirección. 

create view localescodigopostal as
select *
from lugar l 
WHERE address like '%28%'

--2.2. Crea una vista con los locales que tienen más de una categoría asociada.

create view localesmultiplecat as
SELECT name, COUNT(distinct (categoria)) AS num_categorias, id_municipio
FROM lugar
GROUP BY name, id_municipio
HAVING COUNT(distinct (categoria)) > 1;

--2.3. Crea una vista que muestre el municipio con la temperatura más alta de cada día

create view municipiotempmaxdia as
SELECT DISTINCT ON (t.fecha) t.fecha, m.nombre AS nombre_municipio, t.temperatura
FROM tiempo t
JOIN municipios m ON t.id_municipio = m.id_municipio
ORDER BY t.fecha, t.temperatura desc;

--2.4. Crea una vista con los municipios en los que haya una probabilidad de precipitación mayor del 100% durante mínimo 7 horas.

--NO TENGO LOS DATOS DE HORAS INCLUIDO EN LA BASE DE DATOS, SIN EMBARGO CONSIDERO QUE LA QUERY PODRIA SER--
create view municipioprecip7h as
SELECT 
FROM tiempo t
JOIN municipios m ON t.id_municipio = m.id_municipio;

--2.5. Obtén una lista con los parques de los municipios que tengan algún castillo.
create view parquecastillo as
SELECT l.name, STRING_AGG(l.categoria, ' ') AS categorias_asociadas
FROM lugar l
WHERE l.categoria IN ('Park', 'Castle')
GROUP BY l.name
HAVING COUNT(DISTINCT l.categoria) = 2;

--## Ejercicio 3. Tablas Temporales
--3.1. Crea una tabla temporal que muestre cuántos días han pasado desde que se obtuvo la información de la tabla AEMET.

CREATE TEMPORARY TABLE dias_desde_aemet AS
SELECT id_tiempo, fecha, CURRENT_DATE - fecha AS dias_desde_registro
FROM tiempo
ORDER BY fecha DESC;

--3.2. Crea una tabla temporal que muestre los locales que tienen más de una categoría asociada e indica el conteo de las mismas

CREATE TEMPORARY TABLE localescategoria AS
SELECT name, COUNT(distinct (categoria)) AS num_categorias, id_municipio
FROM lugar
GROUP BY name, id_municipio
HAVING COUNT(distinct (categoria)) > 1;

--3.3. Crea una tabla temporal que muestre los tipos de cielo para los cuales la probabilidad de precipitación mínima de los promedios de cada día es 5.

CREATE TEMPORARY TABLE tipos_cielo_probabilidad_5 as

SELECT DISTINCT t.cielo, AVG(t.prob_precip) AS promedio_precip
FROM tiempo t
GROUP BY t.fecha, t.cielo
HAVING AVG(t.prob_precip ) = 5;

;

--3.4. Crea una tabla temporal que muestre el tipo de cielo más y menos repetido por municipio.


--## Ejercicio 4. SUBQUERIES
--4.1. Necesitamos comprobar si hay algún municipio en el cual no tenga ningún local registrado.



--4.2. Averigua si hay alguna fecha en la que el cielo se encuente "Muy nuboso con tormenta".



--4.3. Encuentra los días en los que los avisos sean diferentes a "Sin riesgo".



--4.4. Selecciona el municipio con mayor número de locales.



--4.5. Obtén los municipios muya media de sensación térmica sea mayor que la media total.



--4.6. Selecciona los municipios con más de dos fuentes.



--4.7. Localiza la dirección de todos los estudios de cine que estén abiertod en el municipio de "Madrid".



--4.8. Encuentra la máxima temperatura para cada tipo de cielo.



--4.9. Muestra el número de locales por categoría que muy probablemente se encuentren abiertos.


