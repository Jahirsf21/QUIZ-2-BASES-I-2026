USE Hoteleria;
GO

/* =========================
	 CATALOGOS
	 ========================= */

INSERT INTO Estado_Pago (Estado_Pago)
SELECT V.Estado
FROM (VALUES ('pendiente'), ('cancelado'), ('completado')) AS V(Estado)
WHERE NOT EXISTS (
		SELECT 1
		FROM Estado_Pago EP
		WHERE EP.Estado_Pago = V.Estado
);

INSERT INTO Metodo_Pago (Metodo)
SELECT V.Metodo
FROM (VALUES ('efectivo'), ('tarjeta'), ('transferencia')) AS V(Metodo)
WHERE NOT EXISTS (
		SELECT 1
		FROM Metodo_Pago MP
		WHERE MP.Metodo = V.Metodo
);

INSERT INTO Tipo_Habitacion (Tipo)
SELECT V.Tipo
FROM (VALUES ('estándar'), ('doble'), ('suite')) AS V(Tipo)
WHERE NOT EXISTS (
		SELECT 1
		FROM Tipo_Habitacion TH
		WHERE TH.Tipo = V.Tipo
);

INSERT INTO Estado_Habitacion (Estado)
SELECT V.Estado
FROM (VALUES ('disponible'), ('ocupada'), ('en mantenimiento')) AS V(Estado)
WHERE NOT EXISTS (
		SELECT 1
		FROM Estado_Habitacion EH
		WHERE EH.Estado = V.Estado
);

INSERT INTO Estado_Reserva (Estado_Reserva)
SELECT V.Estado
FROM (VALUES ('confirmada'), ('cancelada'), ('finalizada')) AS V(Estado)
WHERE NOT EXISTS (
		SELECT 1
		FROM Estado_Reserva ER
		WHERE ER.Estado_Reserva = V.Estado
);

INSERT INTO Nacionalidad (Nacionalidad)
SELECT V.Nacionalidad
FROM (VALUES ('costarricense'), ('mexicana')) AS V(Nacionalidad)
WHERE NOT EXISTS (
		SELECT 1
		FROM Nacionalidad N
		WHERE N.Nacionalidad = V.Nacionalidad
);

INSERT INTO Servicio (Nombre_Servicio, Descripcion, Tarifa)
SELECT V.Nombre_Servicio, V.Descripcion, V.Tarifa
FROM (
		VALUES
				('Spa', 'Acceso al area de spa', 35.00),
				('Desayuno', 'Desayuno buffet', 12.00)
) AS V(Nombre_Servicio, Descripcion, Tarifa)
WHERE NOT EXISTS (
		SELECT 1
		FROM Servicio S
		WHERE S.Nombre_Servicio = V.Nombre_Servicio
);

/* =========================
	 CLIENTES Y CONTACTO
	 ========================= */

INSERT INTO Cliente (Identificacion, nombre, primer_apellido, segundo_apellido, Correo_Electronico)
SELECT V.Identificacion, V.nombre, V.primer_apellido, V.segundo_apellido, V.Correo_Electronico
FROM (
		VALUES
				('101010101', 'Ana', 'Perez', NULL, 'ana@yahoo.com'),
				('202020202', 'Mario', 'Lopez', 'Rojas', 'mario@yahoo.com'),
				('303030303', 'Carla', 'Mora', 'Solis', 'carla@gmail.com')
) AS V(Identificacion, nombre, primer_apellido, segundo_apellido, Correo_Electronico)
WHERE NOT EXISTS (
		SELECT 1
		FROM Cliente C
		WHERE C.Identificacion = V.Identificacion
);

INSERT INTO Cliente_Nacionalidad (ID_Cliente, ID_Nacionalidad)
SELECT C.ID_Cliente, N.ID_Nacionalidad
FROM Cliente C
JOIN Nacionalidad N ON N.Nacionalidad = 'costarricense'
WHERE C.Identificacion = '101010101'
	AND NOT EXISTS (
			SELECT 1
			FROM Cliente_Nacionalidad CN
			WHERE CN.ID_Cliente = C.ID_Cliente
				AND CN.ID_Nacionalidad = N.ID_Nacionalidad
	);

INSERT INTO Cliente_Nacionalidad (ID_Cliente, ID_Nacionalidad)
SELECT C.ID_Cliente, N.ID_Nacionalidad
FROM Cliente C
JOIN Nacionalidad N ON N.Nacionalidad = 'mexicana'
WHERE C.Identificacion = '202020202'
	AND NOT EXISTS (
			SELECT 1
			FROM Cliente_Nacionalidad CN
			WHERE CN.ID_Cliente = C.ID_Cliente
				AND CN.ID_Nacionalidad = N.ID_Nacionalidad
	);

INSERT INTO Cliente_Nacionalidad (ID_Cliente, ID_Nacionalidad)
SELECT C.ID_Cliente, N.ID_Nacionalidad
FROM Cliente C
JOIN Nacionalidad N ON N.Nacionalidad = 'costarricense'
WHERE C.Identificacion = '303030303'
	AND NOT EXISTS (
			SELECT 1
			FROM Cliente_Nacionalidad CN
			WHERE CN.ID_Cliente = C.ID_Cliente
				AND CN.ID_Nacionalidad = N.ID_Nacionalidad
	);

INSERT INTO Telefono (ID_Cliente, Telefono)
SELECT C.ID_Cliente, V.Telefono
FROM Cliente C
JOIN (
		VALUES
				('101010101', '88881111'),
				('202020202', '88882222'),
				('303030303', '88883333')
) AS V(Identificacion, Telefono)
		ON C.Identificacion = V.Identificacion
WHERE NOT EXISTS (
		SELECT 1
		FROM Telefono T
		WHERE T.ID_Cliente = C.ID_Cliente
			AND T.Telefono = V.Telefono
);

/* =========================
	 HABITACIONES
	 ========================= */

INSERT INTO Habitacion (ID_Tipo_Habitacion, ID_Estado_Habitacion, cantidad_de_personas, precio_por_noche)
SELECT TH.ID_Tipo_Habitacion, EH.ID_Estado_Habitacion, V.cantidad_de_personas, V.precio_por_noche
FROM (
		VALUES
				('estándar', 'disponible', 2, 65.00),
				('doble', 'ocupada', 4, 95.00),
				('suite', 'en mantenimiento', 2, 180.00)
) AS V(Tipo, Estado, cantidad_de_personas, precio_por_noche)
JOIN Tipo_Habitacion TH ON TH.Tipo = V.Tipo
JOIN Estado_Habitacion EH ON EH.Estado = V.Estado
WHERE NOT EXISTS (
		SELECT 1
		FROM Habitacion H
		WHERE H.ID_Tipo_Habitacion = TH.ID_Tipo_Habitacion
			AND H.ID_Estado_Habitacion = EH.ID_Estado_Habitacion
			AND H.cantidad_de_personas = V.cantidad_de_personas
			AND H.precio_por_noche = V.precio_por_noche
);

/* =========================
	 RESERVACIONES
	 ========================= */

INSERT INTO Reservacion (ID_Cliente, fecha_inicio, fecha_fin, check_in, check_out)
SELECT C.ID_Cliente, V.fecha_inicio, V.fecha_fin, V.check_in, V.check_out
FROM Cliente C
JOIN (
		VALUES
				('101010101', CAST('2026-03-10' AS DATE), CAST('2026-03-12' AS DATE), CAST('2026-03-10T15:00:00' AS DATETIME), CAST('2026-03-12T11:00:00' AS DATETIME)),
				('202020202', CAST('2026-08-20' AS DATE), CAST('2026-08-22' AS DATE), CAST('2026-08-20T14:00:00' AS DATETIME), CAST('2026-08-22T12:00:00' AS DATETIME)),
				('202020202', CAST('2027-01-15' AS DATE), CAST('2027-01-17' AS DATE), CAST('2027-01-15T13:00:00' AS DATETIME), CAST('2027-01-17T11:00:00' AS DATETIME)),
				('303030303', CAST('2027-01-15' AS DATE), CAST('2027-01-18' AS DATE), CAST('2027-01-15T16:00:00' AS DATETIME), CAST('2027-01-18T10:00:00' AS DATETIME))
) AS V(Identificacion, fecha_inicio, fecha_fin, check_in, check_out)
		ON C.Identificacion = V.Identificacion
WHERE NOT EXISTS (
		SELECT 1
		FROM Reservacion R
		WHERE R.ID_Cliente = C.ID_Cliente
			AND R.fecha_inicio = V.fecha_inicio
			AND R.fecha_fin = V.fecha_fin
			AND R.check_in = V.check_in
			AND R.check_out = V.check_out
);

INSERT INTO Habitacion_Reservaciones (ID_habitacion, ID_reservacion)
SELECT TOP (1) H.ID_habitacion, R.ID_Reservacion
FROM Reservacion R
JOIN Cliente C ON C.ID_Cliente = R.ID_Cliente
JOIN Habitacion H ON 1 = 1
JOIN Tipo_Habitacion TH ON TH.ID_Tipo_Habitacion = H.ID_Tipo_Habitacion
WHERE C.Identificacion = '101010101'
	AND R.fecha_inicio = '2026-03-10'
	AND TH.Tipo = 'estándar'
	AND NOT EXISTS (
			SELECT 1
			FROM Habitacion_Reservaciones HR
			WHERE HR.ID_habitacion = H.ID_habitacion
				AND HR.ID_reservacion = R.ID_Reservacion
	)
ORDER BY H.ID_habitacion;

INSERT INTO Habitacion_Reservaciones (ID_habitacion, ID_reservacion)
SELECT TOP (1) H.ID_habitacion, R.ID_Reservacion
FROM Reservacion R
JOIN Cliente C ON C.ID_Cliente = R.ID_Cliente
JOIN Habitacion H ON 1 = 1
JOIN Tipo_Habitacion TH ON TH.ID_Tipo_Habitacion = H.ID_Tipo_Habitacion
WHERE C.Identificacion = '202020202'
	AND R.fecha_inicio = '2026-08-20'
	AND TH.Tipo = 'doble'
	AND NOT EXISTS (
			SELECT 1
			FROM Habitacion_Reservaciones HR
			WHERE HR.ID_habitacion = H.ID_habitacion
				AND HR.ID_reservacion = R.ID_Reservacion
	)
ORDER BY H.ID_habitacion;

INSERT INTO Habitacion_Reservaciones (ID_habitacion, ID_reservacion)
SELECT TOP (1) H.ID_habitacion, R.ID_Reservacion
FROM Reservacion R
JOIN Cliente C ON C.ID_Cliente = R.ID_Cliente
JOIN Habitacion H ON 1 = 1
JOIN Tipo_Habitacion TH ON TH.ID_Tipo_Habitacion = H.ID_Tipo_Habitacion
WHERE C.Identificacion = '202020202'
	AND R.fecha_inicio = '2027-01-15'
	AND R.check_in = '2027-01-15T13:00:00'
	AND TH.Tipo = 'estándar'
	AND NOT EXISTS (
			SELECT 1
			FROM Habitacion_Reservaciones HR
			WHERE HR.ID_habitacion = H.ID_habitacion
				AND HR.ID_reservacion = R.ID_Reservacion
	)
ORDER BY H.ID_habitacion;

INSERT INTO Habitacion_Reservaciones (ID_habitacion, ID_reservacion)
SELECT TOP (1) H.ID_habitacion, R.ID_Reservacion
FROM Reservacion R
JOIN Cliente C ON C.ID_Cliente = R.ID_Cliente
JOIN Habitacion H ON 1 = 1
JOIN Tipo_Habitacion TH ON TH.ID_Tipo_Habitacion = H.ID_Tipo_Habitacion
WHERE C.Identificacion = '303030303'
	AND R.fecha_inicio = '2027-01-15'
	AND TH.Tipo = 'suite'
	AND NOT EXISTS (
			SELECT 1
			FROM Habitacion_Reservaciones HR
			WHERE HR.ID_habitacion = H.ID_habitacion
				AND HR.ID_reservacion = R.ID_Reservacion
	)
ORDER BY H.ID_habitacion;

INSERT INTO Estado_Reserva_IT (ID_Reservacion, ID_Estado_Reserva)
SELECT R.ID_Reservacion, ER.ID_Estado_Reserva
FROM Reservacion R
JOIN Cliente C ON C.ID_Cliente = R.ID_Cliente
JOIN Estado_Reserva ER ON ER.Estado_Reserva = 'finalizada'
WHERE C.Identificacion = '101010101'
	AND R.fecha_inicio = '2026-03-10'
	AND NOT EXISTS (
			SELECT 1
			FROM Estado_Reserva_IT ERT
			WHERE ERT.ID_Reservacion = R.ID_Reservacion
				AND ERT.ID_Estado_Reserva = ER.ID_Estado_Reserva
	);

INSERT INTO Estado_Reserva_IT (ID_Reservacion, ID_Estado_Reserva)
SELECT R.ID_Reservacion, ER.ID_Estado_Reserva
FROM Reservacion R
JOIN Cliente C ON C.ID_Cliente = R.ID_Cliente
JOIN Estado_Reserva ER ON ER.Estado_Reserva = 'confirmada'
WHERE C.Identificacion = '202020202'
	AND R.fecha_inicio = '2026-08-20'
	AND NOT EXISTS (
			SELECT 1
			FROM Estado_Reserva_IT ERT
			WHERE ERT.ID_Reservacion = R.ID_Reservacion
				AND ERT.ID_Estado_Reserva = ER.ID_Estado_Reserva
	);

INSERT INTO Estado_Reserva_IT (ID_Reservacion, ID_Estado_Reserva)
SELECT R.ID_Reservacion, ER.ID_Estado_Reserva
FROM Reservacion R
JOIN Cliente C ON C.ID_Cliente = R.ID_Cliente
JOIN Estado_Reserva ER ON ER.Estado_Reserva = 'confirmada'
WHERE C.Identificacion = '202020202'
	AND R.fecha_inicio = '2027-01-15'
	AND R.check_in = '2027-01-15T13:00:00'
	AND NOT EXISTS (
			SELECT 1
			FROM Estado_Reserva_IT ERT
			WHERE ERT.ID_Reservacion = R.ID_Reservacion
				AND ERT.ID_Estado_Reserva = ER.ID_Estado_Reserva
	);

INSERT INTO Estado_Reserva_IT (ID_Reservacion, ID_Estado_Reserva)
SELECT R.ID_Reservacion, ER.ID_Estado_Reserva
FROM Reservacion R
JOIN Cliente C ON C.ID_Cliente = R.ID_Cliente
JOIN Estado_Reserva ER ON ER.Estado_Reserva = 'cancelada'
WHERE C.Identificacion = '303030303'
	AND R.fecha_inicio = '2027-01-15'
	AND NOT EXISTS (
			SELECT 1
			FROM Estado_Reserva_IT ERT
			WHERE ERT.ID_Reservacion = R.ID_Reservacion
				AND ERT.ID_Estado_Reserva = ER.ID_Estado_Reserva
	);

/* =========================
	 PAGOS
	 ========================= */

INSERT INTO Pago (ID_Reservacion, Monto, Fecha_Pago)
SELECT R.ID_Reservacion, 250.00, '2026-03-10'
FROM Reservacion R
JOIN Cliente C ON C.ID_Cliente = R.ID_Cliente
WHERE C.Identificacion = '101010101'
	AND R.fecha_inicio = '2026-03-10'
	AND NOT EXISTS (
			SELECT 1
			FROM Pago P
			WHERE P.ID_Reservacion = R.ID_Reservacion
				AND P.Monto = 250.00
				AND P.Fecha_Pago = '2026-03-10'
	);

INSERT INTO Pago (ID_Reservacion, Monto, Fecha_Pago)
SELECT R.ID_Reservacion, 50.00, '2026-03-11'
FROM Reservacion R
JOIN Cliente C ON C.ID_Cliente = R.ID_Cliente
WHERE C.Identificacion = '101010101'
	AND R.fecha_inicio = '2026-03-10'
	AND NOT EXISTS (
			SELECT 1
			FROM Pago P
			WHERE P.ID_Reservacion = R.ID_Reservacion
				AND P.Monto = 50.00
				AND P.Fecha_Pago = '2026-03-11'
	);

INSERT INTO Pago (ID_Reservacion, Monto, Fecha_Pago)
SELECT R.ID_Reservacion, 500.00, '2027-01-15'
FROM Reservacion R
JOIN Cliente C ON C.ID_Cliente = R.ID_Cliente
WHERE C.Identificacion = '303030303'
	AND R.fecha_inicio = '2027-01-15'
	AND NOT EXISTS (
			SELECT 1
			FROM Pago P
			WHERE P.ID_Reservacion = R.ID_Reservacion
				AND P.Monto = 500.00
				AND P.Fecha_Pago = '2027-01-15'
	);

INSERT INTO Pago_Metodo_Pago (ID_Pago, ID_Metodo_Pago)
SELECT P.ID_Pago, MP.ID_Metodo_Pago
FROM Pago P
JOIN Reservacion R ON R.ID_Reservacion = P.ID_Reservacion
JOIN Cliente C ON C.ID_Cliente = R.ID_Cliente
JOIN Metodo_Pago MP ON MP.Metodo = 'efectivo'
WHERE C.Identificacion = '101010101'
	AND R.fecha_inicio = '2026-03-10'
	AND P.Monto = 250.00
	AND P.Fecha_Pago = '2026-03-10'
	AND NOT EXISTS (
			SELECT 1
			FROM Pago_Metodo_Pago PMP
			WHERE PMP.ID_Pago = P.ID_Pago
				AND PMP.ID_Metodo_Pago = MP.ID_Metodo_Pago
	);

INSERT INTO Pago_Metodo_Pago (ID_Pago, ID_Metodo_Pago)
SELECT P.ID_Pago, MP.ID_Metodo_Pago
FROM Pago P
JOIN Reservacion R ON R.ID_Reservacion = P.ID_Reservacion
JOIN Cliente C ON C.ID_Cliente = R.ID_Cliente
JOIN Metodo_Pago MP ON MP.Metodo = 'tarjeta'
WHERE C.Identificacion = '101010101'
	AND R.fecha_inicio = '2026-03-10'
	AND P.Monto = 50.00
	AND P.Fecha_Pago = '2026-03-11'
	AND NOT EXISTS (
			SELECT 1
			FROM Pago_Metodo_Pago PMP
			WHERE PMP.ID_Pago = P.ID_Pago
				AND PMP.ID_Metodo_Pago = MP.ID_Metodo_Pago
	);

INSERT INTO Pago_Metodo_Pago (ID_Pago, ID_Metodo_Pago)
SELECT P.ID_Pago, MP.ID_Metodo_Pago
FROM Pago P
JOIN Reservacion R ON R.ID_Reservacion = P.ID_Reservacion
JOIN Cliente C ON C.ID_Cliente = R.ID_Cliente
JOIN Metodo_Pago MP ON MP.Metodo = 'transferencia'
WHERE C.Identificacion = '303030303'
	AND R.fecha_inicio = '2027-01-15'
	AND P.Monto = 500.00
	AND P.Fecha_Pago = '2027-01-15'
	AND NOT EXISTS (
			SELECT 1
			FROM Pago_Metodo_Pago PMP
			WHERE PMP.ID_Pago = P.ID_Pago
				AND PMP.ID_Metodo_Pago = MP.ID_Metodo_Pago
	);

INSERT INTO Pago_Estado (ID_Pago, ID_Estado_Pago)
SELECT P.ID_Pago, EP.ID_Estado_Pago
FROM Pago P
JOIN Reservacion R ON R.ID_Reservacion = P.ID_Reservacion
JOIN Cliente C ON C.ID_Cliente = R.ID_Cliente
JOIN Estado_Pago EP ON EP.Estado_Pago = 'completado'
WHERE C.Identificacion = '101010101'
	AND R.fecha_inicio = '2026-03-10'
	AND P.Monto = 250.00
	AND P.Fecha_Pago = '2026-03-10'
	AND NOT EXISTS (
			SELECT 1
			FROM Pago_Estado PE
			WHERE PE.ID_Pago = P.ID_Pago
				AND PE.ID_Estado_Pago = EP.ID_Estado_Pago
	);

INSERT INTO Pago_Estado (ID_Pago, ID_Estado_Pago)
SELECT P.ID_Pago, EP.ID_Estado_Pago
FROM Pago P
JOIN Reservacion R ON R.ID_Reservacion = P.ID_Reservacion
JOIN Cliente C ON C.ID_Cliente = R.ID_Cliente
JOIN Estado_Pago EP ON EP.Estado_Pago = 'pendiente'
WHERE C.Identificacion = '101010101'
	AND R.fecha_inicio = '2026-03-10'
	AND P.Monto = 50.00
	AND P.Fecha_Pago = '2026-03-11'
	AND NOT EXISTS (
			SELECT 1
			FROM Pago_Estado PE
			WHERE PE.ID_Pago = P.ID_Pago
				AND PE.ID_Estado_Pago = EP.ID_Estado_Pago
	);

INSERT INTO Pago_Estado (ID_Pago, ID_Estado_Pago)
SELECT P.ID_Pago, EP.ID_Estado_Pago
FROM Pago P
JOIN Reservacion R ON R.ID_Reservacion = P.ID_Reservacion
JOIN Cliente C ON C.ID_Cliente = R.ID_Cliente
JOIN Estado_Pago EP ON EP.Estado_Pago = 'confirmada'
WHERE C.Identificacion = '404040404'
	AND R.fecha_inicio = '2027-01-15'
	AND P.Monto = 500.00
	AND P.Fecha_Pago = '2027-01-15'
	AND NOT EXISTS (
			SELECT 1
			FROM Pago_Estado PE
			WHERE PE.ID_Pago = P.ID_Pago
				AND PE.ID_Estado_Pago = EP.ID_Estado_Pago
	);

/* =========================
	 INCIDENTE (VALOR NULO)
	 ========================= */

INSERT INTO Incidente (ID_Reservacion, Descripcion, Nombre_responsable, numero_consecutivo, monto_penalizacion, fecha_incidente)
SELECT R.ID_Reservacion,
			 'Ruido reportado por otro huesped',
			 'Recepcion',
			 1,
			 NULL,
			 '2026-08-21'
FROM Reservacion R
JOIN Cliente C ON C.ID_Cliente = R.ID_Cliente
WHERE C.Identificacion = '202020202'
	AND R.fecha_inicio = '2026-08-20'
	AND NOT EXISTS (
			SELECT 1
			FROM Incidente I
			WHERE I.ID_Reservacion = R.ID_Reservacion
				AND I.numero_consecutivo = 1
	);


