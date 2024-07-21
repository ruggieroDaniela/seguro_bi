WITH RECURSIVE date_series AS (
    SELECT '2024-01-01'::date AS fecha
    UNION ALL
    SELECT (fecha + INTERVAL '1 day')::date
    FROM date_series
    WHERE fecha + INTERVAL '1 day' <= '2024-12-31'::date
)
INSERT INTO SEGURO_DW_G28126743.dim_tiempo (
    sk_dim_tiempo, 
    cod_annio, 
    cod_mes, 
    cod_dia_annio, 
    cod_dia_mes, 
    cod_dia_semana, 
    cod_semana, 
    desc_dia_semana, 
    desc_dia_semana_corta, 
    desc_mes, 
    desc_mes_corta, 
    desc_trimestre, 
    desc_semestre, 
    fecha_completa
)
SELECT
    EXTRACT(epoch FROM fecha)::int AS sk_dim_tiempo,
    EXTRACT(year FROM fecha) AS cod_annio,
    EXTRACT(month FROM fecha) AS cod_mes,
    EXTRACT(doy FROM fecha) AS cod_dia_annio,
    EXTRACT(day FROM fecha) AS cod_dia_mes,
    EXTRACT(dow FROM fecha) AS cod_dia_semana,
    EXTRACT(week FROM fecha) AS cod_semana,
    TO_CHAR(fecha, 'Day') AS desc_dia_semana,
    TO_CHAR(fecha, 'Dy') AS desc_dia_semana_corta,
    TO_CHAR(fecha, 'Month') AS desc_mes,
    TO_CHAR(fecha, 'Mon') AS desc_mes_corta,
    CASE 
        WHEN EXTRACT(month FROM fecha) IN (1, 2, 3) THEN 1
        WHEN EXTRACT(month FROM fecha) IN (4, 5, 6) THEN 2
        WHEN EXTRACT(month FROM fecha) IN (7, 8, 9) THEN 3
        WHEN EXTRACT(month FROM fecha) IN (10, 11, 12) THEN 4
    END AS desc_trimestre,
    CASE 
        WHEN EXTRACT(month FROM fecha) IN (1, 2, 3, 4, 5, 6) THEN 1
        WHEN EXTRACT(month FROM fecha) IN (7, 8, 9, 10, 11, 12) THEN 2
    END AS desc_semestre,
    fecha AS fecha_completa
FROM date_series;

-- Insertar datos en la tabla PAIS
INSERT INTO SEGURO_G28126743.PAIS (nb_pais) VALUES 
('Venezuela'), 
('Colombia'), 
('Argentina'), 
('Chile'), 
('Brasil');

-- Insertar datos en la tabla CIUDAD
INSERT INTO SEGURO_G28126743.CIUDAD (nb_ciudad, cod_pais) VALUES 
('Caracas', 1), 
('Bogotá', 2), 
('Buenos Aires', 3), 
('Santiago', 4), 
('Sao Paulo', 5);

-- Insertar datos en la tabla SUCURSAL
INSERT INTO SEGURO_G28126743.SUCURSAL (nb_sucursal, cod_ciudad) VALUES 
('Sucursal Caracas', 1), 
('Sucursal Bogotá', 2), 
('Sucursal Buenos Aires', 3), 
('Sucursal Santiago', 4), 
('Sucursal Sao Paulo', 5);

-- Insertar datos en la tabla TIPO_PRODUCTO
INSERT INTO SEGURO_G28126743.TIPO_PRODUCTO (nb_tipo_producto) VALUES 
('Prestación de Servicios'), 
('Personales'), 
('Daños'), 
('Patrimoniales');

-- Insertar datos en la tabla PRODUCTO
INSERT INTO SEGURO_G28126743.PRODUCTO (nb_producto, descripcion, cod_tipo_producto, calificacion) VALUES 
('Producto 1', 'Descripción del producto 1', 1, 5), 
('Producto 2', 'Descripción del producto 2', 2, 4), 
('Producto 3', 'Descripción del producto 3', 3, 3), 
('Producto 4', 'Descripción del producto 4', 4, 2), 
('Producto 5', 'Descripción del producto 5', 1, 1);

-- Insertar datos en la tabla CLIENTE
INSERT INTO SEGURO_G28126743.CLIENTE (nb_cliente, ci_rif, telefono, direccion, sexo, email, cod_sucursal) VALUES 
('Cliente 1', 'CIRIF1', '04141111111', 'Dirección 1', 'M', 'cliente1@example.com', 1), 
('Cliente 2', 'CIRIF2', '04142222222', 'Dirección 2', 'F', 'cliente2@example.com', 2), 
('Cliente 3', 'CIRIF3', '04143333333', 'Dirección 3', 'M', 'cliente3@example.com', 3), 
('Cliente 4', 'CIRIF4', '04144444444', 'Dirección 4', 'F', 'cliente4@example.com', 4), 
('Cliente 5', 'CIRIF5', '04145555555', 'Dirección 5', 'M', 'cliente5@example.com', 5);

-- Insertar datos en la tabla EVALUACION_SERVICIO
INSERT INTO SEGURO_G28126743.EVALUACION_SERVICIO (nb_descripcion, valoracion) VALUES 
('Evaluación 1', 5), 
('Evaluación 2', 4), 
('Evaluación 3', 3), 
('Evaluación 4', 2), 
('Evaluación 5', 1);

-- Insertar datos en la tabla RECOMIENDA
INSERT INTO SEGURO_G28126743.RECOMIENDA (cod_cliente, cod_evaluacion_servicio, cod_producto, recomienda_amigo, fecha_recomendacion) VALUES 
(1, 1, 1, TRUE, '2024-01-10'), 
(2, 2, 2, FALSE, '2024-02-15'), 
(3, 3, 3, TRUE, '2024-03-20'), 
(4, 4, 4, FALSE, '2024-04-25'), 
(5, 5, 5, TRUE, '2024-05-30');

-- Insertar datos en la tabla CONTRATO
INSERT INTO SEGURO_G28126743.CONTRATO (descrip_contrato) VALUES 
('Contrato 1'), 
('Contrato 2'), 
('Contrato 3'), 
('Contrato 4'), 
('Contrato 5');

-- Insertar datos en la tabla ESTADO_CONTRATO
INSERT INTO SEGURO_G28126743.ESTADO_CONTRATO (cod_estado, descrip_estado) VALUES
(1, 'activo'), 
(2, 'vencido'), 
(3, 'suspendido');

-- Insertar datos en la tabla REGISTRO_CONTRATO
INSERT INTO SEGURO_G28126743.REGISTRO_CONTRATO (nro_contrato, cod_producto, cod_cliente, fecha_inicio, fecha_fin, monto, cod_estado) VALUES 
(1, 1, 1, '2024-01-01', '2024-12-31', 1000.00, 1), 
(2, 2, 2, '2024-02-01', '2024-11-30', 2000.00, 2), 
(3, 3, 3, '2024-03-01', '2024-10-31', 3000.00, 3), 
(4, 4, 4, '2024-04-01', '2024-09-30', 4000.00, 1), 
(5, 5, 5, '2024-05-01', '2024-08-31', 5000.00, 2);

-- Insertar datos en la tabla SINIESTRO
INSERT INTO SEGURO_G28126743.SINIESTRO (descripcion_siniestro) VALUES 
('Siniestro 1'), 
('Siniestro 2'), 
('Siniestro 3'), 
('Siniestro 4'), 
('Siniestro 5');


-- Insertar datos en la tabla REGISTRO_SINIESTRO
INSERT INTO SEGURO_G28126743.REGISTRO_SINIESTRO (nro_siniestro, nro_contrato, cod_cliente, fecha_siniestro, fecha_respuesta, id_rechazo, cod_producto, monto_reconocido, monto_solicitado) VALUES 
(1, 1, 1, '2024-06-01', '2024-06-10', FALSE, 1, 1000.00, 1500.00), 
(2, 2, 2, '2024-07-01', '2024-07-10', TRUE, 2, 2000.00, 2500.00), 
(3, 3, 3, '2024-08-01', '2024-08-10', FALSE, 3, 3000.00, 3500.00), 
(4, 4, 4, '2024-09-01', '2024-09-10', TRUE, 4, 4000.00, 4500.00), 
(5, 5, 5, '2024-10-01', '2024-10-10', FALSE, 5, 5000.00, 5500.00);

