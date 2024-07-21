CREATE SCHEMA SEGURO_G28126743; 
SET schema 'SEGURO_G28126743';

-- Crear tabla PAIS
DROP TABLE IF EXISTS SEGURO_G28126743.PAIS;
CREATE TABLE SEGURO_G28126743.PAIS (
    cod_pais SERIAL PRIMARY KEY,
    nb_pais VARCHAR(100) NOT NULL
);

-- Crear tabla CIUDAD
DROP TABLE IF EXISTS SEGURO_G28126743.CIUDAD;
CREATE TABLE SEGURO_G28126743.CIUDAD (
    cod_ciudad SERIAL PRIMARY KEY,
    nb_ciudad VARCHAR(100) NOT NULL,
    cod_pais INT NOT NULL,
    FOREIGN KEY (cod_pais) REFERENCES SEGURO_G28126743.PAIS (cod_pais)
);

-- Crear tabla SUCURSAL
DROP TABLE IF EXISTS SEGURO_G28126743.SUCURSAL;
CREATE TABLE SEGURO_G28126743.SUCURSAL (
    cod_sucursal SERIAL PRIMARY KEY,
    nb_sucursal VARCHAR(100) NOT NULL,
    cod_ciudad INT NOT NULL,
    FOREIGN KEY (cod_ciudad) REFERENCES SEGURO_G28126743.CIUDAD (cod_ciudad)
);

DROP TABLE IF EXISTS SEGURO_G28126743.TIPO_PRODUCTO;
CREATE TABLE SEGURO_G28126743.TIPO_PRODUCTO (
    cod_tipo_producto SERIAL PRIMARY KEY,
    nb_tipo_producto VARCHAR(100) NOT NULL,
    CHECK (nb_tipo_producto IN ('Prestación de Servicios', 'Personales', 'Daños', 'Patrimoniales'))
);

-- Crear tabla PRODUCTO
DROP TABLE IF EXISTS SEGURO_G28126743.PRODUCTO;
CREATE TABLE SEGURO_G28126743.PRODUCTO (
    cod_producto SERIAL PRIMARY KEY,
    nb_producto VARCHAR(100) NOT NULL,
    descripcion TEXT,
    cod_tipo_producto INT NOT NULL,
    calificacion INT CHECK (calificacion BETWEEN 1 AND 5),
    FOREIGN KEY (cod_tipo_producto) REFERENCES SEGURO_G28126743.TIPO_PRODUCTO (cod_tipo_producto)
);

-- Crear tabla CLIENTE
DROP TABLE IF EXISTS SEGURO_G28126743.CLIENTE;
CREATE TABLE SEGURO_G28126743.CLIENTE (
    cod_cliente SERIAL PRIMARY KEY,
    nb_cliente VARCHAR(100) NOT NULL,
    ci_rif VARCHAR(50) NOT NULL,
    telefono VARCHAR(20),
    direccion TEXT,
    sexo CHAR(1) CHECK (sexo IN ('M', 'F')),
    email VARCHAR(100),
    cod_sucursal INT NOT NULL,
    FOREIGN KEY (cod_sucursal) REFERENCES SEGURO_G28126743.SUCURSAL (cod_sucursal)
);

-- Crear tabla EVALUACION_SERVICIO
DROP TABLE IF EXISTS SEGURO_G28126743.EVALUACION_SERVICIO;
CREATE TABLE SEGURO_G28126743.EVALUACION_SERVICIO (
    cod_evaluacion_servicio SERIAL PRIMARY KEY,
    nb_descripcion VARCHAR(100) NOT NULL,
	valoracion INT CHECK (valoracion BETWEEN 1 AND 5)
);

-- Crear tabla RECOMIENDA
DROP TABLE IF EXISTS SEGURO_G28126743.RECOMIENDA;
CREATE TABLE SEGURO_G28126743.RECOMIENDA (
    cod_cliente INT NOT NULL,
    cod_evaluacion_servicio INT NOT NULL,
    cod_producto INT NOT NULL,
    recomienda_amigo BOOLEAN,
    fecha_recomendacion DATE,
    PRIMARY KEY (cod_cliente, cod_evaluacion_servicio, cod_producto),
    FOREIGN KEY (cod_cliente) REFERENCES SEGURO_G28126743.CLIENTE (cod_cliente),
    FOREIGN KEY (cod_evaluacion_servicio) REFERENCES SEGURO_G28126743.EVALUACION_SERVICIO (cod_evaluacion_servicio),
    FOREIGN KEY (cod_producto) REFERENCES SEGURO_G28126743.PRODUCTO (cod_producto)
);

-- Crear tabla CONTRATO
DROP TABLE IF EXISTS SEGURO_G28126743.CONTRATO;
CREATE TABLE SEGURO_G28126743.CONTRATO (
    nro_contrato SERIAL PRIMARY KEY,
    descrip_contrato TEXT
);

-- Crear tabla ESTADO_CONTRATO
DROP TABLE IF EXISTS SEGURO_G28126743.ESTADO_CONTRATO; 
CREATE TABLE IF NOT EXISTS SEGURO_G28126743.ESTADO_CONTRATO
(
    cod_estado integer NOT NULL,
    descrip_estado character varying NOT NULL,
    CONSTRAINT estado_contrato_pkey PRIMARY KEY (cod_estado)
);

-- Crear tabla REGISTRO_CONTRATO
DROP TABLE IF EXISTS SEGURO_G28126743.REGISTRO_CONTRATO;
CREATE TABLE SEGURO_G28126743.REGISTRO_CONTRATO (
    nro_contrato INT NOT NULL,
    cod_producto INT NOT NULL,
    cod_cliente INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    monto DECIMAL(10, 2) NOT NULL CHECK (monto >= 0),
    cod_estado INT NOT NULL, 
    PRIMARY KEY (nro_contrato, cod_producto, cod_cliente),
    FOREIGN KEY (nro_contrato) REFERENCES SEGURO_G28126743.CONTRATO (nro_contrato),
    FOREIGN KEY (cod_producto) REFERENCES SEGURO_G28126743.PRODUCTO (cod_producto),
    FOREIGN KEY (cod_cliente) REFERENCES SEGURO_G28126743.CLIENTE (cod_cliente), 
    FOREIGN KEY (cod_estado) REFERENCES SEGURO_G28126743.ESTADO_CONTRATO (cod_estado)
);

-- Crear tabla SINIESTRO
DROP TABLE IF EXISTS SEGURO_G28126743.SINIESTRO;
CREATE TABLE SEGURO_G28126743.SINIESTRO (
    nro_siniestro SERIAL PRIMARY KEY,
    descripcion_siniestro TEXT
);

-- Crear tabla REGISTRO_SINIESTRO
DROP TABLE IF EXISTS SEGURO_G28126743.REGISTRO_SINIESTRO;
CREATE TABLE SEGURO_G28126743.REGISTRO_SINIESTRO (
    nro_siniestro INT NOT NULL,
    nro_contrato INT NOT NULL,
    cod_cliente INT NOT NULL,
    fecha_siniestro DATE NOT NULL,
    fecha_respuesta DATE NOT NULL,
    id_rechazo BOOLEAN,
    cod_producto INT NOT NULL,
    monto_reconocido DECIMAL(10, 2) CHECK (monto_reconocido >= 0),
    monto_solicitado DECIMAL(10, 2) CHECK (monto_solicitado >= 0),
    PRIMARY KEY (nro_siniestro, nro_contrato, fecha_siniestro),
    FOREIGN KEY (nro_siniestro) REFERENCES SEGURO_G28126743.SINIESTRO (nro_siniestro),
    FOREIGN KEY (nro_contrato) REFERENCES SEGURO_G28126743.CONTRATO (nro_contrato),
    FOREIGN KEY (cod_cliente) REFERENCES SEGURO_G28126743.CLIENTE (cod_cliente),
    FOREIGN KEY (cod_producto) REFERENCES SEGURO_G28126743.PRODUCTO (cod_producto), 
    CHECK (fecha_respuesta >= fecha_siniestro)
);