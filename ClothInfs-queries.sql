-- CONSULTAS

-- CONSULTA 1 Obtener el número de pedidos realizados por cada empleado, incluyendo aquellos que no han realizado ningún pedido.

SELECT e.Nombre, COUNT(p.Id_pedido) as Numero_pedidos
FROM empleado e
LEFT JOIN pedidos p ON e.Id_empleado = p.Id_empleado
GROUP BY e.Id_empleado;


-- CONSULTA 2 Obtener los detalles de los pedidos junto con la información de los clientes y empleados asociados

SELECT p.Id_pedido, p.Fecha_pedido, c.Nombre AS Nombre_cliente, c.Apellidos AS Apellidos_cliente,
       e.Nombre AS Nombre_empleado, e.Telefono AS Telefono_empleado
FROM pedidos p
JOIN clientes c ON p.Codigo_cliente = c.Codigo_cliente
JOIN empleado e ON p.Id_empleado = e.Id_empleado;


-- CONSULTA 3 Obtiene la cantidad total de prendas vendidas para cada talla, sumando las cantidades de prendas
-- de la tabla detalle_pedido y agrupándolas por la talla correspondiente.

SELECT d.Talla, SUM(d.Cantidad_prendas) as Cantidad_vendida
FROM detalle_pedido d
INNER JOIN pedidos p ON d.Id_pedido = p.Id_pedido
GROUP BY d.Talla;


-- CONSULTA 4 Obtener la cantidad de pedidos realizados por cada cliente:

SELECT c.Codigo_cliente, c.Nombre, COUNT(p.Id_pedido) AS Cantidad_pedidos
FROM clientes c
LEFT JOIN pedidos p ON c.Codigo_cliente = p.Codigo_cliente
GROUP BY c.Codigo_cliente, c.Nombre;


-- CONSULTA 5 Obtener la lista de pedidos que fueron pagados mediante transferencia bancaria y la información de la cuenta de pago asociada:

SELECT pe.Id_pedido, pe.Fecha_pedido, pa.IBAN_transferencia, pa.num_tarjeta
FROM pedidos pe
JOIN pago pa ON pe.Codigo_pago = pa.Codigo_pago
WHERE pa.tipo = 'Transferencia';



-- VISTAS

-- VISTA 1 - Número de pedidos por empleado

CREATE VIEW pedidos_por_empleado AS
SELECT e.Nombre, COUNT(p.Id_pedido) as Numero_pedidos
FROM empleado e
LEFT JOIN pedidos p ON e.Id_empleado = p.Id_empleado
GROUP BY e.Id_empleado;

SELECT * FROM pedidos_por_empleado;


-- VISTA 2 - Calcula la cantidad total de prendas vendidas por talla, utilizando las tablas "detalle_pedido" y "pedidos".

CREATE VIEW total_prendas_vendidas AS
SELECT d.Talla, SUM(d.Cantidad_prendas) AS Cantidad_vendida
FROM detalle_pedido d
INNER JOIN pedidos p ON d.Id_pedido = p.Id_pedido
GROUP BY d.Talla;

SELECT * FROM total_prendas_vendidas;



-- FUNCIONES

-- FUNCION 1 - Devuelve el número total de clientes distintos que realizaron pedidos en el último mes.

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
END //
DELIMITER ;

SELECT total_clientes_ultimo_mes();

-- FUNCION 2 - Obtener el número total de prendas en stock por talla (en este caso ‘M’):

DELIMITER //
CREATE FUNCTION `total_prendas_stock_por_talla` (talla VARCHAR(2))
RETURNS INT
BEGIN
    DECLARE total_prendas INT;
    SELECT SUM(s.prendas_stock) INTO total_prendas
    FROM stock s
    WHERE s.Talla COLLATE utf8mb4_unicode_ci = talla COLLATE utf8mb4_unicode_ci;
    RETURN total_prendas;
END//
DELIMITER ;

SELECT total_prendas_stock_por_talla('M');


-- PROCEDIMIENTOS

-- PROCEDIMIENTO 1 Procedimiento que utiliza la función total_clientes_ultimo_mes para 
-- obtener el número de clientes que han hecho un pedido en el último mes:


DELIMITER //
CREATE PROCEDURE clientes_ultimo_mes ()
BEGIN
    DECLARE total_clientes INT;
    SET total_clientes = total_clientes_ultimo_mes();
    SELECT CONCAT('El número de clientes que han hecho un pedido en el último mes es: ', total_clientes) AS Resultado;
END//
DELIMITER ;

CALL clientes_ultimo_mes();


-- PROCEDIMIENTO 2 Procedimiento que utiliza la función total_clientes_ultimo_mes para 
-- obtener el número de clientes que han hecho un pedido en el último mes:

DELIMITER //
CREATE PROCEDURE `prendas_en_stock` (IN talla VARCHAR(2))
BEGIN
    DECLARE total_prendas INT;
    SET total_prendas = total_prendas_stock_por_talla(talla COLLATE utf8mb4_unicode_ci);
    SELECT CONCAT('El número total de prendas en stock para la talla ', talla, ' es: ', total_prendas) AS Resultado;
END//
DELIMITER ;

CALL prendas_en_stock('M');
CALL prendas_en_stock('S');
CALL prendas_en_stock('L');
CALL prendas_en_stock('XL');


-- PROCEDIMIENTO 3  Este procedimiento tiene como objetivo calcular y mostrar estadísticas relacionadas con las ventas.

DELIMITER &&



CREATE PROCEDURE mostrar_estadisticas()

BEGIN

   DECLARE salida VARCHAR(10000) DEFAULT '========ESTADISTICAS=======\n-----------Totales-------\nVentas Totales: ';

   DECLARE total DECIMAL(15,2);

   DECLARE done BOOL DEFAULT FALSE;

   DECLARE anio INTEGER;

   DECLARE contador INTEGER DEFAULT 1;

   DECLARE contador2 INTEGER DEFAULT 1;

   DECLARE dia VARCHAR(20) DEFAULT '';

   DECLARE mes VARCHAR(20) DEFAULT '';

   DECLARE c1 CURSOR FOR  -- CURSOR DE AÑOS

       SELECT YEAR(p.Fecha_pedido) AS Anio, ROUND(SUM(p2.precio * dp.Cantidad_prendas), 2) AS Total

		FROM pedidos p

		INNER JOIN detalle_pedido dp ON p.Id_pedido = dp.Id_pedido COLLATE utf8mb4_general_ci

		INNER JOIN stock s ON dp.Talla = s.Talla COLLATE utf8mb4_general_ci

		INNER JOIN prendas p2 ON s.Codigo_prenda = p2.Codigo_prenda COLLATE utf8mb4_general_ci

		GROUP BY YEAR(p.Fecha_pedido);

   DECLARE c2 CURSOR FOR   -- CURSOR DIAS

       SELECT DAYNAME(p.Fecha_pedido) AS Dia, ROUND(SUM(p2.precio * dp.Cantidad_prendas), 2) AS Total

		FROM pedidos p

		INNER JOIN detalle_pedido dp ON p.Id_pedido = dp.Id_pedido COLLATE utf8mb4_general_ci

		INNER JOIN stock s ON dp.Talla = s.Talla COLLATE utf8mb4_general_ci

		INNER JOIN prendas p2 ON s.Codigo_prenda = p2.Codigo_prenda COLLATE utf8mb4_general_ci

		GROUP BY Dia

		ORDER BY DAYOFWEEK(p.Fecha_pedido) ASC;

   DECLARE c3 CURSOR FOR   -- CURSOR MESES

       SELECT MONTHNAME(p.Fecha_pedido) AS Mes, ROUND(SUM(p2.precio * dp.Cantidad_prendas), 2) AS Total

		FROM pedidos p

		INNER JOIN detalle_pedido dp ON p.Id_pedido = dp.Id_pedido COLLATE utf8mb4_general_ci

		INNER JOIN stock s ON dp.Talla = s.Talla COLLATE utf8mb4_general_ci

		INNER JOIN prendas p2 ON s.Codigo_prenda = p2.Codigo_prenda COLLATE utf8mb4_general_ci

		GROUP BY MONTHNAME(p.Fecha_pedido)

		ORDER BY MONTH(p.Fecha_pedido) ASC;

   DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;   -- para salir del bucle del cursor



   SELECT SUM(p2.precio * dp.Cantidad_prendas) INTO @total

		FROM pedidos p

		INNER JOIN detalle_pedido dp ON p.Id_pedido = dp.Id_pedido COLLATE utf8mb4_general_ci

		INNER JOIN stock s ON dp.Talla = s.Talla COLLATE utf8mb4_general_ci

		INNER JOIN prendas p2 ON s.Codigo_prenda = p2.Codigo_prenda COLLATE utf8mb4_general_ci;



   SET salida = CONCAT(salida, @total, '€\n');



   OPEN c1;    -- recorremos el cursor de años

   FETCH c1 INTO anio, total;

   WHILE (NOT done) DO

       SET salida = CONCAT(salida, 'En ', anio, ': ', total, '€\n');

       FETCH c1 INTO anio, total;

   END WHILE;

   CLOSE c1;



   SET salida = CONCAT(salida, '=============LISTADOS==========\n');

   SET salida = CONCAT(salida, '----------Valor de las ventas por día--------\n');

   SET done = FALSE;     -- hay que iniciarlo otra vez porque lo cambiamos a true antes

   OPEN c2;

   FETCH c2 INTO dia, total;

   WHILE (NOT done) DO

       SET salida = CONCAT(salida, contador, '.', dia, ': ', total, '€\n');

       SET contador = contador + 1;

       FETCH c2 INTO dia, total;

   END WHILE;

   CLOSE c2;



   SET salida = CONCAT(salida, '----------Valor de las ventas por mes--------\n');

   SET done = FALSE;        -- hay que iniciarlo otra vez porque lo cambiamos a true antes

   OPEN c3;   -- RECORREMOS EL CURSOR DE MESES

   FETCH c3 INTO mes, total;

   WHILE (NOT done) DO

       SET salida = CONCAT(salida, contador2, '.', mes, ': ', total, '€\n');

       SET contador2 = contador2 + 1;

       FETCH c3 INTO mes, total;

   END WHILE;

   CLOSE c3;



   SET salida = CONCAT(salida, '===============================\n');

  

   SELECT salida;

END &&



DELIMITER ;



CALL mostrar_estadisticas();


-- TRIGGERS

-- TRIGGER 1 El trigger se activa después de la inserción de un detalle_pedido, 
-- y añade este nuevo pedido es una nueva tabla que he creado llamada registro_act_pagos:


DELIMITER //
CREATE TRIGGER tr_pago_insert AFTER INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
	insert into registro_act_pagos (`Id_pedido`,`Cantidad_prendas`,`Talla`,`prendas_stock`)
	VALUES(new.Id_pedido,new.Cantidad_prendas,new.Talla,new.prendas_stock);
end//
DELIMITER ;


-- TRIGGER 2 Aumenta el salario de un empleado en un 10% antes de insertar o actualizar un registro en la tabla "empleado".

DELIMITER //

CREATE TRIGGER tr_actualizar_salario_insert BEFORE INSERT ON empleado
FOR EACH ROW
BEGIN
    DECLARE nuevo_salario DOUBLE;
    
    -- Calcula el nuevo salario del empleado en base a algún criterio
    SET nuevo_salario = NEW.Salario * 1.1; -- Aumento del 10%
    
    -- Actualiza el salario del empleado en el nuevo registro
    SET NEW.Salario = nuevo_salario;
END //

CREATE TRIGGER tr_actualizar_salario_update BEFORE UPDATE ON empleado
FOR EACH ROW
BEGIN
    DECLARE nuevo_salario DOUBLE;
    
    -- Calcula el nuevo salario del empleado en base a algún criterio
    SET nuevo_salario = NEW.Salario * 1.1; -- Aumento del 10%
    
    -- Actualiza el salario del empleado en el registro actualizado
    SET NEW.Salario = nuevo_salario;
END //

DELIMITER ;

-- Ejemplo de uso del trigger tr_actualizar_salario_insert

-- Insertar un nuevo empleado
INSERT INTO empleado (DNI, Nombre, Telefono, Salario, Ser_jefe)
VALUES ('123456789', 'Juan Pérez', '555-1234', 2000, NULL);

-- El trigger se ejecutará automáticamente y actualizará el salario del nuevo empleado.

-- Consultar el nuevo salario del empleado
SELECT Salario FROM empleado WHERE DNI = '123456789';


-- Ejemplo de uso del trigger tr_actualizar_salario_update

-- Actualizar el salario de un empleado existente
UPDATE empleado SET Salario = 2500 WHERE DNI = '123456789';

-- El trigger se ejecutará automáticamente y actualizará el nuevo salario del empleado.

-- Consultar el nuevo salario del empleado
SELECT Salario FROM empleado WHERE DNI = '123456789';