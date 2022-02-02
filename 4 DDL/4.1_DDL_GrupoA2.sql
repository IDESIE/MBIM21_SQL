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
CONSTRAINT FK_COMPONENT_SPACEID FOREIGN KEY (SPACEID)
 REFERENCES CB_SPACES(ID),
CONSTRAINT FK_COMPONENT_TYPESID FOREIGN KEY (TYPESID)
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
