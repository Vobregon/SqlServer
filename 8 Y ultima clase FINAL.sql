create function dbo.ver_empleados
(@tipo char(1))returns @tmpempleado table (cod int,
nombre nvarchar(80), cargo nvarchar(80))
begin
if @tipo = 's'
	insert @tmpempleado select employeeid,
	titleofcourtesy +''+firstname+''+lastname,title
	from employees
else
	insert @tmpempleado select employeeid,
	firstname+''+lastname, title
	from employees
return
end

select * from dbo.ver_empleados('s')

---
-- CREAMOS UNA FUNCION QUE RETORNE UNA TABLA
create function dbo.catalogo_productos()
returns table
as return (select productname, unitprice, unitsinstock
from products)


go
select*from dbo.catalogo_productos()

-- crear una funcion que reciba el codigo de un producto, y un rango de fecha (fecha inicio y fecha final), de tal manera
-- que devuelva el nombre del cliente, el numero de la orden, la fecha de la orden, y la cantidad solicitada)


select * from "order details"

create function dbo.productitpo(@dato int, @feci datetime, @fecf datetime)
returns table
as return (
select a.customerID, a.orderdate,a.orderid, b.quantity
from orders as a, "order details" as b
where a.orderid=b.orderid and
	  b.productid = @dato and 

	(a.orderdate) < @fecf and (a.orderdate)>@feci)



select*from dbo.productitpo(2,'1997-12-20','1998-1-20')



--- OTRA FORMA

create function dbo.solucion1
@cod int, @fecini datetime, @fecfin datetime)
returns table
as return 
select o.customerid, o.orderid, o.orderdate, od.quantity 
from orders as o
join "order details" as od on o.orderid=od.orderid
join customers as c on o.customerid = c.customerid
where (o.orderdate between @fecini and @fecfin) and   -- el between se utilizar para hace o agrupar un dato entre menor o mayor...
od.productid = @cod)

select*from dbo.solucion1(2,'1997-12-20','1998-1-20')
select * from sys.tables

--------EXAMEN FINAL ---------


-- PREGUNTA 1
select count(a.productid) 
from "order details" as a
join orders as b on b.orderid=a.orderid
where year(b.orderdate)=1997 and month (b.orderdate)=8





select * from "order details"

--------------------------------------------------------
--PREGUNTA 2
		
		select top 1 count(a.orderid) as Cantidad, b.customerid , b.companyname
		from orders as a, customers as b
		where a.customerid =b.customerid and year(orderdate)=1998
		group by b.customerid, b.companyname
		order by count (a.orderid) desc
		
------------------------------------------------------
-- PREGUNTA 3

select top 7 a.productid, b.productname, a.quantity
from "order details" as a, products as b
where a.productid=b.productid
order by a.quantity desc 

----------------------------------------------------
SELECT * FROM ORDERS


--- PREGUNTA 4

select top 1 count(a.orderid) as Cantidad, a.employeeid, b.lastname, b.firstname
from orders as a, employees as b
where a.employeeid =b.employeeid and year(a.orderdate)=1998
group by a.employeeid, b.lastname, b.firstname
order by count (a.orderid) 

--------------------------------------------------------

--PREGUNTA 5

select sum(a.unitprice*a.quantity-a.discount) as subtotal
from "order details" as a
join orders as b on b.orderid=a.orderid
where year(b.orderdate)=1997  and month (b.orderdate) between 01 and 03






