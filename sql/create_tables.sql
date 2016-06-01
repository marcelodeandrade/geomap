DROP DATABASE IF EXISTS geomap;

CREATE DATABASE geomap;

USE geomap;

CREATE TABLE geomap.estados 
(
	codigo INT NOT NULL,
	uf NVARCHAR(2) NOT NULL,
	nome NVARCHAR(255) NOT NULL,

	CONSTRAINT pk_estados_id PRIMARY KEY (codigo)
);

CREATE TABLE geomap.mesoregioes 
(
	codigo INT NOT NULL,
	nome NVARCHAR(255) NOT NULL,
	
	codigo_estado INT NOT NULL,
	CONSTRAINT fk_mesoregioes_estados
    FOREIGN KEY (codigo_estado)
    REFERENCES estados (codigo),
	
    CONSTRAINT pk_mesoregioes_id PRIMARY KEY (codigo)
);

CREATE TABLE geomap.microregioes 
(
	codigo INT NOT NULL,
	nome NVARCHAR(255) NOT NULL,
	codigo_mesoregiao INT NOT NULL, 

	CONSTRAINT fk_microregioes_mesoregioes
    FOREIGN KEY (codigo_mesoregiao)
    REFERENCES mesoregioes (codigo),

    CONSTRAINT pk_microregioes_id PRIMARY KEY (codigo)
);

CREATE TABLE geomap.municipios 
(
	codigo INT NOT NULL,
	nome NVARCHAR(255) NOT NULL,
	nome_sem_acentos NVARCHAR(255) NOT NULL,
	codigo_microregiao INT NOT NULL,

	CONSTRAINT fk_municipios_microregioes
    FOREIGN KEY (codigo_microregiao)
    REFERENCES microregioes (codigo),

    CONSTRAINT pk_municipios_id PRIMARY KEY (codigo)
);

CREATE TABLE geomap.censo 
(
	codigo_estado INT NOT NULL,
	geo_mesoregioes_codigo INT NOT NULL,
	geo_microregioes_codigo INT NOT NULL,
	geo_municipios_codigo INT NOT NULL,
	domicilios_ocupados INT NOT NULL,
	populacao INT NOT NULL,
	populacao_masculina INT NOT NULL,
	populacao_feminina INT NOT NULL,
	populacao_urbana INT NOT NULL,
	populacao_rural INT NOT NULL,
	pib FLOAT NOT NULL,
	pib_participacao FLOAT NOT NULL,

	CONSTRAINT fk_censo_estados 
	FOREIGN KEY (codigo_estado) 
	REFERENCES estados (codigo),

	CONSTRAINT fk_censo_mesoregioes 
	FOREIGN KEY (geo_mesoregioes_codigo) 
	REFERENCES mesoregioes (codigo),

	CONSTRAINT fk_censo_microregioes 
	FOREIGN KEY (geo_microregioes_codigo) 
	REFERENCES microregioes (codigo),
	
	CONSTRAINT fk_censo_municipios 
	FOREIGN KEY (geo_municipios_codigo) 
	REFERENCES municipios (codigo)
);