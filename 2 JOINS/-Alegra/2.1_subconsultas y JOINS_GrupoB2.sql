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
Select
    Components.name,
    Components.assetidentifier,
    Components.serialnumber,
    Components.installatedon,
Spaces.name
From components
 join spaces on components.spaceid = spaces.id
Where
Components.facilityid = 1
And spaces.name like '%Aula%'
And components.externalobject not in('Tuberia', 'Muro', 'Techo', 'Suelo');

/*
2
Nombre, área bruta y volumen de los espacios con mayor área que la media de áreas del facility 1.
*/
Select
    spaces.name,
    spaces.grossarea,
    spaces.volume
From
    spaces join floors on spaces.floorid = floors.id
Where
    facilityid=1 and
    spaces.grossarea>(select
    avg(grossarea)
From
    spaces join floors on spaces.floorid = floors.id
Where
    facilityid=1)
Group by 
    spaces.name,
    spaces.grossarea,
    spaces.volume;

/*
3
Nombre y fecha de instalación (yyyy-mm-dd) de los componentes del espacio con mayor área del facility 1
*/
select 
    rownum, fila, nombre, área, facilityid
from (
select 
    rownum fila,
    components.name nombre,
    components.area área,
    components.facilityid
from
    components
where
    components.facilityid = 1
    order by 3 desc)
where
    rownum < 4;


/*
4
Nombre y código de activo  de los componentes cuyo tipo de componente contenga la palabra 'mesa'
del facility 1
*/
Select components.name,
    components.assetidentifier,
    component_types.name
from 
    components
    join component_types on components.typeid = component_types.id
where 
    components.facilityid = 1
    and lower(component_types.name) like '%mesa%';

/*
5
Nombre del componente, espacio y planta de los componentes
de los espacios que sean Aula del facility 1
*/
SELECT components.name NombreComponente,
spaces.name NombreEspacio,
floors.name NombrePlanta
FROM components
JOIN spaces ON components.spaceid = spaces.id
JOIN floors ON  spaces.floorid=floors.id
WHERE UPPER(components.name) LIKE '%AULA%';

/*
6
Número de componentes y número de espacios por planta (nombre) del facility 1. 
Todas las plantas.
*/
SELECT 
Count(*) 
FROM spaces
JOIN floors ON  spaces.floorid=floors.id
Where floors.facilityid=1 
UNION
Select
Count (*) 
FROM spaces
JOIN floors ON  spaces.floorid=floors.id
Where floors.facilityid=1 And  floors.id=1
UNION
Select
Count (*) 
FROM spaces
JOIN floors ON  spaces.floorid=floors.id
Where floors.facilityid=1 And  floors.id=2
UNION
Select
Count (*) 
FROM spaces
JOIN floors ON  spaces.floorid=floors.id
Where floors.facilityid=1 And  floors.id=3
UNION
Select
Count (*) 
FROM spaces
JOIN floors ON  spaces.floorid=floors.id
Where floors.facilityid=1 And  floors.id=4
Union
Select
Count(spaceid) EspaciosPorPlanta
FROM components
JOIN spaces ON components.spaceid = spaces.id
JOIN floors ON  spaces.floorid=floors.id
Where floors.facilityid=1 
UNION
Select
Count (spaceid) 
FROM components
JOIN spaces ON components.spaceid = spaces.id
JOIN floors ON  spaces.floorid=floors.id
Where floors.facilityid=1 And  floors.id=1
UNION
Select
Count (spaceid) 
FROM components
JOIN spaces ON components.spaceid = spaces.id
JOIN floors ON  spaces.floorid=floors.id
Where floors.facilityid=1 And  floors.id=2
UNION
Select
Count (spaceid) 
FROM components
JOIN spaces ON components.spaceid = spaces.id
JOIN floors ON  spaces.floorid=floors.id
Where floors.facilityid=1 And  floors.id=3
UNION
Select
Count (spaceid) 
FROM components
JOIN spaces ON components.spaceid = spaces.id
JOIN floors ON  spaces.floorid=floors.id
Where floors.facilityid=1 And  floors.id=4;

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
select 
name,
count(*)as num from component_types
from components
JOIN component_types ON components.name = component_types.name
where facilityid=1 and lower(component_types.name) like '%mesa%'
group by name
order by count(*) desc;

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
select 
    spaces.name as Aulas ,count(components.name),
    case 
        when count(components.name) < 6 then 'Bajo'
        when count(components.name) > 15 then 'Alto'
        when count(components.name) > 6 and count(components.name) <=15 then 'Medio'
    end Sillas
    from spaces 
    join components on components.spaceid = spaces.id
    where spaces.name like 'Aula%' and components.name like 'Silla%'
    group by spaces.name
/*
9
Listar el nombre de los tres espacios con mayor área del facility 1
*/
Select
    rownum,fila,nombre,facilityid,fila,area
from(
select
    rownum fila,
    spaces.name nombre,
    spaces.grossarea area,
    floors.facilityid
from 
    spaces
    join floors on spaces.floorid = floors.id
where
    floors.facilityid = 1
order by 3 desc)
where
    rownum <4;

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
Select substr (spaces.name,1,4), count(*)
from spaces join floors on spaces.floorid = floors.id
where facilityid = 1
group by substr (spaces.name,1,4) 
having count (*) > 1
order by 2 desc;

/*
11
Nombre y área del espacio que mayor área bruta tiene del facility 1.
*/
select
    spaces.name, max(grossarea)
from
    spaces join components on spaces.id = components.spaceid
where
    facilityid = 1
group by
    spaces.name
having
    max(grossarea) = (
        select
    max(grossarea)
        from
    spaces join components on spaces.id = components.spaceid
        where
    facilityid = 1);
    
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
Select
    'components' "Etiqueta",
    count (components.id) "Numero componentes"
from 
    spaces join components on spaces.id = components.spaceid
Where facilityid=1 and lower(spaces.name)='aula 03'
Union
Select
    'Mesas',
    count (components.id)
from 
    spaces join components on spaces.id = components.spaceid
Where 
    facilityid=1 and 
    lower(spaces.name)='aula 03' and 
    lower(components.name)='%silla%'
Union        
Select
    components.id, 
    components.name
from 
    spaces 
    join components on spaces.id = components.spaceid
Where 
    facilityid=1 and 
    (lower(compoenents.name) like '%mesa%' or
    lower(components.name) like '%escritorio%');

/*
14
Nombre del espacio, y número de grifos del espacio con más grifos del facility 1.
*/

/*
15
Cuál es el mes en el que más componentes se instalaron del facility 1.
*/
SELECT
    "Número de componentes" , Mes
FROM
    (select 
        count(components.name) as "Número de componentes", 
        to_char(INSTALLATEDON,'Month')as Mes 
    from 
        components 
    group by 
        to_char(INSTALLATEDON,'Month') 
    order by 
        count(name) desc)
where ROWNUM = 1;
/* 16
Nombre del día en el que más componentes se instalaron del facility 1.
Ejemplo: Jueves
*/
Select Count(id) numcomp, to_char(installatedon,'Day')dia
    from components
    where facilityid = 1
    group by to_char(installatedon,'Day')
    having count(id)=(select max(numcomp) maximo
                from(
                    select count(id) numcomp,to_char(installatedon,'Day')dia
                    from components
                    where facilityid=1
                    group by to_char(installatedon,'Day')
                    ));

/*17
Listar los nombres de componentes que están fuera de garantía del facility 1.
*/
select
    dia
from
(select max(numcomp) maximo
from
(Select count(id) numcomp, to_char(installatedon,'Day') dia
from components
where facilityid = 1
group by to_char(installatedon,'Day')
)) tabmax
join
(
    Select count(id) numcomp, to_char(installatedon,'Day') dia
    from components
    where facilityid = 1
    group by to_char(installatedon,'Day')
) tabnum on tabmax.maximo = tabnum.numcomp
;
------------------------------------------------------------------------------------------------
