-- 1. LIMPEZA COMPLETA PARA RECRIAÇÃO DO ZERO
DROP SCHEMA IF EXISTS site CASCADE;
DROP SCHEMA IF EXISTS adm CASCADE;
DROP SCHEMA IF EXISTS contabil CASCADE;

-- 2. CRIAÇÃO DOS SCHEMAS
CREATE SCHEMA site;
CREATE SCHEMA adm;
CREATE SCHEMA contabil;

-- --------------------------------------------------------
-- SCHEMA: site
-- --------------------------------------------------------

CREATE TABLE site.usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) DEFAULT NULL,
    email VARCHAR(100) DEFAULT NULL,
    senha VARCHAR(255) DEFAULT NULL
);

CREATE TABLE site.tutor_cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    cpf VARCHAR(20) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    endereco VARCHAR(100) NOT NULL
);

CREATE TABLE site.pet (
    id_pet SERIAL PRIMARY KEY,
    nome VARCHAR(20) DEFAULT NULL,
    idade INT DEFAULT NULL,
    peso INT DEFAULT NULL,
    especie VARCHAR(20) NOT NULL,
    raca VARCHAR(20) DEFAULT NULL,
    id_cliente_fk INT NOT NULL,
    CONSTRAINT fk_pet_cliente FOREIGN KEY (id_cliente_fk) 
        REFERENCES site.tutor_cliente (id_cliente) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE site.produto (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    variacao VARCHAR(20) NOT NULL,
    valor VARCHAR(10) NOT NULL
);

CREATE TABLE site.carrinho (
    id_carrinho SERIAL PRIMARY KEY,
    id_produto_fk INT NOT NULL,
    id_estoque_fk INT NOT NULL,
    id_cliente_fk INT NOT NULL,
    CONSTRAINT fk_carrinho_cliente FOREIGN KEY (id_cliente_fk) 
        REFERENCES site.tutor_cliente (id_cliente) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_carrinho_produto FOREIGN KEY (id_produto_fk) 
        REFERENCES site.produto (id_produto) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE site.pedido (
    id_pedido SERIAL PRIMARY KEY,
    status VARCHAR(20) NOT NULL,
    id_carrinho_fk INT NOT NULL,
    CONSTRAINT fk_pedido_carrinho FOREIGN KEY (id_carrinho_fk) 
        REFERENCES site.carrinho (id_carrinho) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE site.servico (
    id_servico SERIAL PRIMARY KEY,
    tipo VARCHAR(20) NOT NULL,
    valor VARCHAR(10) NOT NULL,
    data TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_cliente_fk INT NOT NULL,
    id_pet_fk INT NOT NULL,
    CONSTRAINT fk_servico_cliente FOREIGN KEY (id_cliente_fk) 
        REFERENCES site.tutor_cliente (id_cliente) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_servico_pet FOREIGN KEY (id_pet_fk) 
        REFERENCES site.pet (id_pet) ON DELETE CASCADE ON UPDATE CASCADE
);

-- --------------------------------------------------------
-- SCHEMA: adm
-- --------------------------------------------------------

CREATE TABLE adm.funcionarios (
    id_funcionario SERIAL PRIMARY KEY,
    nome VARCHAR(20) NOT NULL,
    setor VARCHAR(20) NOT NULL,
    salario VARCHAR(10) NOT NULL,
    beneficio VARCHAR(255) DEFAULT NULL
);

CREATE TABLE adm.estoque (
    id_estoque SERIAL PRIMARY KEY,
    id_produto_fk INT NOT NULL,
    CONSTRAINT fk_estoque_produto FOREIGN KEY (id_produto_fk) 
        REFERENCES site.produto (id_produto) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Foreign Key cruzada entre site.carrinho e adm.estoque
ALTER TABLE site.carrinho 
    ADD CONSTRAINT fk_carrinho_estoque FOREIGN KEY (id_estoque_fk) 
    REFERENCES adm.estoque (id_estoque) ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE adm.historico (
    id_historico SERIAL PRIMARY KEY,
    data TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_servico_fk INT NOT NULL,
    id_cliente_fk INT NOT NULL,
    id_pet_fk INT NOT NULL,
    id_produto_fk INT NOT NULL,
    id_pedido_fk INT NOT NULL,
    id_funcionario_fk INT NOT NULL,
    CONSTRAINT fk_historico_servico FOREIGN KEY (id_servico_fk) 
        REFERENCES site.servico (id_servico) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_historico_cliente FOREIGN KEY (id_cliente_fk) 
        REFERENCES site.tutor_cliente (id_cliente) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_historico_pet FOREIGN KEY (id_pet_fk) 
        REFERENCES site.pet (id_pet) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_historico_produto FOREIGN KEY (id_produto_fk) 
        REFERENCES site.produto (id_produto) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_historico_pedido FOREIGN KEY (id_pedido_fk) 
        REFERENCES site.pedido (id_pedido) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_historico_funcionario FOREIGN KEY (id_funcionario_fk) 
        REFERENCES adm.funcionarios (id_funcionario) ON DELETE CASCADE ON UPDATE CASCADE
);

-- --------------------------------------------------------
-- SCHEMA: contabil (COM PRÁTICA 01 INTEGRADA)
-- --------------------------------------------------------

CREATE TABLE contabil.pagamento (
    id_pagamento SERIAL PRIMARY KEY,
    valor VARCHAR(10) NOT NULL,
    forma_pagamento VARCHAR(20) NOT NULL,
    data TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_servico_fk INT NOT NULL,
    id_pedido_fk INT NOT NULL,
    CONSTRAINT fk_pagamento_servico FOREIGN KEY (id_servico_fk) 
        REFERENCES site.servico (id_servico) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_pagamento_pedido FOREIGN KEY (id_pedido_fk) 
        REFERENCES site.pedido (id_pedido) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tipos ENUM e Tabelas da Prática 01
CREATE TYPE contabil.tipo_conta_enum AS ENUM('ATIVO', 'PASSIVO', 'PATRIMONIO_LIQUIDO', 'RECEITA', 'DESPESA');
CREATE TYPE contabil.natureza_conta_enum AS ENUM('DEVEDORA', 'CREDORA');

CREATE TABLE contabil.plano_contas (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(40) NOT NULL,
    nome_conta VARCHAR(255) NOT NULL,
    tipo_conta contabil.tipo_conta_enum NOT NULL,
    natureza_conta contabil.natureza_conta_enum NOT NULL DEFAULT 'DEVEDORA'
);

CREATE TABLE contabil.lancamentos (
    id SERIAL PRIMARY KEY,
    data_lancamento DATE NOT NULL,
    historico VARCHAR(255),
    conta_debito_id INTEGER,
    conta_credito_id INTEGER,
    CONSTRAINT fk_conta_debito FOREIGN KEY (conta_debito_id) REFERENCES contabil.plano_contas (id),
    CONSTRAINT fk_conta_credito FOREIGN KEY (conta_credito_id) REFERENCES contabil.plano_contas (id)
);

-- --------------------------------------------------------
-- CARGA DOS DADOS POPULADOS DO ARQUIVO DUMP
-- --------------------------------------------------------

INSERT INTO adm.funcionarios (id_funcionario, nome, setor, salario, beneficio) VALUES
(7, 'Rodrigo de Oliveira', 'Administração', '5500', NULL),
(8, 'Isaque Rodrigues', 'Auxiliar Veterinario', '1850', NULL),
(9, 'Lucas Ladeira', 'Tosador / Banhista', '2100', NULL),
(10, 'João Vitor Ferreira', 'Recepção', '1900', NULL),
(11, 'Mateus Silva', 'Veterinário', '4800', NULL);

INSERT INTO site.tutor_cliente (id_cliente, nome, cpf, telefone, endereco) VALUES
(1, 'Rodrigo de Oliveira', '111.333.555-77', '99707070', 'Rua fulano de tal numero 1, aquele bairro lá.'),
(2, 'Rodrigo de Oliveira', '111.333.555-77', '99707070', 'Rua fulano de tal numero 1, aquele bairro lá.');

INSERT INTO site.pet (id_pet, nome, idade, peso, especie, raca, id_cliente_fk) VALUES
(1, 'Maggie', 6, 7, 'Cachorro Femea', 'SRD', 1),
(2, 'Nina', 8, 15, 'Cachorro Femea', 'SRD', 1),
(3, 'Duke', 0, 3, 'Cachorro Macho', 'SRD', 1),
(4, 'Maggie', 6, 7, 'Cachorro Femea', 'SRD', 1),
(5, 'Nina', 8, 15, 'Cachorro Femea', 'SRD', 1),
(6, 'Duke', 0, 3, 'Cachorro Macho', 'SRD', 1);

INSERT INTO site.produto (id_produto, nome, tipo, variacao, valor) VALUES
(1, 'Antipulgas Bravecto', 'Medicamento', 'Cães de 10 a 20kg', '195,00'),
(2, 'Ração Sachê Gatos ', 'Alimentação', 'Sabor Carne 85g', '4.50'),
(3, 'Shampoo 6 em 1', 'Higiene', 'Frasco 500ml', '38.90'),
(4, 'Coleira Antiparasitária ', 'Acessório', 'Tamanho P', '189.00'),
(5, 'Brinquedo Mordedor de Corda', 'Brinquedo', 'Tamanho G', '29.90'),
(6, 'Vermifugo cães e Gatos', 'Medicamento', 'Frasco 20ml', '22,00'),
(7, 'Areia Sanitária', 'Higiene', 'Pacote 3kg', '45,90'),
(8, 'Arranhador de canto para gatos', 'acessório', 'Cor Marrom', '79,90'),
(9, 'Petisco Bifinho de frango', 'alimentação', 'pacote 500g', '6,80'),
(10, 'Ração premium cães adultos', 'Alimentação', 'pacote 15kg', '249,90'),
(11, 'Antipulgas Bravecto', 'Medicamento', 'Cães de 10 a 20kg', '195,00'),
(12, 'Ração Sachê Gatos ', 'Alimentação', 'Sabor Carne 85g', '4.50'),
(13, 'Shampoo 6 em 1', 'Higiene', 'Frasco 500ml', '38.90'),
(14, 'Coleira Antiparasitária ', 'Acessório', 'Tamanho P', '189.00'),
(15, 'Brinquedo Mordedor de Corda', 'Brinquedo', 'Tamanho G', '29.90'),
(16, 'Vermifugo cães e Gatos', 'Medicamento', 'Frasco 20ml', '22,00'),
(17, 'Areia Sanitária', 'Higiene', 'Pacote 3kg', '45,90'),
(18, 'Arranhador de canto para gatos', 'acessório', 'Cor Marrom', '79,90'),
(19, 'Petisco Bifinho de frango', 'alimentação', 'pacote 500g', '6,80'),
(20, 'Ração premium cães adultos', 'Alimentação', 'pacote 15kg', '249,90');

-- --------------------------------------------------------
-- AJUSTE AUTOMÁTICO DAS SEQUÊNCIAS (SERIAL)
-- --------------------------------------------------------

SELECT setval(pg_get_serial_sequence('adm.funcionarios', 'id_funcionario'), COALESCE(MAX(id_funcionario), 1)) FROM adm.funcionarios;
SELECT setval(pg_get_serial_sequence('site.tutor_cliente', 'id_cliente'), COALESCE(MAX(id_cliente), 1)) FROM site.tutor_cliente;
SELECT setval(pg_get_serial_sequence('site.pet', 'id_pet'), COALESCE(MAX(id_pet), 1)) FROM site.pet;
SELECT setval(pg_get_serial_sequence('site.produto', 'id_produto'), COALESCE(MAX(id_produto), 1)) FROM site.produto;