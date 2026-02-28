/*bloque 1*/

/*reporte de seguridad: identificar a todos los usuarios
 cuyo correo electronico sea 
 'https://www.google.com/url?sa=E&source=gmail&q=empresa.com' y que
 tenga el rol de cliente y en orden alfabetico*/

select nombre, email from usuario
	where email like '%@empresa.com' and rol = 'cliente'
	order by nombre asc;

/*Analisis de precios: el departamento de finanzas quiere aplica un impuesto
del 16%(IVA) a todos los prodcutos. muestra el nombre del producto,
el precio original y el precion con IVA*/
select producto_nombre, precio_unitario, (precio_unitario * 1.16) as precio_con_iva
	from productos;

/*Agregaciones: quien es el cliente que mas dinero ha gastado en total en la tienda,
muestra solo al ganador con su monto total*/
select u.nombre, sum(v.monto_total) as total_gastado from usuario u 
	join ventas v on u.usuario_id = v.usuario_id
	group by u.nombre 
order by total_gastado desc limit 1;	