/*Practicaremos con los comandos SELECT, WHERE, ORDER BY. 1er empezaremos con SELECT*/

--Vemos todos los productos
select * from productos;

--Vemos solo nombres de los productos
select nombre_producto from productos;

--ver nombre y categorias de ventas
select producto, categoria from ventas;

--ver precios y cantidades de ventas
select precio, cantidad from ventas;

--ver listas de ciudades donde hay ventas
select ciudad from ventas;

--Lista de ciudades sin repetir utilizando el comando DISTINCT
select distinct ciudad from ventas;

--ver nombres de clientes y sus telefonos
select clientes, telefono from clientes;

--Ver usuarios y sus IPs de la tabla de seguridad
select intentoslogin.usuario, IP_ORIGEN from IntentosLogin;

--calcular un alias(ingreso)
select (precio * cantidad) as subtotal from ventas;

--ver ID de ventas y fecha
select ID, fecha from ventas;

--ver vendedores registrados
select distinct vendedor from ventas;

--Ver categorias unicas
select distinct categoria from ventas;

--ver IDs de productos en la maestra
select productos.id_producto from productos;

--ver estado de exito en logins
select intentoslogin.exitoso from IntentosLogin;

--ver stock actual de ventas
select stock_actual from ventas;

------------------------------------------------------------------------------------------------
/*Ahora utilizaremos WHERE*/

--ventas de la ciudad de monterrey
select * from ventas
where ciudad = 'Monterrey';

--ventas con precio mayor a 10,000
select * from ventas
	where precio > 10000;

--Ventas de laptop unicamente
select * from ventas
 where categoria = 'Laptop';

--logins fallidos
select * from IntentosLogin
	where exitoso = false;

--logins de una IP especifca
select * from IntentosLogin 
	where intentoslogin.ip_origen = '192.168.1.58';

--ventas con poco stock menor a 5
select stock_actual from ventas
	where stock_actual < 5;

--ventas entre dos fechas
select * from ventas
	where fecha between '2026-02-10' and '2026-02-12';

--productos que NO son tecnologia 
select * from ventas
	where categoria <> 'Tecnologia';

--ventas hechas por el vendedor carlos
select * from ventas
	where vendedor = 'Carlos';

--cantidad de prodcutos vendidos mayor a 5
select * from ventas
	where cantidad > 5;

--cantidad que son 'mayoristas'
select * from clientes 
	where tipo_cliente =  'mayorista';

--cuantas veces hizo logins del usuario admin
select * from IntentosLogin
 where USUARIO = 'admin';

--ventas con ingreso total (precio * cantidad) > 50,000
select * from ventas
	where (precio * cantidad) > 50000;

--ventas donde el stock es exactamente 0
select * from ventas 
	where stock_actual = 0;
-------------------------------------------------------------------------------------------------
/*Ahora utilizaremos ORDEN BY*/

--ventas de las mas cara a la mas barata
select * from ventas
	order by precio desc;

--productos ordenados alfabeticamente
select * from ventas 
	order by producto asc;

--logins ordenados por IP
select * from IntentosLogin
	order by ip_origen;

--ventas mas recientes
select * from ventas 
	order by fecha desc;

--ventas ordenadas por ciudad y luego por vendedor
select * from ventas 
order by ciudad, vendedor; 

--ventas con mayor cantridad vendida primero
select * from ventas 
	order by cantidad desc;

--clientes ordenados por tipo
select * from clientes
	order by tipo_cliente;

--logins fallidos ordenados por fecha
select * from IntentosLogin
	where EXITOSO = 'false'
	order by fecha_hora DESC;

--ventas por subtotal calculado
select *, (precio * cantidad) as total from ventas
	order by total desc;

--productos por ID(del mas nuevo al mas viejo)
select * from productos
	order by id_producto desc;

--ventas de monterrey ordenandas por precio
select * from ventas 
	where ciudad = 'Monterrey'
	order by precio desc;

--cleitnes ordenador por ciduad
select * from clientes 
order by ciudad asc;

--intentos de login del usuario 'user1' por fecha
select * from IntentosLogin 
	where usuario = 'user1'
	order by fecha_hora asc;