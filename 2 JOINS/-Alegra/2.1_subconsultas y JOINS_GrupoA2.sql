------------------------------------------------------------------------------------------------
-- SELECT con subcolsultas y JOINS
------------------------------------------------------------------------------------------------
/*
1CARO
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
    UPPER(SPACES.NAME) LIKE '%AULA%' AND
    UPPER(COMPONENTS.EXTERNALOBJECT) NOT IN('TUBERIA', 'MURO', 'TECHO', 'SUELO');
/*
2EDU
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
3JAZ
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
5FELIX
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
6EDU
Número de componentes y número de espacios por planta (nombre) del facility 1. 
Todas las plantas.
*/
SELECT COUNT(COMPONENTS.ID), COUNT(DISTINCT SPACES.ID), FLOORS.NAME
FROM COMPONENTS 
RIGHT JOIN SPACES ON COMPONENTS.SPACEID = SPACES.ID
RIGHT JOIN FLOORS ON SPACES.FLOORID = FLOORS.ID 
WHERE COMPONENTS.FACILITYID = 1 
GROUP BY FLOORS.NAME;

/*
7CARO
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
SELECT COUNT(COMPONENTS.ID), 
 COMPONENT_TYPES.NAME, 
 SPACES.NAME
FROM COMPONENTS
 JOIN SPACES ON COMPONENTS.SPACEID = SPACES.ID
 JOIN COMPONENT_TYPES ON COMPONENTS.TYPEID = COMPONENT_TYPES.ID
WHERE COMPONENTS.FACILITYID = 1
GROUP BY SPACES.NAME,
 COMPONENT_TYPES.NAME
ORDER BY SPACES.NAME ASC, 1 DESC;

/*
8JAZ
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
10CARO
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
11JAZ
Nombre y área del espacio que mayor área bruta tiene del facility 1.
*/
SELECT 
    SPACES.NAME, MAX(GROSSAREA)
FROM SPACES
    JOIN COMPONENTS ON SPACES.ID = COMPONENTS.SPACEID
WHERE 
    FACILITYID = 1
GROUP BY 
    SPACES.NAME
HAVING 
    MAX(GROSSAREA) = (
 SELECT 
    MAX(GROSSAREA)
 FROM 
    SPACES JOIN COMPONENTS ON SPACES.ID = COMPONENTS.SPACEID
 WHERE 
    FACILITYID = 1);
/*
12FELIX
Número de componentes instalados entre el 1 de mayo de 2010 y 31 de agosto de 2010
y que sean grifos, lavabos del facility 1
*/
select count(*)
from components
    left join spaces on components.spaceid = spaces.id
where facilityid = 1
    and to_char(components.installatedon,'yyyy-mm-dd') between '2010-05-01' and '2020-08-31'
    and (lower(components.name)  like '%grifo%'
        or lower(components.name)  like '%lavabo%')
order by 1 desc;

/*
13 CARO
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

SELECT 'COMPONENTS' "Etiqueta",
 COUNT(COMPONENTS.ID) "Numero componentes"
FROM 
 SPACES JOIN COMPONENTS ON SPACES.ID = COMPONENTS.SPACEID
WHERE FACILITYID=1 AND UPPER(spaces.name)='AULA 03'
UNION
SELECT 'Mesas',
 count (components.id)
FROM SPACES JOIN COMPONENTS on spaces.id = components.spaceid
Where facilityid=1 
and UPPER(spaces.name)='AULA 03'
and UPPER(components.name)='%SILLA%'
Union        
Select components.id, 
 components.name
from spaces 
 join components on spaces.id = components.spaceid
Where facilityid=1 
and (UPPPER(compoenents.name) like '%MESA%' 
or UPPER(components.name) like '%ESCRITORIO%');


/*
14EDU
Nombre del espacio, y número de grifos del espacio con más grifos del facility 1.
*/

SELECT SPACES.NAME, COUNT(COMPONENTS.NAME)
	FROM COMPONENTS
	LEFT JOIN SPACES ON COMPONENTS.SPACEID = SPACES.ID
	WHERE FACILITYID = 1
	    AND LOWER(COMPONENTS.NAME) LIKE '%GRIFO%'
	GROUP BY SPACES.NAME
	HAVING COUNT(*) = (
	    SELECT MAX(COUNT(*))
	    FROM COMPONENTS
	        LEFT JOIN SPACES ON COMPONENTS.SPACEID = SPACES.ID
	    WHERE FACILITYID = 1
	        AND LOWER(COMPONENTS.NAME) LIKE '%GRIFO%'
	    GROUP BY SPACES.NAME);



/*
15FELIX
Cuál es el mes en el que más componentes se instalaron del facility 1.
*/

SELECT
    "Número de componentes" , Mes
FROM
    (select 
        count(components.name) as "Número de componentes", 
        to_char(INSTALLATEDON,'month')as Mes 
    from 
        components 
    group by 
        to_char(INSTALLATEDON,'month') 
    order by 
        count(name) desc)
where ROWNUM = 1;

/* 16JAZ
Nombre del día en el que más componentes se instalaron del facility 1.
Ejemplo: Jueves
*/
select dia 
    from
(select max(numcomp) maximo
from
(Select count(id) numcomp, to_char(installatedon,'Day') dia
from components
where facilityid = 1
group by to_char(installatedon,'Day')
)) tabmax
join
(    Select count(id) numcomp, to_char(installatedon,'Day') dia
    from components
    where facilityid = 1
    group by to_char(installatedon,'Day')
) tabnum on tabmax.maximo = tabnum.numcomp
;

/*17 EDU
Listar los nombres de componentes que están fuera de garantía del facility 1.
*/
SELECT
    COMPONENTS.NAME
FROM
    COMPONENT_TYPES JOIN COMPONENTS ON COMPONENT_TYPES.ID = COMPONENTS.TYPEID
WHERE
    COMPONENTS.FACILITYID = 1 AND
    COMPONENTS.WARRANTYSTARTON IS NOT NULL AND
    COMPONENT_TYPES.WARRANTYDURATIONPARTS IS NOT NULL AND
    ADD_MONTHS (COMPONENTS.WARRANTYSTARTON, COMPONENT_TYPES.WARRANTYDURATIONPARTS * 12) < SYSDATE
ORDER BY 1 DESC;

------------------------------------------------------------------------------------------------
