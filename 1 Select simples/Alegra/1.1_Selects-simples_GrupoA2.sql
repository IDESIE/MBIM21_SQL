------------------------------------------------------------------------------------------------
--SELECTS SIMPLES
------------------------------------------------------------------------------------------------
/* 1
Describir la tabla floors
*/
desc floors;
/* 2
Describir la tabla spaces
*/
DESC SPACES;
/* 3
Datos de la tabla components
*/
select * from components;
/* 4
Datos de la tabla component_types
*/
 SELECT *
FROM component_types;
/* 5
Id, nombre de los facilities
*/
SELECT ID, NAME
FROM FACILITIES;
/* 6
Nombre, elevación e id del facility de las plantas
*/
SELECT NAME, ELEVATION, FACILITYID
FROM FLOORS;
/* 7
Nombre, area bruta, volumen de los espacios
*/
SELECT
    id,
    name,
    grossarea,
    volume
FROM spaces;
/* 8
Nombre, vida útil de los tipos de componentes del facility 1
*/
SELECT
  name,
  EXPECTEDLIFE,
  FACILITYID
FROM COMPONENT_TYPES
WHERE FACILITYID=1;
/* 9
Nombre de los espacios de la Planta 1 del facility 1
*/
/*Previamente se consulta cuál es el floorid
listando los */
SELECT name
FROM spaces
where floorid = 1;
/* 10
Nombre, número de modelo del tipo de componente con id = 60
*/
SELECT NAME, MODELNUMBER
FROM component_types
WHERE ID = 60;
/* 11
Nombre y fecha de instalación de los componentes del espacio 60 ordenados descendentemente por la fecha de instalación
*/
SELECT
  NAME,
  installatedon,
  SPACEID
FROM COMPONENTS
WHERE SPACEID=60
ORDER BY INSTALLATEDON DESC;
/* 12
Listar las distintas fechas de instalación de los componentes del facility 1 ordenados descendentemente.
*/
SELECT DISTINCT
    installatedon
FROM components
WHERE facilityid = 1
ORDER BY installatedon desc;
/* 13
Listar los distintos GUIDs de los componentes del facility 1 ordenados ascendentemente por fecha de garantía.
*/
select EXTERNALIDENTIFIER "GUIDs", WARRANTYSTARTON
from components
where facilityid = 1
order by WARRANTYSTARTON asc;
/* 14
Id, código de activo, GUID, número de serie y nombre de los componentes cuyo spaceid está entre 10 y 27 inclusive
ordenados por id de espacio descendentemente.
*/
select id, ASSETIDENTIFIER "CODIGO DE ACTIVO", externalidentifier "GUID",
 SERIALNUMBER "NUMERO DE SERIE",NAME
FROM COMPONENTS
WHERE SPACEID>= 10
 AND SPACEID <= 27;
/* 15
Id, código de activo, GUID, número de serie y nombre de los componentes del facility 1 
ordenados por código de activo descendentemente.
*/
select id, ASSETIDENTIFIER "CODIGO", EXTERNALIDENTIFIER "GUID",
 SERIALNUMBER, NAME
from components
where FACILITYID = 1
ORDER BY ASSETIDENTIFIER DESC;

/* 16
Códigos de activo de los componentes del espacio con id 21
ordenados por código de activo descendentemente.
*/
SELECT
  ASSETIDENTIFIER "CÓDIGO DE ACTIVO",
  SPACEID "ID ESPACIO"
FROM COMPONENTS
WHERE SPACEID=21
ORDER BY ASSETIDENTIFIER DESC;
/* 17
Las distintas fechas de instalación de los componentes 
de los espacios con id 10, 12, 16, 19 
ordenadas descendentemente.
*/
<<<<<<< Updated upstream
select distinct to_char (installatedon,'yyyy-mm-dd'), spaceid
from components
where spaceid in (10, 12, 16, 19)
order by 1 desc;
=======
<<<<<<< HEAD
SELECT to_char(installatedon, 'yyyy-mm-dd'), spaceid
FROM components
where spaceid in (10,12,16,19)
order by 1 DESC;
=======
select to_char (installatedon,'yyyy-mm-dd'), spaceid
from components
where spaceid in (10, 12, 16, 19)
order by 1 desc;
>>>>>>> 1a764a29d7d1d19d7199f11bd1ea8545ea27fbf4
>>>>>>> Stashed changes

/* 18
Nombre, volumen, de los espacios
cuyo volumen es mayor a 90 de floorid = 1
ordenados por volumen descendentemente
*/
SELECT
    name,
    volume
FROM spaces
WHERE floorid=1 and volume >90
ORDER BY volume desc;
/* 19
Nombre, volumen de los espacios
cuyo volumen es mayor a 6 y menor a 9 de la planta con id = 1
*/
select name, volume
from spaces
where floorid = 1 
and volume BETWEEN 6 AND 9;
/* 20
Nombre, código de activo, número de serie de los componentes
que no tengan espacio del facility 1
ordenados descendentemente por código de activo
*/
SELECT NAME, ASSETIDENTIFIER "CODIGO DE ACTIVO", SERIALNUMBER "NUMERO DE SERIE"
FROM COMPONENTS
WHERE  FACILITY = 1
 AND SPACEID IS NULL
ORDER BY ASSETIDENTIFIER DESC;
/* 21
Nombre, código de activo, número de serie de los componentes
que tengan número de serie del facility 1
*/
SELECT
  NAME "NOMBRE",
  ASSETIDENTIFIER "CÓDIGO DE ACTIVO",
  SERIALNUMBER "NÚMERO DE SERIE",
  FACILITYID "ID INSTALACIÓN"
FROM COMPONENTS
WHERE FACILITYID=1;
/* 22
Nombre de los espacios que empiezan por la letra A donde floorid = 1
*/
SELECT
    name
FROM spaces
WHERE  
    floorid=1 and
    name like 'A%';
/* 23
Lista de espacios que su segunda letra es una 's' donde floorid = 1
*/
select name 
from spaces 
where floorid = 1 
and NAME LIKE'_s%';
/* 24
Lista de tipos de componente del facility 1 
donde el nombre contiene el texto 'con'
y no tienen vida útil indicada o fecha de garantia 
*/
SELECT ID, NAME 
FROM COMPONENT_TYPES
WHERE FACILITYID = 1
 AND LOWER(NAME) LIKE '%con%'
 AND (WARRANTYDURATIONUNITID IS NULL
 OR EXPECTEDLIFE IS NULL);

/* 25
Nombres de espacios y volumen
pero como volumen una etiqueta que indique 
'BAJO' si es menor a 10, 'ALTO' si es mayor a 1000
y 'MEDIO' si está entre medias
*/
select name, 
 case 
  when volume<10 then 'BAJO'
  when volume>1000 then 'ALTO'
  else 'MEDIO'
end "Volumen"
from spaces;
/* 26
Nombre, fecha de instalación, fecha de garantia
de los componentes del facility 1
que tienen fecha de garantia
*/
select name, to_char (installatedon,'yy-mm-dd'), 
 to_char (WARRANTYSTARTON, 'yyyy-mm-dd'), facilityid
from components
where facilityid = 1
and warrantystarton is not null;
/* 27
Lista de nombres de espacio que su id no es 4, 9, ni 19
del floorid 1
*/
SELECT
  NAME "NOMBRE",
  ID,
  FLOORID
FROM SPACES
WHERE FLOORID=1
  AND ID<>4
  AND ID<>9
  AND ID<>19;
/* 28
Lista de espacios que no son Aula del floorid = 1
*/
SELECT
    name
FROM spaces
WHERE  
    floorid=1 and
    name not like '%Aula%';
/* 29
Lista de los tipos de componentes que tienen duracion de la garantia de las partes
del facility 1
*/
select name,WARRANTYDURATIONPARTS 
from COMPONENT_TYPES
where facilityid = 1
and WARRANTYDURATIONPARTS <>0;
/* 30
Lista de los tipos de componentes que no tiene el coste de repuesto
del facility 1
*/
SELECT ID, NAME
FROM COMPONENTS
WHERE FACILITYID = 1 
AND REPLACEDON IS NULL;

/* 31
Lista de los tipos de componentes que tienen en el nombre un guión bajo
del facility 1
*/
SELECT*
FROM COMPONENT_TYPES
WHERE 
  FACILITYID=1
  AND NAME LIKE'%_%';
--
------------------------------------------------------------------------------------------------
