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

/*
2
Nombre, área bruta y volumen de los espacios con mayor área que la media de áreas del facility 1.
*/

/*
3
Nombre y fecha de instalación (yyyy-mm-dd) de los componentes del espacio con mayor área del facility 1
*/

/*
4
Nombre y código de activo  de los componentes cuyo tipo de componente contenga la palabra 'mesa'
del facility 1
*/

/*
5
Nombre del componente, espacio y planta de los componentes
de los espacios que sean Aula del facility 1
*/

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

------------------------------------------------------------------------------------------------