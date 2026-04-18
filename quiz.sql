CREATE DATABASE Hoteleria;

USE Hoteleria;

CREATE TABLE Habitacion (
    ID_habitacion INT PRIMARY KEY AUTO_INCREMENT,
    estado VARCHAR(20) NOT NULL,
    cantidad_de_personas INT NOT NULL,
    precio_por_noche DECIMAL(10, 2) NOT NULL,
);


CREATE TABLE Reservacion (
    ID_Reservacion INT PRIMARY KEY AUTO_INCREMENT,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    check_in TIME NOT NULL,
    check_out TIME NOT NULL,
    
);


CREATE TABLE Habitacion_Reservaciones (
    ID_habitacion INT NOT NULL,
    ID_reservacion INT NOT NULL,
    FOREIGN KEY (ID_habitacion) REFERENCES Habitacion(ID_habitacion),
);






CREATE TABLE Cliente (
    ID_cliente VARCHAR(9) NOT NULL,
    nombre VARCHAR(30) NOT NULL,
    primer_apellido VARCHAR(30) NOT NULL,
    segundo_apellido VARCHAR(30) NOT NULL,
    correo_electronico VARCHAR(30) NOT NULL,
    CONSTRAINT id_UNIQUE UNIQUE(ID_cliente),
    CONSTRAINT cliente_correo_valido CHECK (correo_electronico LIKE '') 
    
    
    
);