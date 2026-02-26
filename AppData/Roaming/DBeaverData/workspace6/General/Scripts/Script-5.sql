/*creacion de subloques, utilizamos la tabla de ventas y productos para
 extraer datos inteligentes*/

--Bloque 1: 10 subqueries(consultas anidadas)

--ventas cuyo precio es mayor al promedio
select * from ventas 
	where precio > (select avg(precio) from ventas);

--prodcutos que nunca han tenido una venta
select NOMBRE_PRODUCTO from productos
	where id_producto not in (select id_producto from ventas where id_producto is not null);
	
--el nombre del prdocuto mas caro vendido
select NOMBRE_PRODUCTO from productos 
	where id_producto = (select id_producto from ventas order by precio desc limit 1);

--ventas realizadas por el vendedor con mas antiguedad
select * from ventas 
	where vendedor = (select NOMBRE_USUARIO from usuario order by fecha_ingreso asc limit 1);

--listar ventas de productos que estan en la categoria 'Tecnologica'
select * from ventas
	where id_producto in (select id_producto from productos where NOMBRE_PRODUCTO in ('Laptop', 'Mouse', 'Monitor'));

--Clientes que viven en ciudades donde se han hecho ventas de mas de 10,000
select * from clientes 
	where ciudad in (select ciudad from ventas where precio > 10000);

--usuarios que han tenido intentos de login fallidos
select NOMBRE_USUARIO from usuario
	where nombre_usuario in (select USUARIO from intentoslogin where EXITOSO = true);

--mostrar ventas y columnas con el promedio general (sybquery en select)
select producto, precio, (select avg(precio) from ventas) as promedio_global
	from ventas;
--ventas del prodcuto con el stock mas bajo
select * from ventas 
	where id_producto = (select id_producto from ventas order by stock_actual asc limit 1);

--contar cuantos prodcutos unicos hay en ventas usando un subquery
select count(*) from (select distinct id_producto from ventas) 
	as productos_vendidos;

/*bloque 2 window funnctions utilizamos la clausula over para realizar calculos avanzados*/

--Raking de ventas por precio (sin agrupar)
select producto, precio, rank() over(order by precio desc) 
	as ranking_precio from ventas;

--suma acumulada de ventas por fecha
select fecha, precio, sum(precio) over(order by fecha) as suma_acumula
	from ventas;

--promedio de precio por categoria manteniendo las filas individuales
select producto, categoria, precio, avg(precio) over(partition by categoria) 
	as promedio_categoria from ventas;

--numerar los intentos de login de usuario cronologicamente
select usuario, fecha_hora, row_number() over(partition by usuario order by fecha_hora desc)
	as numero_intentos from intentoslogin
	
/*bloque 3 explain*/
--analizar busqueda simple
explain select * from ventas where ciudad = 'Monterrey';

--analizar un join
explain select v.*, p.nombre_producto from ventas v
	inner join productos p on v.id_producto = p.id_producto;

--analizar filtro por primary key
explain select * from productos
	where id_producto = 1;

--analizar un group by pesado
explain select categoria, sum(precio) from ventas
	group by categoria;

--analizar subquery
explain select * from ventas 
	where precio > (select AVG(precio) from ventas);