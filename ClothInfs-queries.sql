drop database if exists `clothinfs`;
CREATE DATABASE `clothinfs` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
use clothinfs;

CREATE TABLE `clientes` (
  `Codigo_cliente` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) DEFAULT NULL,
  `Apellidos` varchar(100) DEFAULT NULL,
  `Direccion` varchar(100) DEFAULT NULL,
  `Telefono` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`Codigo_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `detalle_pedido` (
  `Id_pedido` int(11) NOT NULL AUTO_INCREMENT,
  `Cantidad_prendas` int(11) DEFAULT NULL,
  `Talla` int(11) DEFAULT NULL,
  `prendas_stock` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id_pedido`),
  CONSTRAINT `Detalle_pedido_FK` FOREIGN KEY (`Id_pedido`) REFERENCES `pedidos` (`Id_pedido`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `empleado` (
  `Id_empleado` int(11) NOT NULL AUTO_INCREMENT,
  `DNI` varchar(100) DEFAULT NULL,
  `Nombre` varchar(100) DEFAULT NULL,
  `Telefono` varchar(100) DEFAULT NULL,
  `Salario` double DEFAULT NULL,
  `Ser_jefe` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id_empleado`),
  KEY `empleado_FK` (`Ser_jefe`),
  CONSTRAINT `empleado_FK` FOREIGN KEY (`Ser_jefe`) REFERENCES `empleado` (`Id_empleado`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `pago` (
  `Codigo_pago` double NOT NULL AUTO_INCREMENT,
  `IBAN_transferencia` varchar(100) NOT NULL,
  `num_tarjeta` varchar(100) NOT NULL,
  `tipo` varchar(100) DEFAULT NULL,
  `nombre_transferencia` varchar(100) DEFAULT NULL,
  `apellidos_transferencia` varchar(100) DEFAULT NULL,
  `nombre_credito` varchar(100) DEFAULT NULL,
  `apellidos_credito` varchar(100) DEFAULT NULL,
  `fecha_cad` varchar(100) DEFAULT NULL,
  `Id_pedido` int(11) DEFAULT NULL,
  PRIMARY KEY (`Codigo_pago`,`IBAN_transferencia`,`num_tarjeta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `pedidos` (
  `Fecha_pedido` date DEFAULT NULL,
  `Id_pedido` int(11) NOT NULL AUTO_INCREMENT,
  `Id_empleado` int(11) DEFAULT NULL,
  `Codigo_cliente` int(11) DEFAULT NULL,
  `Codigo_pago` double NOT NULL,
  PRIMARY KEY (`Id_pedido`),
  KEY `Id_empleado_FK` (`Id_empleado`),
  KEY `Codigo_cliente_FK` (`Codigo_cliente`),
  CONSTRAINT `Codigo_cliente_FK` FOREIGN KEY (`Codigo_cliente`) REFERENCES `clientes` (`Codigo_cliente`),
  CONSTRAINT `Id_empleado_FK` FOREIGN KEY (`Id_empleado`) REFERENCES `empleado` (`Id_empleado`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `prendas` (
  `Codigo_prenda` int(11) NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(100) DEFAULT NULL,
  `Precio` double DEFAULT NULL,
  `NºExistencias` int(11) DEFAULT NULL,
  PRIMARY KEY (`Codigo_prenda`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `registro_act_pagos` (
  `Id_pedido` int(11) NOT NULL AUTO_INCREMENT,
  `Cantidad_prendas` int(11) DEFAULT NULL,
  `Talla` int(11) DEFAULT NULL,
  `prendas_stock` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id_pedido`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `registro_del_prendas` (
  `Codigo_prenda` int(11) NOT NULL,
  `Descripcion` varchar(100) NOT NULL,
  `Precio` double DEFAULT NULL,
  `NºExistencias` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `stock` (
  `Talla` int(11) DEFAULT NULL,
  `Id_pedido` int(11) NOT NULL,
  `prendas_stock` int(11) DEFAULT NULL,
  `Codigo_prenda` int(11) DEFAULT NULL,
  KEY `Codigo_prenda_FK` (`Codigo_prenda`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;