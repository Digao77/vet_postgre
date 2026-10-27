
-- SCHEMA: SITE


CREATE SCHEMA IF NOT EXISTS site;



-- TABELA: USUARIOS


CREATE TABLE site.usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) DEFAULT NULL,
    email VARCHAR(100) DEFAULT NULL,
    senha VARCHAR(255) DEFAULT NULL
);



-- TABELA: TUTOR_CLIENTE


CREATE TABLE site.tutor_cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    cpf VARCHAR(20) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    endereco VARCHAR(100) NOT NULL
);

-- TABELA: PET


CREATE TABLE site.pet (
    id_pet SERIAL PRIMARY KEY,
    nome VARCHAR(20) DEFAULT NULL,
    idade INT DEFAULT NULL,
    peso INT DEFAULT NULL,
    especie VARCHAR(20) NOT NULL,
    raca VARCHAR(20) DEFAULT NULL,
    id_cliente_fk INT NOT NULL,

    CONSTRAINT fk_pet_cliente
        FOREIGN KEY (id_cliente_fk)
        REFERENCES site.tutor_cliente (id_cliente)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


-- TABELA: PRODUTO

CREATE TABLE site.produto (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    variacao VARCHAR(20) NOT NULL,
    valor VARCHAR(10) NOT NULL
);


-- TABELA: CARRINHO

CREATE TABLE site.carrinho (
    id_carrinho SERIAL PRIMARY KEY,
    id_produto_fk INT NOT NULL,
    id_estoque_fk INT NOT NULL,
    id_cliente_fk INT NOT NULL,

    CONSTRAINT fk_carrinho_cliente
        FOREIGN KEY (id_cliente_fk)
        REFERENCES site.tutor_cliente (id_cliente)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_carrinho_produto
        FOREIGN KEY (id_produto_fk)
        REFERENCES site.produto (id_produto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- TABELA: PEDIDO

CREATE TABLE site.pedido (
    id_pedido SERIAL PRIMARY KEY,
    status VARCHAR(20) NOT NULL,
    id_carrinho_fk INT NOT NULL,

    CONSTRAINT fk_pedido_carrinho
    FOREIGN KEY (id_carrinho_fk)
    REFERENCES site.carrinho (id_carrinho)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);


-- TABELA: SERVICO

CREATE TABLE site.servico (
    id_servico SERIAL PRIMARY KEY,
    tipo VARCHAR(20) NOT NULL,
    valor VARCHAR(10) NOT NULL,
    data TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_cliente_fk INT NOT NULL,
    id_pet_fk INT NOT NULL,

    CONSTRAINT fk_servico_cliente
        FOREIGN KEY (id_cliente_fk)
        REFERENCES site.tutor_cliente (id_cliente)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_servico_pet
        FOREIGN KEY (id_pet_fk)
        REFERENCES site.pet (id_pet)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ========================================================
-- DADOS: TUTOR_CLIENTE
-- ========================================================

INSERT INTO site.tutor_cliente (nome, cpf, telefone, endereco)
VALUES
('Mariana Alves', '123.456.789-01', '(32) 99911-2233', 'Rua das Flores, 120'),
('Carlos Mendes', '234.567.890-12', '(32) 99822-3344', 'Av. Astolfo Dutra, 450'),
('Fernanda Souza', '345.678.901-23', '(32) 99733-4455', 'Rua João XXIII, 85'),
('Lucas Ferreira', '456.789.012-34', '(32) 99644-5566', 'Rua Coronel Vieira, 210');


-- ========================================================
-- DADOS: PET
-- ========================================================

INSERT INTO site.pet
(id_pet, nome, idade, peso, especie, raca, id_cliente_fk)
VALUES
(1, 'Maggie', 6, 7, 'Cachorro Femea', 'SRD', 1),
(2, 'Nina', 8, 15, 'Cachorro Femea', 'SRD', 1),
(3, 'Duke', 0, 3, 'Cachorro Macho', 'SRD', 1),
(4, 'Maggie', 6, 7, 'Cachorro Femea', 'SRD', 1),
(5, 'Nina', 8, 15, 'Cachorro Femea', 'SRD', 1),
(6, 'Duke', 0, 3, 'Cachorro Macho', 'SRD', 1);


-- ========================================================
-- DADOS: PRODUTO
-- ========================================================

INSERT INTO site.produto
(id_produto, nome, tipo, variacao, valor)
VALUES
(1, 'Antipulgas Bravecto', 'Medicamento', 'Cães de 10 a 20kg', '195,00'),
(2, 'Ração Sachê Gatos', 'Alimentação', 'Sabor Carne 85g', '4.50'),
(3, 'Shampoo 6 em 1', 'Higiene', 'Frasco 500ml', '38.90'),
(4, 'Coleira Antiparasitária', 'Acessório', 'Tamanho P', '189.00'),
(5, 'Brinquedo Mordedor de Corda', 'Brinquedo', 'Tamanho G', '29.90'),
(6, 'Vermifugo cães e Gatos', 'Medicamento', 'Frasco 20ml', '22,00'),
(7, 'Areia Sanitária', 'Higiene', 'Pacote 3kg', '45,90'),
(8, 'Arranhador de canto para gatos', 'acessório', 'Cor Marrom', '79,90'),
(9, 'Petisco Bifinho de frango', 'alimentação', 'pacote 500g', '6,80'),
(10, 'Ração premium cães adultos', 'Alimentação', 'pacote 15kg', '249,90'),
(11, 'Antipulgas Bravecto', 'Medicamento', 'Cães de 10 a 20kg', '195,00'),
(12, 'Ração Sachê Gatos', 'Alimentação', 'Sabor Carne 85g', '4.50'),
(13, 'Shampoo 6 em 1', 'Higiene', 'Frasco 500ml', '38.90'),
(14, 'Coleira Antiparasitária', 'Acessório', 'Tamanho P', '189.00'),
(15, 'Brinquedo Mordedor de Corda', 'Brinquedo', 'Tamanho G', '29.90'),
(16, 'Vermifugo cães e Gatos', 'Medicamento', 'Frasco 20ml', '22,00'),
(17, 'Areia Sanitária', 'Higiene', 'Pacote 3kg', '45,90'),
(18, 'Arranhador de canto para gatos', 'acessório', 'Cor Marrom', '79,90'),
(19, 'Petisco Bifinho de frango', 'alimentação', 'pacote 500g', '6,80'),
(20, 'Ração premium cães adultos', 'Alimentação', 'pacote 15kg', '249,90');

-- ========================================================
-- AJUSTE DAS SEQUÊNCIAS
-- ========================================================

SELECT setval(
    pg_get_serial_sequence('site.tutor_cliente', 'id_cliente'),
    COALESCE(MAX(id_cliente), 1)
)
FROM site.tutor_cliente;

SELECT setval(
    pg_get_serial_sequence('site.pet', 'id_pet'),
    COALESCE(MAX(id_pet), 1)
)
FROM site.pet;

SELECT setval(
    pg_get_serial_sequence('site.produto', 'id_produto'),
    COALESCE(MAX(id_produto), 1)
)
FROM site.produto;

-- ========================================================
-- VIEW: CLIENTES_PETS
-- ========================================================

-- Usuário: equipe do site
-- Objetivo: facilitar a consulta dos clientes e seus respectivos pets,
-- evitando que a aplicação precise realizar o JOIN entre as tabelas.


CREATE VIEW site.clientes_pets AS
SELECT
    tc.nome AS cliente,
    p.nome AS pet,
    p.idade,
    p.especie,
    p.raca
FROM site.tutor_cliente tc
JOIN site.pet p
    ON tc.id_cliente = p.id_cliente_fk;

-- ========================================================
-- VIEW: PRODUTO_CATALOGO
-- ========================================================

-- Usuário: equipe do site
-- Objetivo: facilitar a visualização dos produtos disponíveis
-- no catálogo, mostrando apenas nome e valor.


CREATE VIEW site.produto_catalogo AS
SELECT
    nome,
    valor
FROM site.produto;

-- ========================================================
-- CONSTRAINTS CHECK
-- ========================================================

-- Regra: a idade do pet não pode ser negativa.
ALTER TABLE site.pet
ADD CONSTRAINT chk_pet_idade
CHECK (idade >= 0);

-- Regra: o peso do pet deve ser maior que zero.
ALTER TABLE site.pet
ADD CONSTRAINT chk_pet_peso
CHECK (peso > 0);

-- Regra: o pedido deve possuir um status válido.
ALTER TABLE site.pedido
ADD CONSTRAINT chk_pedido_status
CHECK (status IN ('pendente', 'pago', 'cancelado', 'concluido'));

-- ========================================================
-- REVISÃO DAS FOREIGN KEYS
-- ========================================================

-- Pet → Cliente
-- DELETE: RESTRICT
-- UPDATE: CASCADE
-- Justificativa: impede que a exclusão de um cliente exclua automaticamente seus pets, preservando os
-- registros relacionados. No UPDATE, a referência é atualizada automaticamente.

-- Carrinho → Cliente
-- DELETE: RESTRICT
-- UPDATE: CASCADE
-- Justificativa: impede que a exclusão de um cliente exclua automaticamente seu carrinho, preservando os
-- registros relacionados. No UPDATE, a referência é atualizada automaticamente.

-- Carrinho → Produto
-- DELETE: CASCADE
-- UPDATE: CASCADE
-- Justificativa: ao excluir um produto, os registros do carrinho relacionados a ele também são removidos,
-- evitando referências a produtos inexistentes.

-- Pedido → Carrinho
-- DELETE: RESTRICT
-- UPDATE: CASCADE
-- Justificativa: impede que a exclusão de um carrinho exclua automaticamente um pedido relacionado,
-- preservando o registro da compra. No UPDATE, areferência é atualizada automaticamente.

-- Serviço → Cliente
-- DELETE: RESTRICT
-- UPDATE: CASCADE
-- Justificativa: impede que a exclusão de um cliente exclua automaticamente
-- os serviços relacionados, preservando os registros. No UPDATE, a referência
-- é atualizada automaticamente.

-- Serviço → Pet
-- DELETE: RESTRICT
-- UPDATE: CASCADE
-- Justificativa: impede que a exclusão de um pet exclua automaticamente
-- os serviços relacionados, preservando os registros. No UPDATE, a referência
-- é atualizada automaticamente.