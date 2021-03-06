------------------------------------------------------------------------------------------------
--SELECTS SIMPLES
------------------------------------------------------------------------------------------------
/* 1
Describir la tabla floors
*/
DESC floors;
/* 2
Describir la tabla spaces
*/
DESC spaces;
/* 3
Datos de la tabla components
*/
DESC components;
/* 4
Datos de la tabla component_types
*/
DESC components_types;
/* 5
Id, nombre de los facilities
*/
select 
    id,
    name
from components;
/* 6
Nombre, elevación e id del facility de las plantas
*/
select
    name,
    elevation,
    id
from floors;
/* 7
Nombre, area bruta, volumen de los espacios
*/
select 
    name,
    grossarea,
    volume
from spaces;
/* 8
Nombre, vida útil de los tipos de componentes del facility 1
*/
select
    name,
    updatedat
from components
where facilityid=1;
/* 9
Nombre de los espacios de la Planta 1 del facility 1
*/
/*Previamente se consulta cuál es el floorid
listando los */
select
    name
from spaces
where floorid=1;
/* 10
Nombre, número de modelo del tipo de componente con id = 60
*/
select
    name,
    serialnumber
from components
where id= 60;
/* 11
Nombre y fecha de instalación de los componentes del espacio 60 ordenados descendentemente por la fecha de instalación
*/
select
    name,
    installatedon
from components
where spaceid= 60
order by installatedon desc;
/* 12
Listar las distintas fechas de instalación de los componentes del facility 1 ordenados descendentemente.
*/
select
    name,
    installatedon
from components
where facilityid= 1
order by installatedon desc;
/* 13
Listar los distintos GUIDs de los componentes del facility 1 ordenados ascendentemente por fecha de garantía.
*/
select
    externalidentifier,
    warrantystarton
from components
where facilityid= 1
order by warrantystarton asc;
/* 14
Id, código de activo, GUID, número de serie y nombre de los componentes cuyo spaceid está entre 10 y 27 inclusive
ordenados por id de espacio descendentemente.
*/
select
    id,
    assetidentifier,
    externalidentifier,
    name,
    spaceid
from components
where spaceid between 10 and 27
order by spaceid desc;
/* 15
Id, código de activo, GUID, número de serie y nombre de los componentes del facility 1 
ordenados por código de activo descendentemente.
*/
select 
    id,
    assetidentifier "Codigo",
    externalidentifier "GUID",
    serialnumber,
    name
from components
where facilityid = 1
order by assetidentifier desc;

/* 16
Códigos de activo de los componentes del espacio con id 21
ordenados por código de activo descendentemente.
*/
select
    assetidentifier
from components
where spaceid = 21
order by assetidentifier desc;
/* 17
Las distintas fechas de instalación de los componentes 
de los espacios con id 10, 12, 16, 19 
ordenadas descendentemente.
*/

select distinct /*selecciona solo las columnas que son diferentes*/ to_char(installatedon,'yyyy-mm-dd')
from components
where spaceid in (10,12,16,19)
order by 1 desc;

/* 18
Nombre, volumen, de los espacios
cuyo volumen es mayor a 90 de floorid = 1
ordenados por volumen descendentemente
*/
select
    name,
    volume
from spaces
where floorid=1 and volume > 90
order by volume desc;
/* 19
Nombre, volumen de los espacios
cuyo volumen es mayor a 6 y menor a 9 de la planta con id = 1
*/
select
    name,
    volume
from spaces
where floorid=1 and volume between 6 and 9;
/* 20
Nombre, código de activo, número de serie de los componentes
que no tengan espacio del facility 1
ordenados descendentemente por código de activo
*/
select
    name,
    assetidentifier,
    serialnumber
from components
where facilityid=1 and spaceid=null
order by assetidentifier desc;
/* 21
Nombre, código de activo, número de serie de los componentes
que tengan número de serie del facility 1
*/
select
    name,
    assetidentifier,
    serialnumber
from components
where facilityid=1 and serialnumber is not null;
/* 22
Nombre de los espacios que empiezan por la letra A donde floorid = 1
*/
select
    lower(name)
from spaces
where floorid=1 and 
    name like 'A%';
/* 23
Lista de espacios que su segunda letra es una 's' donde floorid = 1
*/
select
    lower(name)
from spaces
where floorid=1 and 
    name like '_s%' ;
/* 24
Lista de tipos de componente del facility 1 
donde el nombre contiene el texto 'con'
y no tienen vida útil indicada o fecha de garantia 
*/
select
    lower(name)
from
    components
where 
    facilityid=1
    and name like '%con%'
    and warrantystarton is not null
    or length is not null;
/* 25
Nombres de espacios y volumen
pero como volumen una etiqueta que indique 
'BAJO' si es menor a 10, 'ALTO' si es mayor a 1000
y 'MEDIO' si está entre medias
*/

SELECT 
 NAME, 
 CASE 
  WHEN VOLUME<10 THEN 'BAJO'
  WHEN VOLUME>1000 THEN 'ALTO'
  ELSE 'MEDIO'
 END "VOLUMEN"
FROM SPACES;

/* 26
Nombre, fecha de instalación, fecha de garantia
de los componentes del facility 1
que tienen fecha de garantia
*/

select
    name,
    installatedon,
    warrantystarton,
    facilityid
from components
where facilityid = 1
    and warrantystarton is not null;

/* 27
Lista de nombres de espacio que su id no es 4, 9, ni 19
del floorid 1
*/
select
    name,
    id,
    floorid
from
    spaces
where 
    floorid=1
    and not id in (4,9,19);
/* 28
Lista de espacios que no son Aula del floorid = 1
*/
select
    name
from spaces
where floorid=1 and lower(name) not like 'Aula';
/* 29
Lista de los tipos de componentes que tienen duracion de la garantia de las partes
del facility 1
*/
select
    name
from component_types
where warrantydurationparts is not null and facilityid=1;
/* 30
Lista de los tipos de componentes que no tiene el coste de repuesto
del facility 1
*/
select
    name 
from 
    component_types
where 
    facilityid=1
    and replacementcost is null;
/* 31
Lista de los tipos de componentes que tienen en el nombre un guión bajo
del facility 1
*/

select
  lower(name)
from component_types
where name like '%\_%' escape '\'; /* escape hace que el caracter que colocas, sirve para decir en el name like 
que el carater que colocamos es literal, no un comodin*/ 
--
------------------------------------------------------------------------------------------------
