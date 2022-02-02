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
address*/

CREATE TABLE cb_facilities (
    id number,
    guid varchar2(4000),
    name varchar2(4000) not null,
    description varchar2(4000),
    category varchar2(4000),
    address varchar2(4000),
CONSTRAINT pk_facili_id PRIMARY KEY (id),
CONSTRAINT uq_facili_guid UNIQUE (guid),
CONSTRAINT uq_facili_name UNIQUE (name)
);

/*FLOORS
id
guid
name
category
description
height
facilityId*/

CREATE TABLE cb_floors (
    id number,
    guid varchar2(4000),
    name varchar2(4000) not null,
    category varchar2(4000),
    description varchar2(4000),
    height number,
    facilityid number not null,
CONSTRAINT pk_cbfloors_id PRIMARY KEY (id),
CONSTRAINT uq_cbfloors_guid UNIQUE (guid),
CONSTRAINT uq_cbfloors_name UNIQUE (name),
CONSTRAINT fk_cbfloors_facili FOREIGN KEY (facilityid) REFERENCES cb_facilities(id)
);

/*SPACES
id
guid
name
category
description
usableHeight
area
floorId*/

CREATE TABLE cb_spaces (
    id number,
    guid varchar2(4000),
    name varchar2(4000) not null,
    category varchar2(4000),
    description varchar2(4000),
    usableHeight number,
    area number,
    floorId number not null,
CONSTRAINT pk_cbspaces_id PRIMARY KEY (id),
CONSTRAINT uq_cbspaces_guid UNIQUE (guid),
CONSTRAINT uq_cbspaces_name UNIQUE (name),
CONSTRAINT fk_cbspaces_floorid FOREIGN KEY (floorid) REFERENCES cb_floors(id)
);

/*COMPONENTS
id
guid
name
description
serialNumber
installatedOn
spaceId
typeId*/

CREATE TABLE cb_components (
    id number,
    guid varchar2(4000),
    name varchar2(4000) not null,
    description varchar2(4000),
    serialNumber varchar(4000),
    installatedOn date default sysdate,
    spaceId varchar2(4000),
    typeId number not null,
CONSTRAINT pk_cbcomponents_id PRIMARY KEY (id),
CONSTRAINT uq_cbcomponents_guid UNIQUE (guid),
CONSTRAINT uq_cbcomponents_name UNIQUE (name),
CONSTRAINT fk_cbcomponents_typeid FOREIGN KEY (typeId) REFERENCES cb_componenttype(id)
);

/*TYPES
id
guid
name
description
modelNumber
color
warrantyYears*/

CREATE TABLE cb_componenttype (
    id number, 
    guid varchar2(4000),
    name varchar2(4000) not null,
    description varchar2(4000),
    modelNumber varchar2(4000),
    color varchar2(4000),
    warrantyYears number,
CONSTRAINT pk_cbcomptype_id PRIMARY KEY (id),
CONSTRAINT uq_cbcomptype_guid UNIQUE (guid),
CONSTRAINT uq_cbcomptype_name UNIQUE (name),
CONSTRAINT ck_cbomptype_warr CHECK (warrantyYears > 0)
);

/*En las definiciones establacer las siguientes restricciones
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
