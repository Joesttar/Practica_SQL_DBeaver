create database analsis;

/*Creamos tabla de ventas en donde se tiene el producto, categoria, precio, cantidad, stock_actual, fecha, ciudad, vendedor
 tambien  FORGEIN KEY(FK)*/
create table ventas(
	id_ventas SERIAL primary key,
	producto VARCHAR(50),
	categoria VARCHAR(50),
	precio DECIMAL(10, 2),
	cantidad INT,
	stock_actual INT,
	fecha DATE,
	ciudad VARCHAR(50),
	vendedor VARCHAR(50)
);

insert into ventas(producto, categoria, precio, cantidad, stock_actual, fecha, ciudad, vendedor) values 
('Laptop', 'Tecnologia', 15000, 2, 5, '2026-02-10', 'Monterrey', 'Carlos'),
('Mouse', 'Tecnologia', 2500, 2, 20, '2026-02-11', 'Monterrey', 'Carlos'),
('Silla', 'Muebles', 6000, 2, 1, '2026-02-12', 'Monterrey', 'Carlos'),
('Escritorio', 'Muebles', 20500, 2, 0, '2026-02-13', 'Monterrey', 'Carlos'),
('Monitor', 'Tecnologia', 8977, 2, 8, '2026-02-14', 'Monterrey', 'Carlos');

--Productos que se estan agotando, y filtramos resultados para saber que productos quedan que sea menor o igual a 2 
select producto, ciudad, stock_actual from ventas 
	where stock_actual <= 2;

/*Creamos una nueva categoria llamada ingreso_total y seleccionamos produdcto y categoria, todo esto desde la tabla de ventas
 y filtramos que ciudad queremos saber para saber su rendimineto.*/
select producto, categoria, (precio * cantidad) as ingreso_total from ventas
where ciudad = 'Monterrey'

--Creamos tabla de IntentosLogin donde el ID tiene un Primary Key(PK)
create table IntentosLogin(
	id_IntentosLogin SERIAL PRIMARY key,
	USUARIO VARCHAR(50),
	IP_ORIGEN VARCHAR(20),
	EXITOSO BOOLEAN,
	FECHA_HORA TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--DATOS DE PRUEBA 'SOSPECHOSA' TABLA DE SEGURIDAD
insert into IntentosLogin(USUARIO, IP_ORIGEN, EXITOSO) values
('admin', '192.168.1.58', false),
('admin', '192.168.1.58', false),
('admin', '192.168.1.58', True),
('user1', '10.0.0.5', True);

--DETECTAMOS QUIEN QUISO INGRESAR
select * from IntentosLogin
	where EXITOSO = true;
------------------------------------------------------------------------------------------------------------------------------------

--Creamos una tabla de productos para agregar una PK
create table productos(
	id_producto SERIAL primary key,
	NOMBRE_PRODUCTO VARCHAR(100) unique
);

--Intertamos los porductos que ya existen en la tabla de ventas sin ser repetitivas usando DISTICT
insert into productos(nombre_producto)
select distinct producto from ventas;

--agregamos nuestra columna que seria la FORGEIN KEY 
alter TABLE ventas add column id_producto INT;

--le decimos a la base de datos que busque el nombre del producto en la tabla nueva y que ponga su ID en la tabla de 'ventas'
update ventas v
set id_producto = p.id.producto from productos p
	where v.producto = p.nombre_producto;

---------------------------------------------------------------------------------------------------------------------------------

/*tabla de usuarios: es donde se almacenan la informacion de los usuario de la empresa, se agrega
una columna de rol y fecha_ingreso para analisis de antiguedad. Recordemos que sin el ID de usuario
al momento de que alguien escrita de alguna otra forma el nombre de este, en el reporte de ventas 
pueden dividirse las erroneamente*/
create table usuario(
	ID_USUARIO SERIAL primary key, 
	NOMBRE_USUARIO VARCHAR(100) not null,
	EMAIL VARCHAR(100) unique,
	ROL VARCHAR(50), --EJEMPLO: 'VENDEDOR', 'ADMIN'
	fecha_ingreso DATE default current_DATE 
);

--Ejemplo de como se insertaria un usuario nueva
insert into usuario(nombre_usuario, email, rol) values
('CARLOS HERRERA', 'CARLOS.H@EMPRESA.COM', 'VENDEDOR');

--Insertamos los valores de la tabla de CLIENTES, podemos analisar su ubicacion o tipo de cliente	
create table clientes(
	id_cliente SERIAL primary key,
	nombre_cliente VARCHAR(100) not null,
	tipo_cliente VARCHAR(50), --EJemplo: 'Retail', 'Mayorista'
	ciudad VARCHAR(50),
	telefono VARCHAR(20)
);

--Ejemplo de como se inserta un cliente nuevo
insert into clientes(nombre_cliente, tipo_cliente, ciudad, telefono) values
('TECNOMUNDO SA', 'MAYORISTA', 'MONTERREY', 8126294147);
--------------------------------------------------------------------------------------------------------------------------------







