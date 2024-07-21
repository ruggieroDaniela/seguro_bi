CREATE SCHEMA SEGURO_DW_G28126743; 
SET schema 'SEGURO_DW_G28126743';

-- Table: SEGURO_DW_G28126743.dim_cliente
DROP TABLE IF EXISTS SEGURO_DW_G28126743.dim_cliente;
CREATE TABLE IF NOT EXISTS SEGURO_DW_G28126743.dim_cliente
(
    sk_dim_cliente integer NOT NULL,
    cod_cliente integer NOT NULL,
    nb_cliente character varying(25),
    ci_rif character varying(45),
    telefono character varying(45),
    direccion character varying(45),
    sexo character varying(45),
    email character varying(45),
    CONSTRAINT sk_dim_cliente PRIMARY KEY (sk_dim_cliente)
); 

-- Table: SEGURO_DW_G28126743.dim_contrato
DROP TABLE IF EXISTS SEGURO_DW_G28126743.dim_contrato;
CREATE TABLE IF NOT EXISTS SEGURO_DW_G28126743.dim_contrato
(
    sk_dim_contrato integer NOT NULL,
    nro_contrato integer,
    descrip_contrato character varying(100),
    CONSTRAINT sk_dim_contrato PRIMARY KEY (sk_dim_contrato)
); 

-- Table: SEGURO_DW_G28126743.dim_estado_contrato
DROP TABLE IF EXISTS SEGURO_DW_G28126743.dim_estado_contrato;
CREATE TABLE IF NOT EXISTS SEGURO_DW_G28126743.dim_estado_contrato
(
    sk_dim_estado_contrato integer NOT NULL,
    cod_estado integer,
    descript_estado character varying(100),
    CONSTRAINT sk_dim_estado_contrato PRIMARY KEY (sk_dim_estado_contrato)
); 

-- Table: SEGURO_DW_G28126743.dim_evaluacion_servicio
DROP TABLE IF EXISTS SEGURO_DW_G28126743.dim_evaluacion_servicio;
CREATE TABLE IF NOT EXISTS SEGURO_DW_G28126743.dim_evaluacion_servicio
(
    sk_dim_evaluacion integer NOT NULL,
    cod_evaluacion_servicio integer,
    nb_descrip character varying(100),
    CONSTRAINT sk_dim_evaluacion_servicio PRIMARY KEY (sk_dim_evaluacion)
); 

-- Table: SEGURO_DW_G28126743.dim_producto
DROP TABLE IF EXISTS SEGURO_DW_G28126743.dim_producto;
CREATE TABLE IF NOT EXISTS SEGURO_DW_G28126743.dim_producto
(
    sk_dim_producto integer NOT NULL,
    cod_producto integer,
    nb_producto character varying(100),
    descrip_producto character varying(100),
    cod_tipo_producto character varying(100),
    nb_tipo_producto character varying(100),
    calificacion numeric,
    CONSTRAINT sk_dim_producto PRIMARY KEY (sk_dim_producto)
);

-- Table: SEGURO_DW_G28126743.dim_siniestro
DROP TABLE IF EXISTS SEGURO_DW_G28126743.dim_siniestro;
CREATE TABLE IF NOT EXISTS SEGURO_DW_G28126743.dim_siniestro
(
    sk_dim_siniestro integer NOT NULL,
    nro_siniestro integer,
    descrip_siniestro character varying(100),
    CONSTRAINT sk_dim_siniestro PRIMARY KEY (sk_dim_siniestro)
); 


-- Table: SEGURO_DW_G28126743.dim_sucursal
DROP TABLE IF EXISTS SEGURO_DW_G28126743.dim_sucursal;
CREATE TABLE IF NOT EXISTS SEGURO_DW_G28126743.dim_sucursal
(
    sk_dim_sucursal integer NOT NULL,
    cod_sucursal integer,
    nb_sucursal character varying(100),
    cod_ciudad character varying(100),
    nb_ciudad character varying(100),
    cod_pais character varying(100),
    nb_pais character varying(100),
    CONSTRAINT sk_dim_sucursal PRIMARY KEY (sk_dim_sucursal)
); 

-- Table: SEGURO_DW_G28126743.dim_tiempo
DROP TABLE IF EXISTS SEGURO_DW_G28126743.dim_tiempo;
CREATE TABLE IF NOT EXISTS SEGURO_DW_G28126743.dim_tiempo
(
    sk_dim_tiempo integer NOT NULL,
    cod_annio integer,
    cod_mes integer,
    cod_dia_annio integer,
    cod_dia_mes integer,
    cod_dia_semana integer,
    cod_semana integer,
    desc_dia_semana character varying(10),
    desc_dia_semana_corta character varying(5),
    desc_mes character varying(20),
    desc_mes_corta character varying(3),
    desc_trimestre integer,
    desc_semestre integer,
    fecha_completa date NOT NULL,
    CONSTRAINT sk_dim_tiempo PRIMARY KEY (sk_dim_tiempo)
); 

-- Table: SEGURO_DW_G28126743.fact_evaluacion_servicio
DROP TABLE IF EXISTS SEGURO_DW_G28126743.fact_evaluacion_servicio;
CREATE TABLE IF NOT EXISTS SEGURO_DW_G28126743.fact_evaluacion_servicio
(
    sk_dim_fecha_recomendacion integer NOT NULL,
    sk_dim_cliente integer NOT NULL,
    sk_dim_producto integer NOT NULL,
    sk_dim_evaluacion_servicio integer NOT NULL,
    cantidad integer,
    recomienda_amigo boolean,
    CONSTRAINT fact_evaluacion_servicio_pk PRIMARY KEY (sk_dim_fecha_recomendacion, sk_dim_cliente, sk_dim_producto, sk_dim_evaluacion_servicio),
    CONSTRAINT sk_dim_cliente_fk FOREIGN KEY (sk_dim_cliente)
        REFERENCES SEGURO_DW_G28126743.dim_cliente (sk_dim_cliente) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT sk_dim_evaluacion_servicio_fk FOREIGN KEY (sk_dim_evaluacion_servicio)
        REFERENCES SEGURO_DW_G28126743.dim_evaluacion_servicio (sk_dim_evaluacion) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT sk_dim_fecha_recomendacion_fk FOREIGN KEY (sk_dim_fecha_recomendacion)
        REFERENCES SEGURO_DW_G28126743.dim_tiempo (sk_dim_tiempo) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT sk_dim_producto_fk FOREIGN KEY (sk_dim_producto)
        REFERENCES SEGURO_DW_G28126743.dim_producto (sk_dim_producto) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
); 

-- Table: SEGURO_DW_G28126743.fact_metas
DROP TABLE IF EXISTS SEGURO_DW_G28126743.fact_metas;
CREATE TABLE IF NOT EXISTS SEGURO_DW_G28126743.fact_metas
(
    sk_dim_fecha_inicio_meta integer NOT NULL,
    sk_dim_producto integer NOT NULL,
    sk_dim_fecha_fin_meta integer NOT NULL,
    monto_meta_venta numeric,
    meta_renovacion integer,
    meta_asegurados integer,
    CONSTRAINT fact_metas_pk PRIMARY KEY (sk_dim_fecha_inicio_meta, sk_dim_producto, sk_dim_fecha_fin_meta),
    CONSTRAINT sk_dim_fecha_fin_meta_fk FOREIGN KEY (sk_dim_fecha_fin_meta)
        REFERENCES SEGURO_DW_G28126743.dim_tiempo (sk_dim_tiempo) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT sk_dim_fecha_inicio_meta_fk FOREIGN KEY (sk_dim_fecha_inicio_meta)
        REFERENCES SEGURO_DW_G28126743.dim_tiempo (sk_dim_tiempo) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT sk_dim_producto_fk FOREIGN KEY (sk_dim_producto)
        REFERENCES SEGURO_DW_G28126743.dim_producto (sk_dim_producto) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

-- Table: SEGURO_DW_G28126743.fact_registro_contrato
DROP TABLE IF EXISTS SEGURO_DW_G28126743.fact_registro_contrato;
CREATE TABLE IF NOT EXISTS SEGURO_DW_G28126743.fact_registro_contrato
(
    sk_dim_tiempo_fecha_inicio integer NOT NULL,
    sk_dim_tiempo_fecha_fin integer NOT NULL,
    sk_dim_cliente integer NOT NULL,
    sk_dim_contrato integer NOT NULL,
    sk_dim_producto integer NOT NULL,
    sk_dim_estado_contrato integer NOT NULL,
    monto numeric,
    cantidad integer,
    cantidad_cliente integer,
    cantidad_producto integer,
    cantidad_contrato integer,
    CONSTRAINT fact_registro_contrato_pk PRIMARY KEY (sk_dim_tiempo_fecha_inicio, sk_dim_tiempo_fecha_fin, sk_dim_cliente, sk_dim_contrato, sk_dim_producto, sk_dim_estado_contrato),
    CONSTRAINT sk_dim_cliente_fk FOREIGN KEY (sk_dim_cliente)
        REFERENCES SEGURO_DW_G28126743.dim_cliente (sk_dim_cliente) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT sk_dim_contrato_fk FOREIGN KEY (sk_dim_contrato)
        REFERENCES SEGURO_DW_G28126743.dim_contrato (sk_dim_contrato) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT sk_dim_estado_contrato_fk FOREIGN KEY (sk_dim_estado_contrato)
        REFERENCES SEGURO_DW_G28126743.dim_estado_contrato (sk_dim_estado_contrato) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT sk_dim_producto_fk FOREIGN KEY (sk_dim_producto)
        REFERENCES SEGURO_DW_G28126743.dim_producto (sk_dim_producto) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT sk_dim_tiempo_fecha_fin_fk FOREIGN KEY (sk_dim_tiempo_fecha_fin)
        REFERENCES SEGURO_DW_G28126743.dim_tiempo (sk_dim_tiempo) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT sk_dim_tiempo_fecha_inicio_fk FOREIGN KEY (sk_dim_tiempo_fecha_inicio)
        REFERENCES SEGURO_DW_G28126743.dim_tiempo (sk_dim_tiempo) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
); 

-- Table: SEGURO_DW_G28126743.fact_registro_siniestro
DROP TABLE IF EXISTS SEGURO_DW_G28126743.fact_registro_siniestro;
CREATE TABLE IF NOT EXISTS SEGURO_DW_G28126743.fact_registro_siniestro
(
    sk_fecha_siniestro integer NOT NULL,
    sk_fecha_respuesta integer NOT NULL,
    sk_dim_cliente integer NOT NULL,
    sk_dim_contrato integer NOT NULL,
    sk_dim_sucursal integer NOT NULL,
    sk_dim_producto integer NOT NULL,
    sk_dim_siniestro integer NOT NULL,
    cantidad integer,
    monto_reconocido numeric,
    monto_solicitado numeric,
    id_rechazo boolean,
    CONSTRAINT fact_registro_siniestro_pk PRIMARY KEY (sk_fecha_siniestro, sk_fecha_respuesta, sk_dim_cliente, sk_dim_contrato, sk_dim_sucursal, sk_dim_producto, sk_dim_siniestro),
    CONSTRAINT sk_dim_cliente_fk FOREIGN KEY (sk_dim_cliente)
        REFERENCES SEGURO_DW_G28126743.dim_cliente (sk_dim_cliente) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT sk_dim_contrato_fk FOREIGN KEY (sk_dim_contrato)
        REFERENCES SEGURO_DW_G28126743.dim_contrato (sk_dim_contrato) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT sk_dim_producto_fk FOREIGN KEY (sk_dim_producto)
        REFERENCES SEGURO_DW_G28126743.dim_producto (sk_dim_producto) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT sk_dim_siniestro_fk FOREIGN KEY (sk_dim_siniestro)
        REFERENCES SEGURO_DW_G28126743.dim_siniestro (sk_dim_siniestro) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT sk_dim_sucursal_fk FOREIGN KEY (sk_dim_sucursal)
        REFERENCES SEGURO_DW_G28126743.dim_sucursal (sk_dim_sucursal) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT sk_fecha_respuesta_fk FOREIGN KEY (sk_fecha_respuesta)
        REFERENCES SEGURO_DW_G28126743.dim_tiempo (sk_dim_tiempo) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT sk_fecha_siniestro_fk FOREIGN KEY (sk_fecha_siniestro)
        REFERENCES SEGURO_DW_G28126743.dim_tiempo (sk_dim_tiempo) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
); 







