/**
Quiz 2 - Base de Datos Hoteleria
Authors: Deislher Sánchez y Roymar Castillo
Fecha: 2026-04-18
**/

CREATE DATABASE Hoteleria;

USE Hoteleria;

CREATE TABLE Tipo_Habitacion (
    ID_Tipo_Habitacion INT IDENTITY(1,1) PRIMARY KEY,
    Tipo VARCHAR(50) NOT NULL,
    CONSTRAINT UQ_Tipo_Habitacion_Nombre UNIQUE(Tipo)
);

CREATE TABLE Estado_Habitacion (
    ID_Estado_Habitacion INT IDENTITY(1,1) PRIMARY KEY,
    Estado VARCHAR(20) NOT NULL,
    CONSTRAINT UQ_Estado_Habitacion_Nombre UNIQUE(Estado)
);

CREATE TABLE Habitacion (
    ID_habitacion INT IDENTITY(1,1) PRIMARY KEY,
    ID_Tipo_Habitacion INT NOT NULL,
    ID_Estado_Habitacion INT NOT NULL,
    cantidad_de_personas INT NOT NULL,
    precio_por_noche DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_Habitacion_Tipo FOREIGN KEY (ID_Tipo_Habitacion) REFERENCES Tipo_Habitacion(ID_Tipo_Habitacion),
    CONSTRAINT FK_Habitacion_Estado FOREIGN KEY (ID_Estado_Habitacion) REFERENCES Estado_Habitacion(ID_Estado_Habitacion)
);

CREATE TABLE Cliente (
    ID_Cliente INT IDENTITY(1,1) PRIMARY KEY,
    Identificacion VARCHAR(20) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    primer_apellido VARCHAR(50) NOT NULL,
    segundo_apellido VARCHAR(50),
    Correo_Electronico VARCHAR(254) NOT NULL,
    CONSTRAINT UQ_Cliente_Identificacion UNIQUE(Identificacion),
    CONSTRAINT CHK_Cliente_Correo_Valido CHECK (Correo_Electronico LIKE '_%@_%.%')
);

CREATE TABLE Nacionalidad (
    ID_Nacionalidad INT IDENTITY(1,1) PRIMARY KEY,
    Nacionalidad VARCHAR(50) NOT NULL,
    CONSTRAINT UQ_Nacionalidad_Nombre UNIQUE(Nacionalidad)
);

CREATE TABLE Estado_Reserva (
    ID_Estado_Reserva INT IDENTITY(1,1) PRIMARY KEY,
    Estado_Reserva VARCHAR(20) NOT NULL,
    CONSTRAINT UQ_Estado_Reserva_Nombre UNIQUE(Estado_Reserva)
);

CREATE TABLE Estado_Pago (
    ID_Estado_Pago INT IDENTITY(1,1) PRIMARY KEY,
    Estado_Pago VARCHAR(20) NOT NULL,
    CONSTRAINT UQ_Estado_Pago_Nombre UNIQUE(Estado_Pago)
);

CREATE TABLE Metodo_Pago (
    ID_Metodo_Pago INT IDENTITY(1,1) PRIMARY KEY,
    Metodo VARCHAR(30) NOT NULL,
    CONSTRAINT UQ_Metodo_Pago_Nombre UNIQUE(Metodo)
);

CREATE TABLE Servicio (
    ID_Servicio INT IDENTITY(1,1) PRIMARY KEY,
    Nombre_Servicio VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(255),
    Tarifa DECIMAL(10, 2) NOT NULL,
    CONSTRAINT UQ_Servicio_Nombre UNIQUE(Nombre_Servicio)
);

CREATE TABLE Reservacion (
    ID_Reservacion INT IDENTITY(1,1) PRIMARY KEY,
    ID_Cliente INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    check_in DATETIME NOT NULL,
    check_out DATETIME NOT NULL,
    CONSTRAINT CHK_Fechas_Validas CHECK (fecha_fin >= fecha_inicio),
    CONSTRAINT CHK_Horario_Valido CHECK (check_out >= check_in),
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente)
);

CREATE TABLE Pago (
    ID_Pago INT IDENTITY(1,1) PRIMARY KEY,
    ID_Reservacion INT NOT NULL,
    Monto DECIMAL(10, 2) NOT NULL,
    Fecha_Pago DATE NOT NULL,
    FOREIGN KEY (ID_Reservacion) REFERENCES Reservacion(ID_Reservacion)
);

CREATE TABLE Incidente (
    ID_Incidente INT IDENTITY(1,1) PRIMARY KEY,
    ID_Reservacion INT NOT NULL,
    Descripcion VARCHAR(255) NOT NULL,
    Nombre_responsable VARCHAR(100) NOT NULL,
    numero_consecutivo INT NOT NULL,
    monto_penalizacion DECIMAL(10, 2),
    fecha_incidente DATE NOT NULL,
    FOREIGN KEY (ID_Reservacion) REFERENCES Reservacion(ID_Reservacion)

);

CREATE TABLE Cliente_Nacionalidad (
    ID_Cliente INT NOT NULL,
    ID_Nacionalidad INT NOT NULL,
    CONSTRAINT PK_Cliente_Nacionalidad PRIMARY KEY(ID_Cliente, ID_Nacionalidad),
    CONSTRAINT FK_CN_Cliente FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente),
    CONSTRAINT FK_CN_Nacionalidad FOREIGN KEY (ID_Nacionalidad) REFERENCES Nacionalidad(ID_Nacionalidad)
);

CREATE TABLE Telefono (
    ID_Telefono INT IDENTITY(1,1) PRIMARY KEY,
    ID_Cliente INT NOT NULL,
    Telefono VARCHAR(20) NOT NULL,
    CONSTRAINT FK_Telefono_Cliente FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente)
);


CREATE TABLE Habitacion_Reservaciones (
    ID_habitacion INT NOT NULL,
    ID_reservacion INT NOT NULL,
    CONSTRAINT PK_Habitacion_Reservaciones PRIMARY KEY(ID_habitacion, ID_reservacion),
    CONSTRAINT FK_HR_Habitacion FOREIGN KEY (ID_habitacion) REFERENCES Habitacion(ID_habitacion),
    CONSTRAINT FK_HR_Reservacion FOREIGN KEY (ID_reservacion) REFERENCES Reservacion(ID_Reservacion)
);

CREATE TABLE Servicio_Reservacion (
    ID_Servicio INT NOT NULL,
    ID_Reservacion INT NOT NULL,
    CONSTRAINT PK_Servicio_Reservacion PRIMARY KEY(ID_Servicio, ID_Reservacion),
    CONSTRAINT FK_SR_Servicio FOREIGN KEY (ID_Servicio) REFERENCES Servicio(ID_Servicio),
    CONSTRAINT FK_SR_Reservacion FOREIGN KEY (ID_Reservacion) REFERENCES Reservacion(ID_Reservacion)
);

CREATE TABLE Pago_Metodo_Pago (
    ID_Pago INT NOT NULL,
    ID_Metodo_Pago INT NOT NULL,
    CONSTRAINT PK_Pago_Metodo_Pago PRIMARY KEY(ID_Pago, ID_Metodo_Pago),
    CONSTRAINT FK_PMP_Pago FOREIGN KEY (ID_Pago) REFERENCES Pago(ID_Pago),
    CONSTRAINT FK_PMP_Metodo FOREIGN KEY (ID_Metodo_Pago) REFERENCES Metodo_Pago(ID_Metodo_Pago)
);

CREATE TABLE Pago_Estado (
    ID_Pago INT NOT NULL,
    ID_Estado_Pago INT NOT NULL,
    CONSTRAINT PK_Pago_Estado PRIMARY KEY(ID_Pago, ID_Estado_Pago),
    CONSTRAINT FK_PEP_Pago FOREIGN KEY (ID_Pago) REFERENCES Pago(ID_Pago),
    CONSTRAINT FK_PEP_Estado FOREIGN KEY (ID_Estado_Pago) REFERENCES Estado_Pago(ID_Estado_Pago)
);

CREATE TABLE Estado_Reserva_IT (
    ID_Reservacion INT NOT NULL,
    ID_Estado_Reserva INT NOT NULL,
    CONSTRAINT PK_Estado_Reserva_IT PRIMARY KEY(ID_Reservacion, ID_Estado_Reserva),
    CONSTRAINT FK_ERI_Reservacion FOREIGN KEY (ID_Reservacion) REFERENCES Reservacion(ID_Reservacion),
    CONSTRAINT FK_ERI_Estado FOREIGN KEY (ID_Estado_Reserva) REFERENCES Estado_Reserva(ID_Estado_Reserva)
);


/**
Determinar el precio por noche de las habitaciones de tipo suite.
**/
SELECT h.ID_Habitacion, h.precio_por_noche
FROM Habitacion h
JOIN Tipo_Habitacion t ON h.ID_Tipo_Habitacion = t.ID_Tipo_Habitacion
WHERE t.Tipo = 'suite';

/**
Determinar el nombre y nacionalidad de los clientes que tienen correo en el dominio en yahoo.com
**/
SELECT c.nombre, n.Nacionalidad
FROM Cliente c
JOIN Cliente_Nacionalidad cn ON c.ID_Cliente = cn.ID_Cliente
JOIN Nacionalidad n ON cn.ID_Nacionalidad = n.ID_Nacionalidad
WHERE c.correo_electronico LIKE '%@yahoo.com';


/**
Conocer el listado de reservaciones con estado confirmado para el 15-01-2027.
**/
SELECT r.ID_Reservacion, r.ID_Cliente, r.fecha_inicio, r.fecha_fin, r.check_in, r.check_out, er.Estado_Reserva
FROM Reservacion r
JOIN Estado_Reserva_IT eri ON r.ID_Reservacion = eri.ID_Reservacion
JOIN Estado_Reserva er ON eri.ID_Estado_Reserva = er.ID_Estado_Reserva
WHERE er.Estado_Reserva = 'confirmada' AND r.fecha_inicio = '2027-01-15';

/**
Pendiente
Conocer el listado de reservas con valor NULO durante el año 2026.
**/


/**
Conocer el listado de los pagos pagados en efectivo y estado completado.
**/
SELECT p.ID_Pago, ep.Estado_Pago, m.Metodo
FROM Pago p
JOIN Pago_Estado pe ON p.ID_Pago = pe.ID_Pago
JOIN Estado_Pago ep ON pe.ID_Estado_Pago = ep.ID_Estado_Pago
JOIN Pago_Metodo_Pago pmp ON p.ID_Pago = pmp.ID_Pago
JOIN Metodo_Pago m ON pmp.ID_Metodo_Pago  = m.ID_Metodo_Pago
WHERE ep.Estado_Pago = 'completado' AND m.Metodo = 'efectivo';