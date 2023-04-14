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

-- Consulta 1

SELECT e.Nombre, COUNT(p.Id_pedido) as Numero_pedidos
FROM empleado e
LEFT JOIN pedidos p ON e.Id_empleado = p.Id_empleado
GROUP BY e.Id_empleado;

-- Consulta 2

SELECT c.Nombre, c.Apellidos, COUNT(*) as Numero_pedidos
FROM clientes c
INNER JOIN pedidos p ON c.Codigo_cliente = p.Codigo_cliente
GROUP BY c.Codigo_cliente
ORDER BY Numero_pedidos DESC;

-- Consulta 3

SELECT d.Talla, SUM(d.Cantidad_prendas) as Cantidad_vendida
FROM detalle_pedido d
INNER JOIN pedidos p ON d.Id_pedido = p.Id_pedido
GROUP BY d.Talla;

-- Consulta 4

SELECT AVG(Salario) as Salario_medio
FROM empleado
WHERE Ser_jefe IS NULL AND Salario > (
  SELECT AVG(Salario) 
  FROM empleado);

-- Consulta 5

SELECT p.Codigo_prenda, p.Descripcion, s.Talla, SUM(s.prendas_stock) as Cantidad_total
FROM prendas p 
INNER JOIN stock s ON p.Codigo_prenda = s.Codigo_prenda
GROUP BY p.Codigo_prenda, s.Talla
ORDER BY Cantidad_total DESC;

-- Vista 1

CREATE VIEW pedidos_por_empleado AS
SELECT e.Nombre, COUNT(p.Id_pedido) as Numero_pedidos
FROM empleado e
LEFT JOIN pedidos p ON e.Id_empleado = p.Id_empleado
GROUP BY e.Id_empleado;

SELECT * FROM pedidos_por_empleado;

-- Vista 2

CREATE VIEW pedidos_por_cliente AS
SELECT c.Nombre, c.Apellidos, COUNT(*) as Numero_pedidos
FROM clientes c
INNER JOIN pedidos p ON c.Codigo_cliente = p.Codigo_cliente
GROUP BY c.Codigo_cliente
ORDER BY Numero_pedidos DESC;

SELECT * FROM pedidos_por_cliente;

-- Funcion 1

DELIMITER //
CREATE FUNCTION `total_clientes_ultimo_mes` ()
RETURNS INT
BEGIN
    DECLARE fecha_limite DATE;
    DECLARE total_clientes INT;
    SET fecha_limite = DATE_SUB(NOW(), INTERVAL 1 MONTH);
    SELECT COUNT(DISTINCT p.Codigo_cliente) INTO total_clientes
    FROM pedidos p
    WHERE p.Fecha_pedido >= fecha_limite;
    RETURN total_clientes;
END//
DELIMITER ;
SELECT total_clientes_ultimo_mes();

-- Funcion 2 

DELIMITER //
CREATE FUNCTION `total_prendas_stock_por_talla` (talla INT)
RETURNS INT
BEGIN
    DECLARE total_prendas INT;
    SELECT SUM(s.prendas_stock) INTO total_prendas
    FROM stock s
    WHERE s.Talla = talla;
    RETURN total_prendas;
END//
DELIMITER ;
			SELECT total_prendas_stock_por_talla(2);

-- Procedimiento 1

DELIMITER //
CREATE PROCEDURE `clientes_ultimo_mes` ()
BEGIN
    DECLARE total_clientes INT;
    SET total_clientes = total_clientes_ultimo_mes();
    SELECT CONCAT('El número de clientes que han hecho un pedido en el último mes es: ', total_clientes) AS Resultado;
END//
DELIMITER ;
CALL clientes_ultimo_mes();


-- Procedimiento 2 

DELIMITER //
CREATE PROCEDURE `prendas_en_stock` (IN talla INT)
BEGIN
    DECLARE total_prendas INT;
    SET total_prendas = total_prendas_stock_por_talla(talla);
    SELECT CONCAT('El número total de prendas en stock para la talla ', talla, ' es: ', total_prendas) AS Resultado;
END//
DELIMITER ;
CALL prendas_en_stock(42);

-- Procedimiento 3 

DELIMITER //
CREATE PROCEDURE mostrar_clientes_pedidos()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE codigo_cliente INT;
  DECLARE nombre_cliente VARCHAR(100);
  DECLARE apellidos_cliente VARCHAR(100);
  DECLARE cur CURSOR FOR SELECT Codigo_cliente FROM pedidos;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur;
  read_loop: LOOP
    FETCH cur INTO codigo_cliente;
    IF done THEN
      LEAVE read_loop;
    END IF;
    SELECT Nombre, Apellidos INTO nombre_cliente, apellidos_cliente FROM clientes WHERE Codigo_cliente = codigo_cliente;
    SELECT CONCAT(nombre_cliente, ' ', apellidos_cliente) AS nombre_completo;
  END LOOP;
  CLOSE cur;
END //
DELIMITER ;
CALL mostrar_clientes_pedidos();

-- Trigger 1

DELIMITER //
CREATE TRIGGER tr_pago_insert AFTER INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
	insert into registro_act_pagos (`Id_pedido`,`Cantidad_prendas`,`Talla`,`prendas_stock`)
	VALUES(new.Id_pedido,new.Cantidad_prendas,new.Talla,new.prendas_stock);
end//
DELIMITER ;

-- Trigger 2

DELIMITER //
CREATE TRIGGER tr_prendas_delete AFTER DELETE ON prendas
FOR EACH ROW
BEGIN
    insert into registro_del_prendas (`Codigo_prenda`,`Descripcion`,`Precio`,`NºExistencias`)
	VALUES(old.Codigo_prenda,old.Descripcion,old.Precio,old.NºExistencias);
end //
DELIMITER ;

