drop database if exists clothinfs;
CREATE DATABASE clothinfs;
use clothinfs;
CREATE TABLE `clientes` (
	`Codigo_cliente` int NOT NULL AUTO_INCREMENT,
	`Nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
	DEFAULT NULL,
	`Apellidos` varchar(100) CHARACTER SET utf8mb4 COLLATE
	utf8mb4_general_ci DEFAULT NULL,
	`Direccion` varchar(100) CHARACTER SET utf8mb4 COLLATE
	utf8mb4_general_ci DEFAULT NULL,
	`Telefono` varchar(100) CHARACTER SET utf8mb4 COLLATE
	utf8mb4_general_ci DEFAULT NULL,
	PRIMARY KEY (`Codigo_cliente`)
	) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4
	COLLATE=utf8mb4_general_ci;
CREATE TABLE `empleado` (
	`Id_empleado` int NOT NULL AUTO_INCREMENT,
	`DNI` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
	DEFAULT NULL,
	`Nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
	DEFAULT NULL,
	`Telefono` varchar(100) CHARACTER SET utf8mb4 COLLATE
	utf8mb4_general_ci DEFAULT NULL,
	`Salario` double DEFAULT NULL,
	`Ser_jefe` int DEFAULT NULL,
	PRIMARY KEY (`Id_empleado`),
	KEY `empleado_FK` (`Ser_jefe`),
	CONSTRAINT `empleado_FK` FOREIGN KEY (`Ser_jefe`) REFERENCES
	`empleado` (`Id_empleado`)
	) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4
	COLLATE=utf8mb4_general_ci;
CREATE TABLE `pedidos` (
	`Fecha_pedido` date DEFAULT NULL,
	`Id_pedido` int NOT NULL AUTO_INCREMENT,
	`Id_empleado` int DEFAULT NULL,
	`Codigo_cliente` int DEFAULT NULL,
	`Codigo_pago` double NOT NULL,
	PRIMARY KEY (`Id_pedido`),
	KEY `Id_empleado_FK` (`Id_empleado`),
	KEY `Codigo_cliente_FK` (`Codigo_cliente`),
	CONSTRAINT `Codigo_cliente_FK` FOREIGN KEY (`Codigo_cliente`)
	REFERENCES `clientes` (`Codigo_cliente`),
	CONSTRAINT `Id_empleado_FK` FOREIGN KEY (`Id_empleado`) REFERENCES
	`empleado` (`Id_empleado`)
	) ENGINE=InnoDB AUTO_INCREMENT=401 DEFAULT CHARSET=utf8mb4
	COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `detalle_pedido` (
	`Id_pedido` int NOT NULL AUTO_INCREMENT,
	`Cantidad_prendas` int DEFAULT NULL,
	`Talla` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
	DEFAULT NULL,
	`prendas_stock` int DEFAULT NULL,
	PRIMARY KEY (`Id_pedido`),
	CONSTRAINT `Detalle_pedido_FK` FOREIGN KEY (`Id_pedido`) REFERENCES
	`pedidos` (`Id_pedido`)
	) ENGINE=InnoDB AUTO_INCREMENT=401 DEFAULT CHARSET=utf8mb4
	COLLATE=utf8mb4_general_ci;
CREATE TABLE `pago` (
	`Codigo_pago` double NOT NULL AUTO_INCREMENT,
	`IBAN_transferencia` varchar(100) CHARACTER SET utf8mb4 COLLATE
	utf8mb4_unicode_ci NOT NULL,
	`num_tarjeta` varchar(100) CHARACTER SET utf8mb4 COLLATE
	utf8mb4_unicode_ci NOT NULL,
	`tipo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
	DEFAULT NULL,
	`nombre_transferencia` varchar(100) CHARACTER SET utf8mb4 COLLATE
	utf8mb4_unicode_ci DEFAULT NULL,
	`apellidos_transferencia` varchar(100) CHARACTER SET utf8mb4 COLLATE
	utf8mb4_unicode_ci DEFAULT NULL,
	`fecha_cad` date DEFAULT NULL,
	PRIMARY KEY (`Codigo_pago`,`IBAN_transferencia`,`num_tarjeta`)
	) ENGINE=InnoDB AUTO_INCREMENT=401 DEFAULT CHARSET=utf8mb4
	COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `prendas` (
	`Codigo_prenda` int NOT NULL AUTO_INCREMENT,
	`Descripcion` varchar(100) CHARACTER SET utf8mb4 COLLATE
	utf8mb4_unicode_ci DEFAULT NULL,
	`Precio` double DEFAULT NULL,
	`NºExistencias` int DEFAULT NULL,
	PRIMARY KEY (`Codigo_prenda`)
	) ENGINE=InnoDB AUTO_INCREMENT=401 DEFAULT CHARSET=utf8mb4
	COLLATE=utf8mb4_unicode_ci;
CREATE TABLE `stock` (
	`Talla` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
	DEFAULT NULL,
	`prendas_stock` int DEFAULT NULL,
	`Codigo_prenda` int NOT NULL,
	KEY `Codigo_prenda_FK` (`Codigo_prenda`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
create table `registro_act_pagos`(
`Id_pedido` int(11) NOT NULL AUTO_INCREMENT,
`Cantidad_prendas` int(11) DEFAULT NULL,
`Talla` varchar(10) DEFAULT NULL,
`prendas_stock` int(11) DEFAULT NULL,
PRIMARY KEY (`Id_pedido`)
);