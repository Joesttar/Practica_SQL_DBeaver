select current_database();
/* Ahora veremos los bloques INNER JOIN, LEFT JOIN, otros 
 20 queries de GROUP BY, HAVING*/

--Bloque 1 INNER JOIN
--ver con su ID de prodcuto oficial
select v.*, p.NOMBRE_PRODUCTO from ventas v 
	inner join productos p on v.id_producto = p.id_producto;

--ver que usuario realizo intentos de login
select u.NOMBRE_USUARIO, i.IP_ORIGEN from usuario u
	inner join IntentosLogin i on u.NOMBRE_USUARIO = I.USUARIO;

--ventas filtradas por nombre de producto desde la maestra
select c.nombre_cliente, p.nombre_producto from clientes c, ventas v
	inner join productos p on v.id_producto  = p.id_producto where p.nombre_producto = 'Laptop';

--cruzar ventas con el email del vendedor(usuario)
select v.id_producto , p.NOMBRE_PRODUCTO from productos p, ventas v
	    inner join usuario u on v.vendedor = u.NOMBRE_USUARIO;

--ver ingresos por nombre de producto oficial
select p.NOMBRE_PRODUCTO, (v.precio * v.cantidad) as total from ventas v
	inner join productos p on v.id_producto = p.id_producto;

--6. unir intentos de login con el rol del usuario
select i.*, u.ROL from intentoslogin i
	inner join usuario u on i.USUARIO = u.NOMBRE_USUARIO

--ventas en monterrey con nombre de producto
select p.NOMBRE_PRODUCTO from ventas v
	inner join productos p on v.id_producto = p.id_producto where 
	v.ciudad = 'Montrerrey';

--listas ventas y telefonos de clientes(si tuviera id_cliente en ventas)
select v.id_ventas, c.telefono from ventas v
	inner join clientes c on p.id_producto = v.id_producto; --basandose en coiciencia de ciudad

--Relacion de productos y categorias vendidas
select distinct p.NOMBRE_PRODUCTO, v.categoria from productos p
	inner join ventas v on p.id_producto = v.id_producto;

--Detectar intentos fallidos de vendedores especificos
select p.NOMBRE_PRODUCTO, v.categoria from productos p 
	inner join ventas v on p.id_producto = v.id_producto

/*bloque 2 utilizamos LEFT JOIN*/

--prodcutos que nunca se han vendido
select p.nombre_producto from productos p
	left join ventas v on p.id_producto = v.id_producto
	where v.id_producto is null;

--usuario que no tiene registro de actividad en login
select u.NOMBRE_USUARIO from usuario u
	left join intentoslogin i on u.NOMBRE_USUARIO = i.usuario
	where i.usuario is null;

--todos lo clientes y sus posibles compras en la misma ciudad
select c.nombre_cliente, v.producto from clientes c
	left join ventas v on c.ciudad = v.ciudad;

--prodcutos en la maestra que no aparece en la tabla ventas
select p.id_producto, p.NOMBRE_PRODUCTO from productos p 
	left join ventas v on p.id_producto = v.id_producto
	where v.id_producto is null;

--ver todos los intentos de login, incluso si el usuario fue borrado de la tabla 'usuario'
select i.*, u.NOMBRE_USUARIO from IntentosLogin i 
	left join usuario u on i.usuario = u.NOMBRE_USUARIO;

--vendedores que no han registrado ventas
select u.NOMBRE_USUARIO from usuario u
	left join ventas v on u.NOMBRE_USUARIO = v.vendedor 
	where v.id_producto is null 
	and u.ROL = 'VENDEDOR';
--Categorias en ventas que noe stan mapeadas en productos
select v.categoria, p.id_producto from ventas v
	left join productos p on v.id_producto = p.id_producto 
	where p.id_producto is null;

/*bloque 3 donde utilizamos nuevametne group by*/

--ingreso total por ciudad
select ciudad, sum(precio * cantidad) from ventas 
	group by ciudad;

--intentos de login por cada IP
select IP_ORIGEN, count(*) from intentoslogin
	group by IP_ORIGEN;

--ventas totales por vendedor
select vendedor, count(*) from ventas 
	group by vendedor
	
--sock promedio por categoria
select categoria, AVG(stock_actual) from ventas
	group by categoria;

--cantidad de productos unicos en la tabla productos
select count(id_producto) from productos;

--suma de cantidad vendida por producto(ID)
select id_producto, sum(cantidad) from ventas 
	group by id_producto;

--intentos exitosos vs fallidoe de log in
select EXITOSO, count(*) from intentoslogin 
	group by EXITOSO;

--conteo de clientes por tipo
select tipo_cliente, coutn(*) from clientes	
	group by tipo_cliente;

--ventas por fecha
select fecha, count(*) from ventas 	
	group by fecha;

--Usuarios registrados por cada rol
select  ROL, count(*) from usuario
	group by ROL;

/*bloque 4 HAVING*/
--ciudades con ventas mayores a 20,000
select ciudad, sum(precio * cantidad) from ventas 
	group by ciudad having SUM(precio * cantidad) > 20000;

--IPs sospechosas (mas de un intento)
select IP_ORIGEN, count(*) from IntentosLogin 
	group by IP_ORIGEN having count(*) > 2;

--categorias con stock critico (menor a 5)
select categoria, sum(stock_actual) from ventas
	group by categoria
	having sum(stock_actual) < 5;

--vendedores que han vendido mas de 3 articulos
select vendedor, sum(cantidad) from ventas
	group by vendedor
	having sum(cantidad) > 3;

--usuarios con mas de un lgoin fallado
select usuario, count(*) from IntentosLogin
	group by usuario 
	having count(*) > 1;

--prodcutos(ID) que han generado mas de 10,000 de ingreso
select id_producto, count(*) from productos
	group by id_producto having count(*) > 10000;

--fechas donde el promedio de precio fue mayor a 5000
select fecha, AVG(precio) from ventas
	group by fecha
	having AVG(precio) > 5000;

--tipo de cliente que tiene mas de 5 registros
select tipo_cliente, count(*) from clientes 	
	group by tipo_cliente 
	having count(*) > 5;

