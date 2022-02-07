------------------------------------------------------------------------------------------------
-- DML
------------------------------------------------------------------------------------------------
/* 1
Insertar un componente en el facility 1 
con nombre «Grifo | Grifo | 030303» 
descripcion «test insert»
número de serie «666333-eeefff»
fecha de instalación «2021-12-12»
inicio de garantia «2021-11-11»
código de activo «666000»
id del creador «3»
id del espacio «7»
id de tipo «78»
guid «666000»
*/

insert into components(
    facilityid,
    name,
    description,
    serialNumber,
    createdat,
    WARRANTYSTARTON,
    assetidentifier,
    creatorid,
    spaceId,
    typeid,
    externalidentifier
)
values(1,
'Grifo | Grifo | 030303',
'test insert',
'666333-eeefff',
to_date('2021-12-12','yyyy-mm-dd'),
to_date('2021-11-11','yyyy-mm-dd'),
'666000',
3,
7,
78,
'666000');

/*
Comprobar que se ven los datos insertados de forma conjunta con una JOIN
y no de forma independiente. Con el fin de comprobar las relaciones.
Mostrar todos los datos indicados en el punto anterior 
y además el nombre del espacio, nombre de la planta, nombre del tipo de componente
*/
select
    components.name,
    spaces.name,
    floors.name,
    component_types.name,
    components.facilityid,
    components.description,
    components.serialNumber,
    components.createdat,
    components.WARRANTYSTARTON,
    components.assetidentifier,
    components.creatorid,
    components.spaceId,
    components.typeid,
    components.externalidentifier
from components
    join spaces on components.spaceid = spaces.id
    join floors on floors.id = spaces.floorid
    join component_types on component_types.id = components.typeid
where 
    components.name = 'Grifo | Grifo | 030303';
/* 2
Eliminar el componente creado.
*/
delete from components where name = 'Grifo | Grifo | 030303';

/* 3
Colocar como código de barras los 6 últimos caracteres del GUID 
a todo componente de la planta 1 y 2 del facility 1.
*/

update components 
 set barcode = substr (externalidentifier, -6)
 where facilityid = 1
 and spaceid in (select id 
                 from spaces 
                  where floorid in (
                      select id from floors where name in ('Planta +1','Planta +2')));

/* 4
Modificar la fecha de garantia para que sea igual a la fecha de instalación
para todo componente que sea un grifo o lavabo del facility 1.
*/

/* 5
Anonimizar los datos personales: nombre, apellido, email, teléfono de los contactos
*/
