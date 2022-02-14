------------------------------------------------------------------------------------------------
-- SELECT con subcolsultas y JOINS
------------------------------------------------------------------------------------------------
/*
1
Listar nombre, código de asset, número de serie, el año de instalación, nombre del espacio,
de todos los componentes
del facility 1
que estén en un aula y no sean tuberias, muros, techos, suelos.
*/
SELECT
    COMPONENTS.NAME,
    COMPONENTS.ASSETIDENTIFIER,
    COMPONENTS.SERIALNUMBER,
    TO_CHAR (COMPONENTS.INSTALLATEDON,'YYYY-MM-DD'),
    SPACES.NAME
FROM COMPONENTS
    JOIN SPACES ON COMPONENTS.SPACEID = SPACES.ID
WHERE
    COMPONENTS.FACILITYID = 1 AND
    UPPER (SPACES.NAME) LIKE '%AULA%' AND
    COMPONENTS.EXTERNALOBJECT NOT IN('Tuberia', 'Muro', 'Techo', 'Suelo');
/*
2
Nombre, área bruta y volumen de los espacios con mayor área que la media de áreas del facility 1.
*/
SELECT
    SPACES.NAME,
    SPACES.GROSSAREA,
    SPACES.VOLUME
FROM
    SPACES JOIN FLOORS ON SPACES.FLOORID = FLOORS.ID
WHERE
    FACILITYID=1 AND
    SPACES.GROSSAREA>(SELECT
    AVG(GROSSAREA)
FROM
    SPACES JOIN FLOORS ON SPACES.FLOORID = FLOORS.ID
WHERE
    FACILITYID=1)
GROUP BY 
    SPACES.NAME,
    SPACES.GROSSAREA,
    SPACES.VOLUME;
/*
3
Nombre y fecha de instalación (yyyy-mm-dd) de los componentes del espacio con mayor área del facility 1
*/
SELECT
    COMPONENTS.NAME,
    TO_CHAR(COMPONENTS.INSTALLATEDON,'YYYY-MM-DD')
FROM
    COMPONENTS JOIN SPACES ON COMPONENTS.SPACEID = SPACES.ID
WHERE
    FACILITYID=1 AND
    SPACES.NAME =
        (SELECT
            NAME
        FROM
            (SELECT
                SPACES.NAME,
                SPACES.GROSSAREA
            FROM
                SPACES JOIN FLOORS ON SPACES.FLOORID = FLOORS.ID
            WHERE
                FACILITYID=1 AND
                GROSSAREA IS NOT NULL
            ORDER BY SPACES.GROSSAREA DESC)
        WHERE
            ROWNUM=1);
/*
4
Nombre y código de activo  de los componentes cuyo tipo de componente contenga la palabra 'mesa'
del facility 1
*/
SELECT
    COMPONENTS.NAME,
    COMPONENTS.ASSETIDENTIFIER
FROM
    COMPONENTS JOIN COMPONENT_TYPES ON COMPONENTS.TYPEID=COMPONENT_TYPES.ID
WHERE
    UPPER(COMPONENT_TYPES.NAME) LIKE '%MESA%';
/*
5
Nombre del componente, espacio y planta de los componentes
de los espacios que sean Aula del facility 1
*/
SELECT
    COMPONENTS.NAME,
    SPACES.NAME,
    FLOORS.NAME
FROM
    COMPONENTS JOIN SPACES ON COMPONENTS.SPACEID = SPACES.ID
    JOIN FLOORS ON SPACES.FLOORID = FLOORS.ID
WHERE
    COMPONENTS.FACILITYID = 1 AND
    LOWER(COMPONENTS.NAME) LIKE '%aula%';
/*
6
Número de componentes y número de espacios por planta (nombre) del facility 1. 
Todas las plantas.
*/

/*
7
Número de componentes por tipo de componente en cada espacio
de los componentes que sean mesas del facility 1
ordenados de forma ascendente por el espacio y descentente por el número de componentes.
Ejmplo:
Componentes    Tipo   Espacio
--------------------------------
12  Mesa-cristal-redonda    Aula 2
23  Mesa-4x-reclinable      Aula 3
1   Mesa-profesor           Aula 3
21  Mesa-cristal-redonda    Aula 12
*/

/*
8
Mostrar el nombre de las Aulas y una etiqueda «Sillas» que indique
'BAJO' si el número de sillas es menor a 6
'ALTO' si el número de sillas es mayor a 15
'MEDIO' si está entre 6 y 15 inclusive
del facility 1
ordenado ascendentemente por el espacio
Ejemplo:
Espacio Sillas
--------------
Aula 1  BAJO
Aula 2  BAJO
Aula 3  MEDIO
*/
SELECT
    SPACES.NAME, COUNT (COMPONENTS.NAME),
    CASE
        WHEN COUNT (COMPONENTS.NAME) < 6 THEN 'BAJO'
        WHEN COUNT (COMPONENTS.NAME) > 15 THEN 'ALTO'
        ELSE 'MEDIO'
    END SILLAS
FROM
    SPACES JOIN COMPONENTS ON COMPONENTS.SPACEID = SPACES.ID
WHERE
    UPPER (SPACES.NAME) LIKE '%AULA%' AND
    UPPER (COMPONENTS.NAME) LIKE '%SILLA%'
GROUP BY SPACES.NAME;
/*
9
Listar el nombre de los tres espacios con mayor área del facility 1
*/
SELECT
 FILA, NOMBRE, AREA, FACILITYID
FROM (
SELECT
 ROWNUM FILA,
 SPACES.NAME NOMBRE,
 SPACES.GROSSAREA AREA,
 FLOORS.FACILITYID
FROM
 SPACES
 JOIN FLOORS ON SPACES.FLOORID = FLOORS.ID
WHERE
 FLOORS.FACILITYID = 1
ORDER BY 3 DESC)
WHERE
 ROWNUM <4;
/*
10
Tomando en cuenta los cuatro primeros caracteres del nombre de los espacios
del facility 1
listar los que se repiten e indicar el número.
En orden descendente por el número de ocurrencias.
Ejemplo:
Espacio Ocurrencias
Aula    18
Aseo    4
Hall    2
*/
SELECT
    SUBSTR (SPACES.NAME,1,4)ESPACIO, COUNT (*)OCURRENCIAS
FROM
    SPACES JOIN FLOORS ON SPACES.FLOORID = FLOORS.ID
WHERE
    FACILITYID = 1
GROUP BY 
    SUBSTR (SPACES.NAME,1,4)
HAVING COUNT (*) > 1
ORDER BY 2 DESC;
/*
11
Nombre y área del espacio que mayor área bruta tiene del facility 1.
*/

/*
12
Número de componentes instalados entre el 1 de mayo de 2010 y 31 de agosto de 2010
y que sean grifos, lavabos del facility 1
*/

/*
13
Un listado en el que se indique en líneas separadas
una etiqueta que describa el valor, y el valor:
el número de componentes en Aula 03 del facility 1, 
el número de sillas en Aula 03 del facility 1
el número de mesas o escritorios en Aula 03 del facility 1
Ejemplo:
Componentes 70
Sillas 16
Mesas 3
*/

/*
14
Nombre del espacio, y número de grifos del espacio con más grifos del facility 1.
*/

/*
15
Cuál es el mes en el que más componentes se instalaron del facility 1.
*/

/* 16
Nombre del día en el que más componentes se instalaron del facility 1.
Ejemplo: Jueves
*/

/*17
Listar los nombres de componentes que están fuera de garantía del facility 1.
*/

------------------------------------------------------------------------------------------------
