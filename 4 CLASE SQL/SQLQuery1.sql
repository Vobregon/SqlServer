select * from sys.databases
CREATE DATABASE BDTRES
go
use bdtres
go
select * from sys.tables
go
create table distrito (
coddis char (3) primary key,
nomdis varchar(50) unique not null)
go
insert distrito values('L01','LIMA')
insert distrito values('L02','ANCON')
insert distrito values('L09','RIMAC')
insert distrito values('L03','BREÑA')
insert distrito values('L12','CARABAYLLO')
SELECT * FROM distrito

select * from distrito Order By coddis

-- Intergidad por dominio 
-- Integridad por Referencial --> REFERENCES -> para hacer referencia FOREING KEY
-- Integridad por Entidad
select * from distrito

--- CONTROL + L ME DEVUELVE EL PLAN DE EJECUCIÓN

create table cliente (
codcli int identity (101,1) primary key nonclustered,
nomcli varchar(50) unique nonclustered not null,
ruccli varchar(11) unique nonclustered not null,
dircli varchar(120),
codpostal char(3) references distrito (coddis))

insert cliente values('Cordova','01485485620','oficina','L01')
insert cliente values('Carbajal','01225485620','oficina','L12')
insert cliente values ('Cisneros','02448682441','sucasa','L03')

select * from cliente

-- ACTUALIZANDO VALORES ---

UPDATE cliente Set nomcli = 'DANIEL RAMOS'
WHERE codcli=101
UPDATE cliente Set nomcli = 'CHARLIE PACHAS'
WHERE codcli=108

UPDATE cliente Set nomcli = 'GABRIELA CORDOVA'
WHERE codcli=101
select*from cliente


select db_name()
GO

select * from NORTHWIND.DBO.PRODUCTS
GO
SELECT*INTO CATALOGO FROM NORTHWIND.DBO.PRODUCTS
-- La clausula INTO me permite crear una nueva tabla en función de NORTHWIND.DBO.PRODUCTS y lo llamamos catalogo

GO
SELECT * FROM CATALOGO

select ProductID, PRODUCTNAME, CATEGORYID INTO nombretabla FROM CATALOGO
-- La linea anterior estamos creando una nueva tabla con el nombre NOMBRETABLA y los atributos productoID, productoname, categoryid DE LA TABLA CATALGOO.

select * from nombretabla
GO
ALTER TABLE nombretabla
add precioventa money

update nombretabla set precioventa=categoryid*1.25

select product 
select ProductID, PRODUCTNAME, CATEGORYID, UNITPRICE, UNITSINSTOCK INTO PRODUCTO1 FROM CATALOGO
select *
from producto1
where unitsinstock=0
ALTER TABLE producto1
add precioventa money
update producto1 set precioventa=unitprice*1.25

UPDATE producto1 set precioventa=0 where unitsinstock=0
select *from producto1

--- eliminar datos

DELETE PRODUCTO1

SELECT * from producto1
drop table producto1 -- eliminar tabla 

delete producto1 where unitsinstock=0
create table pruebax(
codigo int identity (1001,1),
dato uniqueidentifier default newid(),
fecha datetime default getdate())
go
--- Agregando datos ---

insert pruebax default values

select * from pruebax

delete pruebax 
-- cuando borramos con delete el campo CODIGO que es identity no se renueva, es decir, si elimino los primeros 7 registros, cuando cree el 8vo registro, elcodigo comenzara desde 1008 y no desde 1001

truncate table pruebax

-- en cambio con trucate table si se renueva el CODIGO identity y es que ahora si eliminamos filas o registros cuando creemos filas se crearan con el codigo renovado..




--- agregando datos usando select			
insert producto1(productname, unitprice) select productname,unitprice from catalogo

SP_HELP PRODUCTO1

select*from producto1
---agregando usando TRUNCATE
truncate table producto1



select * into  #PROPIO from PRODUCTO1

SELECT * FROM #PROPIO  ---- se guarda en la MEMORIA RAM DEL CLIENTE...  MEMORIA CLIENTE  ... SOLO LO PUEDE VER EL USUARIO QUE LO CREOO...

SELECT * FROM SYS.TABLES --- PARA VER LAS TABLAS DE LA BASE DE DATOS

-- VEMOS QUE LA TABLA #PROPIO NO EXISTE??.. NO APARECE CON LAS DEMAS TABLAS EN LA BASE DE DATOS.









select * into  ##GENERAL from PRODUCTO1
select * from ##general -- se guarda en la MEMORIA DEL SERVIDOR ... MEMORIA SERVER... solo lo puede visualizar el SERVIDOR.

