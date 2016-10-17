create proc mis_contactos
as
select contacTname, contacttitle, companyname, phone
from customers
go

exec mis_contactos  --- ESTAMOS EJECUTANDOLO ----


--- EJEMPLOS---

create proc clientes_usa
as
select companyname, address, city, country
from customers where country='usa'
order by city

go -- PROBANDO

exec clientes_usa


--USANDO PARAMETROS --

select distinct country from customers
go

--usando parametros
create proc clientes_pais
@pais nvarchar (40) as
select companyname, address, city, country
from customers where country=@pais 
order by city
go 

-- PROBANDO
exec clientes_pais 'usa'
EXEC CLIENTES_PAIS 'BRAZIL'


--usando funciones year y month
select getdate()
select year(getdate())
select year ('1972-01-18')


--ejemplo2
create proc ordenes98 as
select orderid, orderdate, customerid
from orders where year (orderdate)=1998
go
exec ordenes98


--EJEMPLO
create proc año_orden4
@date int as
select orderID, CUSTOMERID, orderdate
from orders where year(orderdate)  = @date  
exec año_orden4  1997


-- BORRAR UN PROCEDIMIENTO
DROP PROC año_orden4


-- Modificar  un procedimiento
alter proc año_orden4
@date int , @MES int as
select orderID, CUSTOMERID, orderdate
from orders where year(orderdate)  = @date  and MONTH (ORDERDATE)=@MES
exec año_orden4  1997,8  


-- crear un procedimiento con año y mes de datooooo...
create proc año_orden5
@date int , @MES int as
select orderID, CUSTOMERID, orderdate
from orders where year(orderdate)  = @date  and MONTH (ORDERDATE)=@MES
exec año_orden4  1997,8  

SP_HELP CUSTOMERS

-- Ahora bien, necesito saber que productos se llevo cada cliente...--
alter PROC CLIENTE_PRODUCTOS
@CODCLI NCHAR (10) AS
SELECT OD.ORDERID, P.PRODUCTNAME, OD.QUANTITY
FROM "ORDER DETAILS" AS  OD
JOIN PRODUCTS AS P ON OD.PRODUCTID = P.PRODUCTID
JOIN ORDERS AS O ON OD.ORDERID = O.ORDERID
where o.customerid=@codcli
GO
EXEC CLIENTE_PRODUCTOS 'ALfki'

/* PROCEDIMIENTOS CON VALOR DE RESPUESTA 
*/ 
CREATE PROC SUMITA 
@A int ,@B int,@S INT OUTPUT AS -- se pone el valor 'S INT OUTPUT' porque el parametro S es un parametro de salida..
SET @S=@A+@B  -- hasta aqui se creo la variable S
GO

--UTILIZANDOLO
DECLARE @RPTA INT     --- declaro mi valor de salida...
EXEC SUMITA 13,7,@RPTA OUTPUT  -- ejecuto el procedimieno anterior recordando al SQL que @RPTA es OUTPUT porque es de salida
SELECT 'LA SUMA ES --> ',@RPTA
---
create proc planilla4
@basico money, @ing money, @dscto money, @afp char, @neto money output as 
set @neto=@basico + @ing - @dscto

if @afp='si'
	set @neto=@neto*0.87
else
	set @neto=@neto*0.89
go
declare @sueldo money 
exec planilla4 1000,480, 260 , 'si', @sueldo output
select 'neto a pagar --> ' ,@sueldo 



declare @sueldo money 
exec planilla4 1000,480, 260 , 'no', @sueldo output
select 'neto a pagar --> ' ,@sueldo 
 
-- FUNCIONES  --
CREATE function DBO.FNSUMITA(@A int ,@B int)
returns INT 
begin 
	return @A + @B
end

select 'la suma es:',DBO.FNSUMITA(13,7)

--OTRO EJEMPLO DE FUNCIONES
CREATE FUNCTION dbo.fnplanilla
(@basico money,@ing money, @dscto money, @afp char(2))
returns money
begin
	declare @neto money
	set @neto=@basico + @ing - @dscto

	if @afp='si'
	set @neto=@neto*0.87
	else
	set @neto=@neto*0.89

return @neto
end

select 'neto a pagar',dbo.fnplanilla(1440,44,230,'si')


-- TENGO QUE USAR NOMBRES DE FUNCIONES CON "DBO.nombrefuncion"

--EJEMPLO DE PONER NO NULOS

create function dbo.sinnulos(@dato nvarchar(100))
returns nvarchar(100)
begin
if @dato is null
	set @dato=''

return @dato
end

--probandoooo--

select companyname,address, city, dbo.sinnulos(region) as REGION,dbo.sinnulos(phone) AS TELEFONO ,dbo.sinnulos(fax),country
FROM CUSTOMERS



--- para dar valores a una variables --

SET @ VARIABLE = (SELECT AVG(CAMPO7 FROM TABLA3)
OR
SELECT @VARIABLE=AVG (CAMPO7) FROM TABLA3

------------------------

alter FUNCTION dbo.PROBLEMA
(@codemplea int, @año INT)
returns int
begin
	declare @NORDEN int
	set @NORDEN= (SELECT COUNT(ORDERID) FROM ORDERS WHERE YEAR(ORDERDATE)=@año and @codemplea=employeeId)
	
return @NORDEN
end

select 'total de ordenes', dbo.PROBLEMA(9,1996)
