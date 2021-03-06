------------------------------------------------------------------------------------------------
-- SELECT CON FUNCIONES
------------------------------------------------------------------------------------------------
/* 1 X
Mostrar la fecha actual de la siguiente forma:
Fecha actual
------------------------------
Sábado, 11 de febrero de 2027. 16:06:06

El día en palabras con la primera letra en mayúsculas, seguida de una coma, el día en números,
la palabra "de", el mes en minúscula en palabras, la palabra "de", el año en cuatro dígitos
finalizando con un punto. Luego la hora en formato 24h con minutos y segundos.
Y de etiqueta del campo "Fecha actual".
*/
select to_char 
(sysdate,'day, DD "DE" MONTH "DE" YYYY. HH:MM:SS')"Fecha Actual"
from dual;
/* 2 D
Día en palabras de cuando se instalaron los componentes
del facility 1
*/
select name,
to_char(installatedon,'Day') "Día de instalación"
from components
where facilityid=1;

/* 3 B
De los espacios, obtener la suma de áreas, cuál es el mínimo, el máximo y la media de áreas
del floorid 1. Redondeado a dos dígitos.
*/
SELECT 
    ROUND (sum(spaces.grossarea),2) as "Suma Gross",
    ROUND (sum(spaces.netarea),2) as "Suma Net",
    ROUND (min(spaces.grossarea),2) as "Mínimo Gross",
    ROUND (min(spaces.netarea),2) as "Mínimo Net",
    ROUND (max(spaces.grossarea),2) as "Máximo Gross",
    ROUND (max(spaces.netarea),2) as "Máximo Net",
    ROUND (avg(spaces.grossarea),2) as "Average Gross",
    ROUND (avg(spaces.netarea),2) as "Average Net"
    
FROM spaces
WHERE floorid = 1;
/* 4 R
Listar el número de componentes que tienen indicado el espacio y el número de componentes total.
del facility 1
*/
SELECT 'Número de componentes con espacio' ETIQUETA,count (components.id)
FROM components
where spaceid is not null
AND facilityid=1
UNION
SELECT 'Número de componentes total' ETIQUETA, count (components.id)
FROM components;
/* 5 X
Mostrar tres medias que llamaremos:
-Media a la media del área bruta
-MediaBaja la media entre el área media y el área mínima
-MediaAlta la media entre el área media y el área máxima
de los espacios del floorid 1
Solo la parte entera, sin decimales ni redondeo.
*/
SELECT 
    ROUND(avg(spaces.grossarea),0)"la media"
FROM spaces
WHERE floorid = 1;

/* 6 D
Cuántos componentes hay, cuántos tienen fecha inicio de garantia, cuántos tienen espacio, y en cuántos espacios hay componentes
en el facility 1.
*/

select
    count(*),
    count(warrantystarton),
    count(spaceid),
    count(distinct spaceid)
from components
where facilityid=1 
    and warrantystarton is not null 
    and spaceid is not null;

/* 7 B
Mostrar cuántos espacios tienen el texto 'Aula' en el nombre
del facility 1.
*/
SELECT count (spaces.name) as "Cuantas Aulas"
FROM spaces join floors on floorid = floors.id
WHERE floors.facilityid = 1 and spaces.name like 'Aula%';
/* 8 R
Mostrar el porcentaje de componentes que tienen fecha de inicio de garantía
del facility 1.
*/
SELECT ROUND (count(warrantystarton)/count(*) *100,4)
FROM components
WHERE facilityid=1;

/* 9 X
Listar las cuatro primeras letras del nombre de los espacios sin repetir
del facility 1. 
En orden ascendente.
Ejemplo:
Aula
Area
Aseo
Pasi
Pati
Serv
*/
SELECT
    distinct Substr(name,1,4)
from spaces
Where floorid=1;


/* 10 D
Número de componentes por fecha de instalación del facility 1
ordenados descendentemente por la fecha de instalación
Ejemplo:
Fecha   Componentes
-------------------
2021-03-23 34
2021-03-03 232
*/
Select
to_char(installatedon,'dd-mm-yyyy')"Fecha de instalación",
Count(installatedon) "Número de componente"
from components
where facilityid=1
and installatedon is not null
group by installatedon
order by installatedon desc;

/* 11 B
Un listado por año del número de componentes instalados del facility 1
ordenados descendentemente por año.
Ejemplo
Año Componentes
---------------
2021 344
2020 2938
*/
SELECT to_char(installatedon,'yyyy')"fecha",
    count (installatedon)
FROM components
WHERE facilityid = 1 and installatedon is not null
    group by to_char(installatedon,'yyyy')
    order by to_char(installatedon,'yyyy') desc;
/* 12 R
Nombre del día de instalación y número de componentes del facility 1.
ordenado de lunes a domingo
Ejemplo:
Día         Componentes
-----------------------
Lunes    	503
Martes   	471
Miércoles	478
Jueves   	478
Viernes  	468
Sábado   	404
Domingo  	431
*/

SELECT count(components.id), to_char(installatedon,'Day')
FROM components
WHERE facilityid=1
AND to_char(installatedon,'Day') is not null
GROUP BY to_char(installatedon, 'Day') ;

/*13 X
Mostrar en base a los cuatro primeros caracteres del nombre cuántos espacios hay
del floorid 1 ordenados ascendentemente por el nombre.
Ejemplo.
Aula 23
Aseo 12
Pasi 4
*/

/*14 D
Cuántos componentes de instalaron un Jueves
en el facilityid 1
*/
select 
 count(id), to_char(installatedon,'Day')
 from components 
where facilityid = 1 
and rtrim(to_char(installatedon,'Day'))= 'Jueves'
and facilityid= 1
group by to_char(installatedon,'Day');

/*15 B
Listar el id de planta concatenado con un guión
seguido del id de espacio concatenado con un guión
y seguido del nombre del espacio.
el id del espacio debe tener una longitud de 3 caracteres
Ej. 3-004-Nombre
*/
SELECT floors.id ||  '-' || '00' ||spaces.id ||  '-' || spaces.name as "order"
FROM spaces join floors on floorid = floors.id;
------------------------------------------------------------------------------------------------
