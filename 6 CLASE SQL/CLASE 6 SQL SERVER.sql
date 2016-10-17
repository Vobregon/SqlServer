use northwind
go


SELECT a.ORDERID,a.CUSTOMERID ,c.companyname, a.employeeid, b.lastName, a.orderdate,p.productname,d.quantity,d.unitprice
FROM Orders as a
join EMPLOYEES as b on a.employeeid = b.employeeid
join customers as c on a.customerid=c.customerid
join "order details" as d on a.orderid=d.orderid
join products as p on d.productid=p.productid
where a.orderid<10255
order by b.lastname
compute sum(quantity) by b.lastname




select productname, unitprice,
(select avg(unitprice) from products) as promedio
from products
where unitprice > (select avg(unitprice) from products)

-- SELECCIONAMOS LAS SENTENCIAS Y PRESIONAMOS CONTROL + L


-- UTILIZANDO VARIABLES

declare @PROME NUMERIC (12,4) -- PARA CREAR VARIABLES TENEMOS QUE UTILIZAR LA FUNCION DECLARE , EL NOMBRE DE LA VARIABLE Y EL TIPO DE DATO.
set @PROME = (select avg(unitprice) from products)  -- PARA CREAR VARIABLES TENEMOS QUE ANTEPONERLO EL CARACTER ARROBA @ SI NO NO FUNCIONA
select productname, unitprice,@prome as promedio
from products
where unitprice > @prome

-- otra forma de hacerlo

declare @PROME NUMERIC (12,4) -- PARA CREAR VARIABLES TENEMOS QUE UTILIZAR LA FUNCION DECLARE , EL NOMBRE DE LA VARIABLE Y EL TIPO DE DATO.
select @PROME = avg(unitprice) from products  -- PARA CREAR VARIABLES TENEMOS QUE ANTEPONERLO EL CARACTER ARROBA @ SI NO NO FUNCIONA
select productname, unitprice,@prome as promedio
from products
where unitprice > @prome

-- otra
select lastname, country from employees
go
select companyname, address, city, country from customers
where country in (select distinct country from employees)
go
insert employees (lastname, firstname, country)
values ('PACHAS','CARLOS','PORTUGAL')

/*
CREANDO VISTAS
*/

CREATE VIEW MIS_CLIENTES1 AS   -- CON CREATE VIEW CREAMOS VISTAS LLAMADA MIS_CLIENTES1
SELECT COMPANYNAME, ADDRESS, CITY, COUNTRY
FROM CUSTOMERS
GO

-- PROBANDO
SELECT * FROM MIS_CLIENTES1

-- OTRA VISTA

CREATE VIEW MIS_CLIENTES2 AS 
SELECT COMPANYNAME AS CLIENTE, ADDRESS AS DIRECCION, CITY AS CIUDAD, COUNTRY AS PAIS
FROM CUSTOMERS

--PROBANDO
SELECT * FROM MIS_CLIENTES2
GO
SELECT CLIENTE, PAIS FROM MIS_CLIENTES2
GO
SELECT * FROM MIS_CLIENTES2 ORDER BY PAIS, CIUDAD
GO
-- SIGUIENDO

CREATE VIEW MIS_CLIENTES4 AS 
SELECT CUSTOMERID AS CODIGO, COMPANYNAME AS CLIENTE, ADDRESS AS DIRECCION, CITY AS CIUDAD, COUNTRY AS PAIS
FROM CUSTOMERS



--PROBANDO
SELECT * FROM MIS_CLIENTES4
GO
-- CORRECTA  -- SE PUEDE INSERTAR VALORES SIEMPRE QUE LOS ATRIBUTOS DE LA NUEVA VISTA TENGA VALORES NOT NULL
INSERT MIS_CLIENTES4 VALUES ('DFGA','FDADFSDFADI','AV. TGHDFHPAC AMARU','LIFGMA','FGSPERU')
--INCORRECTA  -- SI LOS ATRIBUTOS O COLUMNAS DE LAS VISTA TIENEN VALORES NULL ENTONCES NO SE PUEDE AGREGAR VALORES
INSERT MIS_CLIENTES2 VALUES ('FDADFSDFADI','AV. TGHDFHPAC AMARU','LIFGMA','FGSPERU')



create view ORDENCOMPLETA as
SELECT a.ORDERID,a.CUSTOMERID ,c.companyname, a.employeeid, b.lastName, a.orderdate,p.productname,d.quantity,d.unitprice
FROM Orders as a
join EMPLOYEES as b on a.employeeid = b.employeeid
join customers as c on a.customerid=c.customerid
join "order details" as d on a.orderid=d.orderid
join products as p on d.productid=p.productid

--- no puedo hacer un insert en una vista en la cual se juntan dos o mas tablas...

select * from ordencompleta

-- una vista no puede tener la clausula ORDER BY o la clausula INTO


-- MODIFICANDO LA VISTA
ALTER view ORDENCOMPLETA as  --- CON ALTER SE PUEDE AGREGAR O QUITAR COLUMNAS A LA VISTA, ES DECIR, SE PUEDEN MODIFICAR...
SELECT a.ORDERID,c.companyname,b.lastName, a.orderdate,p.productname,d.quantity,d.unitprice, d.discount, 
		(d.quantity*d.unitprice * (1-d.discount)) as importe
FROM Orders as a
join EMPLOYEES as b on a.employeeid = b.employeeid
join customers as c on a.customerid=c.customerid
join "order details" as d on a.orderid=d.orderid
join products as p on d.productid=p.productid

select * from ordencompleta

SELECT * FROM SYS.VIEWS		--  con este codigo podemos ver todas las vistas existentes en neustra base de datos

SELECT * FROM dbo.Invoices 

exec sp_helptext Invoices

-- Carlos Eduardo Pachas --
-- ENCRIPTANDO UNA VISTA---

CREATE view ORDENCOMPLETA2
WITH ENCRYPTION as  --- LA FRASE WITH ENCRYPTION nos permite encriptar la vista
SELECT a.ORDERID,c.companyname,b.lastName, a.orderdate,p.productname,d.quantity,d.unitprice, d.discount, 
		(d.quantity*d.unitprice * (1-d.discount)) as importe
FROM Orders as a
join EMPLOYEES as b on a.employeeid = b.employeeid
join customers as c on a.customerid=c.customerid
join "order details" as d on a.orderid=d.orderid
join products as p on d.productid=p.productid

--probando
select * from ordencompleta2 -- la vista encriptada se visualiza normalmente

--pero.....

exec sp_helptext ordencompleta2 -- al ejecutar esto me sale que la vista esta encriptada...


/* DONDE SE GUARDA TODO???????????????
*/

SELECT * FROM SYS.OBJECTS
GO
SELECT * FROM SYS.OBJECTS WHERE TYPE='V'  -- PUEDO VISUALIZAR TODOS LOS OBJETOS QUE SON VISTAS
GO
SELECT * FROM SYS.SYSCOMMENTS -- puedo ver todos los objetos creados
GO



--LUEGO HACEMOS UNA COMBINACION DE TODO LO ANTERIOR....
SELECT O.NAME , C.TEXT 
FROM SYS.OBJECTS AS O 
JOIN SYS.SYSCOMMENTS AS C ON O.OBJECT_ID = C.ID
WHERE O.TYPE = 'V'


