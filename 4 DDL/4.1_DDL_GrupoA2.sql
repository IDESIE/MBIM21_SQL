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

CREATE TABLE CB_FACILITIES(
  ID NUMBER,
  GUID VARCHAR2(4000),
  NAME VARCHAR2(4000) NOT NULL,
  DESCRIPTION VARCHAR2(4000),
  CATEGORY VARCHAR2(4000),
  ADDRESS VARCHAR2(4000),
CONSTRAINT PK_FACILI_ID PRIMARY KEY(ID),
CONSTRAINT UQ_FACILI_GUID UNIQUE(GUID),
CONSTRAINT UQ_FACILI_NAME UNIQUE(NAME)
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
/*

*/
create table cb_floors(
    id number,
    guid varchar2 (4000),
    name varchar2(200) not null,
    category varchar(200),
    description varchar2(200),
    height number,
    facility_id number not null,
    constraint pk_floor_id primary key(id),
    constraint uq_floor_guid unique (guid),
    constraint uq_floor_name unique (name),
    constraint fk_floor_id foreign key (facility_id)
    references cb_facilities(id)
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
    name varchar2(4000),
    category varchar2(4000),
    description varchar2(4000),
    usableHeight number,
    area number,
    floorId number not null,
constraint pk_cbspaces_id primary key (id),
constraint uq_cbspaces_guid unique(guid),
constraint fk_cbspaces_floorId FOREIGN KEY (floorId)
 references cb_floors(id)
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

CREATE TABLE CB_COMPONENTS(
    ID NUMBER,
    GUID VARCHAR2(4000),
    NAME VARCHAR2(4000) NOT NULL,
    DESCRIPTION VARCHAR2(4000),
    SERIALNUMBER NUMBER,
    INSTALLATEDON DATE DEFAULT SYSDATE,
    SPACEIDTYPEID NUMBER,
    TYPEID NUMBER NOT NULL,
CONSTRAINT PK_COMPONENT_ID PRIMARY KEY(ID),
CONSTRAINT UQ_COMPONENT_GUID UNIQUE(GUID),
CONSTRAINT UQ_COMPONENT_NAME UNIQUE(NAME),
CONSTRAINT FK_COMPONENT_SPACEID FOREIGN KEY (ID)
 REFERENCES CB_SPACES(ID),
CONSTRAINT FK_COMPONENT_TYPESID FOREIGN KEY (ID)
 REFERENCES CB_TYPES(ID)
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


create table cb_TYPES(
    id number, 
    guid varchar2(4000),
    name varchar2(4000) not null, 
    description varchar2(4000),
    model varchar2(4000),
    color varchar2(255 char),
    warrantyyears number,
    constraint pk_cbtypes_id primary key (id),
    constraint uq_cbtypes_guid unique (guid),
    constraint uq_cbtypes_name unique (name), 
    constraint ck_cbtypes_warrantyyears check (warrantyyears > 0)
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
