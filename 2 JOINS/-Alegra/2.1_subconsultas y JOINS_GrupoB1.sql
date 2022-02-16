------------------------------------------------------------------------------------------------
-- SELECT con subcolsultas y JOINS
------------------------------------------------------------------------------------------------
/*
1 AGUSTINA
Listar nombre, código de asset, número de serie, el año de instalación, nombre del espacio,
de todos los componentes
del facility 1
que estén en un aula y no sean tuberias, muros, techos, suelos.
*/
select components.name, components.assetidentifier, serialnumber, installatedon, spaces.name
from components
    left join spaces on components.spaceid = spaces.id
where facilityid = 1
    and lower(spaces.name) like '%aula%'
    and lower(components.name) not like '%tube%'
    and lower(components.name) not like '%muro%'
    and lower(components.name) not like '%techo%'
    and lower(components.name) not like '%suelo%'
order by 1 desc
;

/*
2 JESUS
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
3 OMAR
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
4 KATHERIN
Nombre y código de activo  de los componentes cuyo tipo de componente contenga la palabra 'mesa'
del facility 1
*/
select
     components.name,
     components.assetidentifier    
from
    components
    join component_types on components.typeid = component_types.id
where
    components.facilityid = 1
    and upper(component_types.name) like '%MESA%';
/*
5 OMAR
Nombre del componente, espacio y planta de los componentes
de los espacios que sean Aula del facility 1
*/
select
    components.name NombreComponente,
    spaces.name NombreEspacio,
    floors.name NombrePlanta
from
    components
    join spaces 
    on components.spaceid = spaces.id
    join floors 
    on  spaces.floorid=floors.id
where
    upper(components.name) like '%AULA%';
/*
6 AGUSTINA
Número de componentes y número de espacios por planta (nombre) del facility 1. 
Todas las plantas.
*/
select count(components.id), count(distinct spaces.id), floors.name
from components
    right join spaces on components.spaceid = spaces.id
    right join floors on spaces.floorid = floors.id
where components.facilityid = 1 
group by floors.name
;
/*
7 JESUS
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
select count(components.id), component_types.name, spaces.name
from components
    join spaces on components.spaceid = spaces.id
    join component_types on components.typeid = component_types.id
where components.facilityid = 1
group by spaces.name,component_types.name
order by spaces.name asc, 1 desc;
/*
8 KATHERIN
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
    spaces.name as Aulas, count(components.name),
    case 
        when count(components.name) < 6 then 'Bajo'
        when count(components.name) > 6 and count(components.name) <=15 then 'Medio'
        when count(components.name) > 15 then 'Alto'      
    end Sillas
from spaces 
    join components 
    on components.spaceid = spaces.id
where 
    spaces.name like 'Aula%' and components.name like 'Silla%'
group by 
    spaces.name;
/*
9 KATHERIN
Listar el nombre de los tres espacios con mayor área del facility 1
*/
select
    rownum,fila, nombre, area, facilityid
from (
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
10 OMAR
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
select 
    substr (spaces.name,1,4), 
    count(*)
from spaces 
    join floors 
    on spaces.floorid = floors.id
where 
    facilityid = 1
group by 
    substr (spaces.name,1,4) 
having count (*) > 1
order by 2 desc;
/*
11 AGUS
Nombre y área del espacio que mayor área bruta tiene del facility 1.
*/
select
 spaces.name, max(grossarea)
from
 spaces join components on spaces.id =components.spaceid
where
 facilityid = 1
group by
 spaces.name
having 
 max (grossarea) = (
 select
  max(grossarea)
from
 spaces join components on spaces.id =components.spaceid
where
 facilityid = 1
 );
/*
12 JESUS
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
order by 1 desc
;
/*
13 KATHERIN
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
select 
    'Componentes' "Etiqueta",count(components.id)
from 
    spaces 
    join 
    components on spaces.id = components.spaceid
where
    facilityid=1
    and
    lower (spaces.name) = 'aula 03'

union

select 
    'Sillas',count(components.id)
from 
    spaces 
    join 
    components 
    on 
    spaces.id = components.spaceid
where
    facilityid=1
    and
    lower(spaces.name) = 'aula 03'
    and
    lower(components.name) like '%silla%'
    
union

select 
    'Mesas',count(components.id)
from 
    spaces 
    join 
    components 
    on 
    spaces.id = components.spaceid
where
    facilityid=1
    and
    lower(spaces.name) = 'aula 03'
    and
    (
    lower(components.name) like 'mesa%'
    or
    lower(components.name) like 'escritorio%'
    )
;
/*
14 AGUSTINA
Nombre del espacio, y número de grifos del espacio con más grifos del facility 1.
*/
select spaces.name, count(components.name)
from components
left join spaces on components.spaceid = spaces.id
where facilityid = 1
    and lower(components.name) like '%grifo%'
group by spaces.name
having count(*) = (
    select max(count(*))
    from components
        left join spaces on components.spaceid = spaces.id
    where facilityid = 1
        and lower(components.name) like '%grifo%'
    group by spaces.name)
    ;
/*
15 OMAR
Cuál es el mes en el que más componentes se instalaron del facility 1.
*/
select
    "Número de componentes" , Mes
from
    (select 
        count(components.name) as "Número de componentes", 
        to_char(INSTALLATEDON,'month')as Mes 
    from 
        components 
    group by 
        to_char(INSTALLATEDON,'month') 
    order by 
        count(name) desc)
where 
    rownum = 1;
/* 16 OMAR
Nombre del día en el que más componentes se instalaron del facility 1.
Ejemplo: Jueves
*/
select
    dia
from
(select max(numcomp)maximo
from (
    select count(id) numcomp, to_char(installatedon,'Day')dia
    from components
    where facilityid = 1
    group by to_char(installatedon,'Day')
)) tabmax
join
(
    select count(id) numcomp, to_char(installatedon,'Day')dia
    from components
    where facilityid = 1
    group by to_char(installatedon,'Day')
) tabnum on tabmax.maximo = tabnum.numcomp
;
/*17 JESUS
Listar los nombres de componentes que están fuera de garantía del facility 1.
*/

select
    components.name,
    components.warrantystarton,
    component_types.warrantydurationparts,
    add_months(components.warrantystarton, 
                component_types.warrantydurationparts * 12)
from
    component_types join components
    on
    component_types.id = components.typeid
where
    components.facilityid = 1 and
    components.warrantystarton is not null and
    component_types.warrantydurationparts is not null and
    add_months(components.warrantystarton, 
                component_types.warrantydurationparts * 12) < sysdate
order by
    2 desc, 3 desc
;

------------------------------------------------------------------------------------------------
