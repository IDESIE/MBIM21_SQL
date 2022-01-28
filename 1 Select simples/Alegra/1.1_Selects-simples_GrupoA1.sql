------------------------------------------------------------------------------------------------
--SELECTS SIMPLES
------------------------------------------------------------------------------------------------
/* 1
Describir la tabla floors
*/
desc floors;
/* 2 XU
Describir la tabla spaces
*/

/* 3 DALI
Datos de la tabla components
*/

/* 4 BLANCA
Datos de la tabla component_types
*/

/* 5 RAQUEL
Id, nombre de los facilities
*/

/* 6 XU
Nombre, elevación e id del facility de las plantas
*/

/* 7 DALI
Nombre, area bruta, volumen de los espacios
*/

/* 8 BLANCA
Nombre, vida útil de los tipos de componentes del facility 1
*/

/* 9 RAQUEL
Nombre de los espacios de la Planta 1 del facility 1
*/
/*Previamente se consulta cuál es el floorid
listando los */

/* 10 XU
Nombre, número de modelo del tipo de componente con id = 60
*/

/* 11 D
Nombre y fecha de instalación de los componentes del espacio 60 ordenados descendentemente por la fecha de instalación
*/

/* 12B
Listar las distintas fechas de instalación de los componentes del facility 1 ordenados descendentemente.
*/

/* 13 R
Listar los distintos GUIDs de los componentes del facility 1 ordenados ascendentemente por fecha de garantía.
*/

/* 14 X
Id, código de activo, GUID, número de serie y nombre de los componentes cuyo spaceid está entre 10 y 27 inclusive
ordenados por id de espacio descendentemente.
*/

/* 15 
Id, código de activo, GUID, número de serie y nombre de los componentes del facility 1 
ordenados por código de activo descendentemente.
*/
select id, assetidentifier "Código", externalidentifier "GUID", serialnumber, name
from components
where facilityid = 1
order by assetidentifier desc;

/* 16 D
Códigos de activo de los componentes del espacio con id 21
ordenados por código de activo descendentemente.
*/

/* 17
Las distintas fechas de instalación de los componentes 
de los espacios con id 10, 12, 16, 19 
ordenadas descendentemente.
*/
SELECT distinct to_char(installatedon,'yyyy-mm-dd')
from components
where spaceid in (10,12,16,19)
order by 1 desc;

/* 18 B
Nombre, volumen, de los espacios
cuyo volumen es mayor a 90 de floorid = 1
ordenados por volumen descendentemente
*/

/* 19 R 
Nombre, volumen de los espacios
cuyo volumen es mayor a 6 y menor a 9 de la planta con id = 1
*/

/* 20 X
Nombre, código de activo, número de serie de los componentes
que no tengan espacio del facility 1
ordenados descendentemente por código de activo
*/

/* 21 D
Nombre, código de activo, número de serie de los componentes
que tengan número de serie del facility 1
*/

/* 22 B
Nombre de los espacios que empiezan por la letra A donde floorid = 1
*/

/* 23 R
Lista de espacios que su segunda letra es una 's' donde floorid = 1
*/

/* 24 X
Lista de tipos de componente del facility 1 
donde el nombre contiene el texto 'con'
y no tienen vida útil indicada o fecha de garantia 
*/

/* 25 
Nombres de espacios y volumen
pero como volumen una etiqueta que indique 
'BAJO' si es menor a 10, 'ALTO' si es mayor a 1000
y 'MEDIO' si está entre medias
*/
SELECT 
    name, 
    CASE WHEN volume<10 then 'BAJO'
    WHEN volume >1000 then 'ALTO'
    ELSE 'MEDIO'
    END "Volumen" 
FROM spaces;
/* 26
Nombre, fecha de instalación, fecha de garantia
de los componentes del facility 1
que tienen fecha de garantia
*/
select name, installatedon, WARRANTYSTARTON, facilityid
from components
where facilityid = 1
and warrantystation is not null;

/* 27 D
Lista de nombres de espacio que su id no es 4, 9, ni 19
del floorid 1
*/

/* 28 B
Lista de espacios que no son Aula del floorid = 1
*/

/* 29 R
Lista de los tipos de componentes que tienen duracion de la garantia de las partes
del facility 1
*/

/* 30 X
Lista de los tipos de componentes que no tiene el coste de repuesto
del facility 1
*/

/* 31
Lista de los tipos de componentes que tienen en el nombre un guión bajo
del facility 1
*/

--
------------------------------------------------------------------------------------------------
