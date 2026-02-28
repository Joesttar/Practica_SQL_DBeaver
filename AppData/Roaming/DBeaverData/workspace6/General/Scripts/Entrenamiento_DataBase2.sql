--Creacion de base de datos nueva
CREATE database entrenamiento_database;

--1. Creacion de tabla base para usuarios
create table usuario(
	usuario_id SERIAL primary key, 
	nombre varchar(100),
	email varchar(100),
	rol varchar(20) default 'cliente',
	fecha_registro date default current_DATE
);

--2. Creacion de tabla para los prodcutos
create table productos(
	producto_id SERIAL primary key,
	producto_nombre varchar(100) not null,
	categoria varchar(50),
	precio_unitario DECIMAL(10, 2) check (precio_unitario > 0)
);

--3, Creacion de tabla para las ventas
create table ventas(
	ventas_id SERIAL primary key,
	usuario_id INT references usuario(usuario_id),
	producto_id INT references productos(producto_id),
	cantidad INT default 1,
	monto_total DECIMAL(10,2),
	fecha_venta TIMESTAMP default current_timestamp
);

--4. Cargar datos de prueba
insert into usuario (nombre, email, rol) values
	('Carlos Rodriguez', 'carlos@empresa.com', 'admin'),
	('Ana Gonzales', 'ana@empresa.com', 'cliente'),
	('Mario Bicente', 'mario@empresa.com', 'cliente');

insert into productos (producto_nombre, categoria, precio_unitario) values
	('Laptop Nitro', 'Electronica', 1200.00),
	('Mouse Pr', 'Electronica', 50.00);