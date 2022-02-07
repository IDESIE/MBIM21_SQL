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
select 
     components.name,
     spaces.name,
     floors.name,
     components_types.name,
     components.facilityid,
     components.name,
     components.description,
     components.serialNumber,
     components.createdat,
     components.warrantyYears,
     components.assetidentifier,
     components.creatorid,
     components.spaceId,
     components.typeid,
     components.externalidentifier
from components
    join spaces on components.spaceid = spaceid.id
    join floors on floors.id = spaces.floorid
    join component_types on component_types.id = components.typeid
where
  components.name like 'Grifo | Grifo | 030303';
/*
Comprobar que se ven los datos insertados de forma conjunta con una JOIN
y no de forma independiente. Con el fin de comprobar las relaciones.
Mostrar todos los datos indicados en el punto anterior 
y además el nombre del espacio, nombre de la planta, nombre del tipo de componente
*/

/* 2
Eliminar el componente creado.
*/
delete from components(
    facilityid,
    name,
    description,
    serialNumber,
    createdat,
    warrantyYears,
    assetidentifier,
    creatorid,
    spaceId,
    typeid,
    externalidentifier
);

/* 3
Colocar como código de barras los 6 últimos caracteres del GUID 
a todo componente de la planta 1 y 2 del facility 1.
*/
update components
    set barcode = substr(externalidentifier, -6)
    where facilityId = 1
    and spaceId in (select id 
            from spaces 
            where floorid in (
                    select id from floors where name in ('Planta +1','Planta +2')));

/* 4
Modificar la fecha de garantia para que sea igual a la fecha de instalación
para todo componente que sea un grifo o lavabo del facility 1.
*/
Update components
set warrantystarton = installatedon
from components
where facilityid=1 and lower name in ('grifo','lavabo');


/* 5
Anonimizar los datos personales: nombre, apellido, email, teléfono de los contactos
*/
update contacts
   set 
   givenname= null,
   familyname =null,
   phone= null,
   email= concat('anonimo',id); 
     