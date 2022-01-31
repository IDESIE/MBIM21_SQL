------------------------------------------------------------------------------------------------
--SELECTS SIMPLES
------------------------------------------------------------------------------------------------
/* 1
Describir la tabla floors
*/
desc floors;
/* 2 XU
Describir la tabla spaces
*/DESC SPACES;

/* 3 DALI
Datos de la tabla components
*/select * from components;

/* 4 BLANCA
Datos de la tabla component_types
*/
select * from component_types;

/* 5 RAQUEL
Id, nombre de los facilities
*/
select facilitiesid, name 
from facilities;

/* 6 XU
Nombre, elevación e id del facility de las plantas
*/
select 
    name, 
    elevation,
    facilityid from floors;

/* 7 DALI
Nombre, area bruta, volumen de los espacios
*/
select 
    name, 
    grossarea,
    volume from spaces;

/* 8 BLANCA
Nombre, vida útil de los tipos de componentes del facility 1
*/
select 
    name, 
    expectedlife
from component_types
where facilityid = 1;

/* 9 RAQUEL
Nombre de los espacios de la Planta 1 del facility 1
*/
select 
    spaces.name
from spaces,floors 
where spaces.floorid = 1 
    and floors.facilityid=1 
    and spaces.floorid = floors.id;

/*Previamente se consulta cuál es el floorid
listando los */

/* 10 XU
Nombre, número de modelo del tipo de componente con id = 60
*/
select 
    name, 
    modelnumber from component_types
    where id = 60;


/* 11 D
Nombre y fecha de instalación de los componentes del espacio 60 ordenados descendentemente por la fecha de instalación
*/
select
name, to_char(installatedon,'dd-mm-yyyy')
    from components
    where spaceid = 60
order by installatedon desc;

/* 12B
Listar las distintas fechas de instalación de los componentes del facility 1 ordenados descendentemente.
*/
SELECT to_char(installatedon,'dd-mm-yyyy')
    from components
    where facilityid=1 
    ORDER BY installatedon desc;

/* 13 R
Listar los distintos GUIDs de los componentes del facility 1 ordenados ascendentemente por fecha de garantía.
*/
select distinct externalidentifier "GUID", to_char(warrantystarton, 'yyyy-mm-dd')
from components
where facilityid=1
order by warrantystarton asc;

/* 14 X
Id, código de activo, GUID, número de serie y nombre de los componentes cuyo spaceid está entre 10 y 27 inclusive
ordenados por id de espacio descendentemente.
*/
select id, assetidentifier "Código", externalidentifier "GUID", serialnumber, name
from components
where spaceid >=10 and spaceid <=27
order by spaceid desc;

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
select assetidentifier "Código"
from components
where spaceid in (21)
order by 1 desc;

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
*/
select 
    name, 
    VOLUME 
from spaces 
where 
    volume > 90 and
    floorid = 1 
order by 
    volume desc;

/* 19 R 
Nombre, volumen de los espacios
cuyo volumen es mayor a 6 y menor a 9 de la planta con id = 1
*/
select name, volume, 
from spaces
where volume >6 and volume<9 and floorid=1;

/* 20 X
Nombre, código de activo, número de serie de los componentes
que no tengan espacio del facility 1
ordenados descendentemente por código de activo
*/
select name, assetidentifier "Código", serialnumber 
from components
where facilityid not like 1
order by assetidentifier desc;
/* 21 D
Nombre, código de activo, número de serie de los componentes
que tengan número de serie del facility 1
*/
select name, assetidentifier "Código", serialnumber 
from components
where facilityid = 1
and serialnumber is not null
order by serialnumber;

/* 22 B
Nombre de los espacios que empiezan por la letra A donde floorid = 1
*/
select
    name
from spaces
where 
    name like 'A%' and
    floorid=1;

/* 23 R
Lista de espacios que su segunda letra es una 's' donde floorid = 1
*/
select  *
from spaces
where name like '_s%';

/* 24 X
Lista de tipos de componente del facility 1 
donde el nombre contiene el texto 'con'
y no tienen vida útil indicada o fecha de garantia 
*/
select
name
id
from component_types
where 
facilityid =1 
and name like '%con%'
and expectedlife is null
and warrantydurationunitid is null;

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
select     
name, id
from spaces 
where floorid = 1 and     
id !=4 and id !=9 and id !=19;

/* 28 B
Lista de espacios que no son Aula del floorid = 1
*/
select
    name,
    floorid
from spaces
where 
    floorid = 1 and
    name not like 'Aula%';

/* 29 R
Lista de los tipos de componentes que tienen duracion de la garantia de las partes
del facility 1
*/
select *
from component_types
where warrantydurationparts is not null and facilityid=1;

/* 30 X
Lista de los tipos de componentes que no tiene el coste de repuesto
del facility 1
*/
select
name
id
from component_types
where 
facilityid =1 
and replacementcost is null;
    

/* 31
Lista de los tipos de componentes que tienen en el nombre un guión bajo
del facility 1
*/
Select name
from component_types
where name like '%@_%' escape '@';
--
------------------------------------------------------------------------------------------------
