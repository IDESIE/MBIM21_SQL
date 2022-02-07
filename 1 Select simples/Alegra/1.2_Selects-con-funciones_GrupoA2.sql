------------------------------------------------------------------------------------------------
-- SELECT CON FUNCIONES
------------------------------------------------------------------------------------------------
/* 1
Mostrar la fecha actual de la siguiente forma:
Fecha actual
------------------------------
Sábado, 11 de febrero de 2027. 16:06:06

El día en palabras con la primera letra en mayúsculas, seguida de una coma, el día en números,
la palabra "de", el mes en minúscula en palabras, la palabra "de", el año en cuatro dígitos
finalizando con un punto. Luego la hora en formato 24h con minutos y segundos.
Y de etiqueta del campo "Fecha actual".
*/

select to_char(SYSDATE,'Day,dd "de" month "de" yyyy. hh:mi:ss')
from dual;

/* 2
Día en palabras de cuando se instalaron los componentes
del facility 1
*/

/* 3
De los espacios, obtener la suma de áreas, cuál es el mínimo, el máximo y la media de áreas
del floorid 1. Redondeado a dos dígitos.
*/
SELECT
ROUND(SUM(grossarea),2),
ROUND(MIN(grossarea),2),
ROUND(MAX(grossarea),2),
ROUND(AVG(grossarea),2)
FROM spaces 
WHERE floorid=1;




/* 4
Listar el número de componentes que tienen indicado el espacio y el número de componentes total.
del facility 1
*/

SELECT SPACEID, COUNT (*)
FROM COMPONENTS
WHERE FACILITYID=1
GROUP BY SPACEID; 

/* 5
Mostrar tres medias que llamaremos:
-Media a la media del área bruta
-MediaBaja la media entre el área media y el área mínima
-MediaAlta la media entre el área media y el área máxima
de los espacios del floorid 1
Solo la parte entera, sin decimales ni redondeo.
*/

SELECT
 FLOORID,
 TRUNC(AVG(grossarea),0) Media,
 TRUNC((AVG(grossarea)+MIN(GROSSAREA))/2,0) MediaBaja,
 TRUNC((AVG(grossarea)+MAX(GROSSAREA))/2,0) MediaAlta
FROM 
SPACES
WHERE
FLOORID=1
GROUP BY FLOORID;

/* 6
Cuántos componentes hay, cuántos tienen fecha inicio de garantia, cuántos tienen espacio, y en cuántos espacios hay componentes
en el facility 1.
*/
select
    count(*), count(id), count(warrantystarton), count(distinct warrantystarton)
from components
where warrantystarton is not null;

/* 7
Mostrar cuántos espacios tienen el texto 'Aula' en el nombre
del facility 1.
*/
select
 Count (*)
from 
 spaces
where 
 name like '%Aula%';

/* 8
Mostrar el porcentaje de componentes que tienen fecha de inicio de garantía
del facility 1.
*/

/* 9
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

SELECT DISTINCT SUBSTR(NAME,1,4) 
FROM SPACES 
WHERE FLOORID=1;

/* 10
Número de componentes por fecha de instalación del facility 1
ordenados descendentemente por la fecha de instalación
Ejemplo:
Fecha   Componentes
-------------------
2021-03-23 34
2021-03-03 232
*/

/* 11
Un listado por año del número de componentes instalados del facility 1
ordenados descendentemente por año.
Ejemplo
Año Componentes
---------------
2021 344
2020 2938
*/

/* 12
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
SELECT
 TO_CHAR(INSTALLATEDON,'Day')Día,
 COUNT(*)COMPONENTES

FROM COMPONENTS
WHERE
 FACILITYID=1
GROUP BY TO_CHAR(INSTALLATEDON,'Day')
ORDER BY TO_CHAR(INSTALLATEDON,'Day')ASC;
/*13
Mostrar en base a los cuatro primeros caracteres del nombre cuántos espacios hay
del floorid 1 ordenados ascendentemente por el nombre.
Ejemplo.
Aula 23
Aseo 12
Pasi 4
*/

/*14
Cuántos componentes de instalaron un Jueves
en el facilityid 1
*/

SELECT NAME, TO_CHAR(INSTALLATEDON, 'DAY')
FROM COMPONENTS
WHERE RTRIM(TO_CHAR(INSTALLATEDON, 'DAY'))= 'JUEVES'
AND FACILITYID=1;

/*15
Listar el id de planta concatenado con un guión
seguido del id de espacio concatenado con un guión
y seguido del nombre del espacio.
el id del espacio debe tener una longitud de 3 caracteres
Ej. 3-004-Nombre
*/
 SELECT
 (FLOORS.ID||'-'||SUBSTR(SPACES.ID,0,3)||'-'||SPACES.NAME) AS IDPL_IDESP_NOMBRES

FROM 
FLOORS  JOIN SPACES  ON FLOORS.ID=SPACES.FLOORID;
 
------------------------------------------------------------------------------------------------
