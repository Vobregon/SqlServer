use northwind
go
select * from sys.tables
go
select * from customers
go
select customerid, companyname, city, country
from customers
go
select companyname, address, contactname, country
from customers
go
select * from customers where country='uk'
go
select companyname, address, city, country
from customers
where country ='uk' or country='usa'
go
select * from customers where companyname like 'M%' -- RESTRINGE LOS DATOS DE QUIENES SU companyname COMIENZA CON M
go
select * from customers where companyname like '%S' -- RESTRINGE LOS DATOS DE QUIENES SU companyname TERMINA CON S
go
select * from customers where companyname like 'MA%'-- RESTRINGE LOS DATOS DE QUIENES SU companyname COMIENZA CON MA
go
select * from customers where address like 'MA%'
go
select * from customers where companyname between 'A%' and 'D%'  -- restringe las filas cuyo COMPANYNAME esta entre (between) A y D
go
select * from products where categoryid between 1 and 3
go
select * from customers where COUNTRY in ('usa', 'japan', 'italy') -- para no colocar COUNTRY=USA OR COUNTRY=ITALY OR COUNTRY=JAPAN
go
select * from customers where COUNTRY='USA' OR COUNTRY ='JAPAN' OR COUNTRY = 'ITALY'  -- EQUIVALENTE DE LA FILA ANTERIOR
go

select companyname, address, phone, fax, city, country
from customers 
where fax is not null

go

select companyname, address, phone, fax, city, country
from customers
order by city

go

select companyname, address, phone, fax, city, country
from customers
order by city desc  -- se usa la palabra reservada DESC para poder organizar los datos de manera descendente..

go

select companyname, address, phone, fax, city, country
from customers
order by country desc , city asc 

go

select companyname, address, phone, fax, city, country
from customers
where country='usa'
order by city desc  

go

select companyname, address, phone, fax, city, country
from customers
where companyname like 'M%'
order by city 

go
select distinct country from customers  -- Usar DISTINCT para poder hallar valores único y eliminar las duplicadas...es decir, solo nos muetra UNA SOLA VEZ el pais donde tenemos a nuestros clientes..

-- USANDO SOBRE NOMBRES EJEMPLO DOÑACOMPLEJO, COCODRILO, MULATO, MENDIGO, ERMITAÑO.

SELECT companyname, address,phone, fax, city, country
from customers
go
select companyname as CLIENTE, address as DIRECCION, phone as TELEFONO, city as CIUDAD, country as PAIS
FROM CUSTOMERS
go
-- usando literales
SELECT COMPANYNAME, 'CODIGO -->' as CODIGO, CUSTOMERID
FROM CUSTOMERS  -- Se crea una nueva columna donde se repite en todas las filas la cadena 'CODIGO-->' y a esa columna la llamamos CODIGO

go
--uso del TOP--

select top 7 productname, unitprice, unitsinstock --EL TOP 5 me dice que de toda la fila solo seleccione a los 5 primeros..es decir primero ordena todos los productos segun su precio unitario y luego solo selecciona a los 5 PRIMEROS 
from products
order by unitprice 
-- USANDO LA FUNCION COUNT (CONTADOR), AVG (PROMEDIO) , MAX , MIN
select count(*) 
from customers
where COUNTRY ='USA'
go
select count(customerid) from customers where country ='usa'
go
select count(fax) from customers where country ='usa'  -- como en FAX hay valores NULOS simplemente esos valores no se cuentan...
go
select AVG (unitprice) as "PROMERIO PRODUCTO" from PRODUCTS
go
select max (unitprice) from PRODUCTS
go
select min(unitprice) from products
go
select categoryid,productname, unitprice
from products
go
select AVG (unitprice) promeriocategory, categoryid -- PARA OBTENER EL PRECIO PROMEDIO QUE EXISTE POR CADA CATEGORIA USAMOS EL GROUP BY DE LA ULTIMA LÍNEA
from products
group by categoryid
go

select orderid, productid, unitprice, quantity
from "order details"
go
select productid, sum(unitprice*quantity) as subtotal
from "order details"
group by productid
order by productid

select count (companyname), country
from customers
group by country

select country, city, count (companyname)
from customers
group by country city
order by country
go
--AHORA AGRUPAMOS POR PAIS Y CIUDAD A LA VEZ, Y TENEMOS QUE PONER EN EL SELECT OBLIGATORIAMENTE COUNTRY y CITY o cualquiera de los dos PORQUE SINO NO FUNCAA
select city, count(companyname)
from customers
group by country, city
having count(companyname)>=3

---HACIENDO USO DEL WITH ROLLUP----
select orderid, productid, sum(unitprice*quantity) as subtotal
from "order details"
group by orderid, productid
with rollup   --- lo que hace el WITH ROLLUP es agregar mas filas al resultado que son la SUMA de todos los subtotales de los grupos, es decir por cada grupo pone despues de éste su respectivo subtotal..
ORDER BY orderid, productid

--HACIENDO USO DEL WITH CUBE ---

select orderid, productid, sum(unitprice*quantity) as subtotal
from "order details"
group by orderid, productid
with cube   --- lo que hace el WITH cube es agregar mas filas al resultado que son la SUMA de todos los subtotales de los grupos, es decir por cada grupo pone despues de éste su respectivo subtotal..
ORDER BY orderid, productid

--haciendo uso del grouping--
select orderid, grouping(orderid), productid, grouping (productid), sum(unitprice*quantity) as subtotal --se usa el grouping que me devuelve 0 cuando se trata de un dato AGRUPADO, y me devuelve 1 cuando se trata de un dato NO AGRUPADO
from "order details" 
group by orderid, productid
with cube   --- lo que hace el WITH cube es agregar mas filas al resultado que son la SUMA de todos los subtotales de los grupos, es decir por cada grupo pone despues de éste su respectivo subtotal..
ORDER BY orderid, productid

--USO DEL COMPUTE
select orderid, productid, unitprice, quantity
from "order details"
where orderid<10255
compute sum (quantity)  -- me muestra al final del resultado la suma de toda las cantidades...
go

--en las siguientes lineas me mostrará por cada ORDEN (orderid) la sumatoria de todas las cantidades...
select orderid, productid, unitprice, quantity
from "order details"
where orderid<10255 order by orderid
compute sum(quantity) by orderid

--ahora aparte de la sentencia anteior me mostrará la suma total al final del resultado
select orderid, productid, unitprice, quantity
from "order details"
where orderid<10255 order by orderid
compute sum(quantity) by orderid
compute sum(quantity)

--- COMBINACION DE VARIAS TABLAS ----

SELECT  * FROM ORDERS 
GO
SELECT a.ORDERID,a.CUSTOMERID , b.lastName, a.orderdate 
FROM ORDERS a, EMPLOYEES b
where a.employeeid = b.employeeid
GO

-- otra FORMA DE HACER EL FOREING KEY entre dos trablas

SELECT a.ORDERID,a.CUSTOMERID ,a.employeeid, b.lastName, a.orderdate
FROM ORDERS as a
join EMPLOYEES as b
on a.employeeid = b.employeeid

-- uniendo tres tablas


SELECT a.ORDERID,a.CUSTOMERID ,c.companyname, a.employeeid, b.lastName, a.orderdate
FROM ORDERS as a
join EMPLOYEES as b on a.employeeid = b.employeeid
join customers as c on a.customerid=c.customerid
go


-- uniendo cinco tablas--

SELECT a.ORDERID,a.CUSTOMERID ,c.companyname, a.employeeid, b.lastName, a.orderdate,p.productname,d.quantity,d.unitprice
FROM ORDERS as a
join EMPLOYEES as b on a.employeeid = b.employeeid
join customers as c on a.customerid=c.customerid
join "order details" as d on a.orderid=d.orderid
join products as p on d.productid=p.productid
