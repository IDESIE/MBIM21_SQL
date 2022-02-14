------------------------------------------------------------------------------------------------
-- SELECT con subcolsultas y JOINS
------------------------------------------------------------------------------------------------
/*
1 X
Listar nombre, código de asset, número de serie, el año de instalación, nombre del espacio,
de todos los componentes
del facility 1
que estén en un aula y no sean tuberias, muros, techos, suelos.
*/

/*
2 D
Nombre, área bruta y volumen de los espacios con mayor área que la media de áreas del facility 1.
*/

/*
3 B
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
5 R
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
6 X
Número de componentes y número de espacios por planta (nombre) del facility 1. 
Todas las plantas.
*/

/*
7 D
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
8 B
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
select 
    rownum, fila, nombre, área, facilityid
from (
select 
    rownum fila,
    spaces.name nombre,
    spaces.grossarea área,
    floors.facilityid
from
    spaces
    join floors on spaces.floorid = floors.id
where
    floors.facilityid = 1
    order by 3 desc)
where
    rownum < 4;

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
11 R
Nombre y área del espacio que mayor área bruta tiene del facility 1.
*/

/*
12 X
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
Select 'componentes' "Etiqueta",
    count(components.id) "Numero Componentes"
from 
    spaces join components on spaces.id = components.spaceid
where 
    facilityid = 1 and lower (spaces.name) = 'aula 03'
union
Select 'sillas',
    count(components.id)
from 
    spaces join components on spaces.id = components.spaceid
where 
    facilityid = 1 and 
    lower (spaces.name) = 'aula 03' and
    lower(components.name) like '%silla%'
union    
Select 'mesas',
    count(components.id)
from 
    spaces join components on spaces.id = components.spaceid
where 
    facilityid = 1 and 
    lower (spaces.name) = 'aula 03' and
    (lower(components.name) like '%mesa%' or 
    lower(components.name) like '%escritorio%');

/*
14 D
Nombre del espacio, y número de grifos del espacio con más grifos del facility 1.
*/

/*
15 B
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
/* 16
Nombre del día en el que más componentes se instalaron del facility 1.
Ejemplo: Jueves
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

/*17 R
Listar los nombres de componentes que están fuera de garantía del facility 1.
*/
SELECT components.name,
to_char(components.WARRANTYSTARTON,'yyyy-mm-dd')
FROM components
JOIN facilities ON facilities.id=components.facilityid
WHERE facilities.id=1
AND components.WARRANTYSTARTON<'2022-02-14';
------------------------------------------------------------------------------------------------
