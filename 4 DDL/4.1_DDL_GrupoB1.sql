------------------------------------------------------------------------------------------------
-- DDL
------------------------------------------------------------------------------------------------
/* 
Se desea tener una base de datos con la información de instalaciones/edificios (falicities).
-Información acerca de las plantas, nombre, categoria, descripción, GUID (Global Unique identifier), altura.
-Sobre los espacios, nombre, categoria, descripción, altura usable, area, GUID
-componentes, nombre, descripción, GUID, numero de serie, fecha de instalación
-tipo de componentes, nombre, descripción, modelo, GUID, material, color, años de garantia

1-Generar las siguientes tablas
FACILITIES
id
guid
name
description
category
address
*/ 

create table cb_facilities(
 id number,
 guid varchar2(4000),
 name varchar2(4000) not null,
 description varchar2(4000),
 category varchar2(4000),
 address varchar2(4000),
constraint pk_facili_id primary key(id),
constraint uq_facili_guid unique(guid),
constraint uq_facili_name unique(name)
);

/* 
FLOORS
id
guid
name
category
description
height
facilityId

*/ 

create table cb_floors(
 id number,
 guid varchar2(4000),
 name varchar2(4000) not null,
 description varchar2(4000),
 category varchar2(4000),
 height number,
 facility_id number not null,
constraint pk_cbfloors_id primary key(id),
constraint uq_cbfloors_guid unique(guid),
constraint uq_cbfloors_name unique(name),
constraint fk_cbfloors_faci foreign key (facility_id)
  references cb_facilities (id)
);

/* 
SPACES
id
guid
name
category
description
usableHeight
area
floorId
*/

create table cb_spaces(
    id number,
    guid varchar2(4000),
    name varchar2(4000) not null,
    category varchar2(4000),
    description varchar2(4000),
    usableHeight varchar2(4000),
    area  varchar2(4000),
    floorId number not null,
    address varchar2(4000),
constraint pk_cbspaces_id primary key(id),    
constraint uq_cbspaces_guid unique(guid),
constraint uq_cbspaces_name unique(name)
);

/* 
COMPONENTS
id
guid
name
description
serialNumber
installatedOn
spaceId
typeId
*/

create table cb_components(
   id number,
    guid varchar2(4000),
    name varchar2(4000)not null,
    description varchar2(4000),
    serialNumber number,
    installatedOn date default sysdate,
    spaceId number,
    typeId number not null,
constraint pk_cbcomp_id primary key(id),
constraint uq_cbcomp_guid unique(guid),
constraint uq_cbcomp_name unique(name),
constraint fk_cbcomp_spaceid foreign key(spaceid),
    referemces cb_spaces(id)
constraint fk_cbcomp_typeid foreign key(typeid)
    references cb_types(id)
);

/* 
TYPES
id
guid
name
description
modelNumber
color
warrantyYears
*/
Create table cb_types(
    id number, 
    guid varchar2(4000),
    name varchar2(4000) not null,
    description varchar2(4000),
    modelNumber varchar2(4000),
    color varchar2(4000),
    warrantyyears number,
constraint pk_cbtypes_id primary key(id),
constraint uq_cbtypes_guid unique(guid),
constraint uq_cbtypes_name unique(name),
constraint ck_cbtypes_year check(warrantyyears > 0)
);



/* 

En las definiciones establacer las siguientes restricciones
-Los guid deben ser únicos.
-No es posible dar de alta un componente sin un tipo.
-No es posible dar de alta un espacio sin una planta.
-No es posiblde dar de alta una planta sin un facility.
-Dos componentes no pueden llamarse igual, lo mismo pasa con el resto de entidades.
-La fecha de instalación de un componente por defecto es la actual.
-Los nombres no pueden estar vacíos en todas las entidades.
-Los años de garantia no pueden ser cero ni negativos.
-Se debe mantener la integridad referencial.


NOTA: Algunos ejercicios provocan errores que deben probar (para ver el error) y corregir.
*/
