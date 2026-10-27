-- --------------------------------------------------------
-- SCHEMA: adm
-- --------------------------------------------------------

CREATE SCHEMA IF NOT EXISTS adm;

CREATE TABLE adm.funcionarios (
    id_funcionario SERIAL PRIMARY KEY,
    nome VARCHAR(20) NOT NULL,
    setor VARCHAR(20) NOT NULL,
    salario VARCHAR(10) NOT NULL,
    beneficio VARCHAR(255) DEFAULT NULL
);

INSERT INTO adm.funcionarios (nome, setor, salario, beneficio)
VALUES
('Ana Carolina', 'Administrativo', '2500.00', 'Vale transporte'),
('Bruno Henrique', 'Atendimento', '2200.00', 'Vale alimentação'),
('Juliana Martins', 'Financeiro', '2800.00', 'Vale alimentação'),
('Rafael Souza', 'Estoque', '2100.00', 'Vale transporte');

CREATE TABLE adm.estoque (
    id_estoque SERIAL PRIMARY KEY,
    id_produto_fk INT NOT NULL,
    CONSTRAINT fk_estoque_produto FOREIGN KEY (id_produto_fk) 
        REFERENCES site.produto (id_produto) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ========================================================
-- REVISÃO DAS FOREIGN KEYS
-- ========================================================

-- Carrinho → Estoque:
-- DELETE: CASCADE
-- UPDATE: CASCADE
-- Justificativa: ao excluir um item do estoque, os registros do carrinho relacionados a ele também são removidos.  No UPDATE, 
--  a referência é atualizada automaticamente.

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

    CONSTRAINT fk_historico_servico
        FOREIGN KEY (id_servico_fk)
        REFERENCES site.servico (id_servico)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_historico_cliente
        FOREIGN KEY (id_cliente_fk)
        REFERENCES site.tutor_cliente (id_cliente)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_historico_pet
        FOREIGN KEY (id_pet_fk)
        REFERENCES site.pet (id_pet)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_historico_produto
        FOREIGN KEY (id_produto_fk)
        REFERENCES site.produto (id_produto)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_historico_pedido
        FOREIGN KEY (id_pedido_fk)
        REFERENCES site.pedido (id_pedido)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_historico_funcionario
        FOREIGN KEY (id_funcionario_fk)
        REFERENCES adm.funcionarios (id_funcionario)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ========================================================
-- VIEW: LISTA_CLIENTES
-- ========================================================

-- Usuário: equipe administrativa
-- Objetivo: facilitar a consulta dos clientes cadastrados,
-- permitindo visualizar suas informações de forma rápida
-- para atividades administrativas.

CREATE VIEW adm.lista_clientes
 AS
 SELECT id_cliente,
    nome,
    cpf,
    telefone,
    endereco
   FROM site.tutor_cliente;

ALTER TABLE adm.lista_clientes
    OWNER TO postgres;


-- ========================================================
-- VIEW: RELATORIO_FUNCIONARIOS
-- ========================================================

-- Usuário: equipe administrativa
-- Objetivo: facilitar a consulta das informações dos funcionários,
-- permitindo visualizar nome, setor, salário e benefício
-- de forma rápida para acompanhamento administrativo.


CREATE VIEW adm.relatorio_funcionarios
 AS
 SELECT id_funcionario,
    nome,
    setor,
    salario,
    beneficio
   FROM adm.funcionarios;

ALTER TABLE adm.relatorio_funcionarios
    OWNER TO postgres;

-- ========================================================
-- JUSTIFICATIVAS DAS FOREIGN KEYS
-- ========================================================

-- Estoque → Produto:
-- CASCADE no DELETE para remover o registro de estoque
-- quando o produto correspondente for excluído.
-- CASCADE no UPDATE para manter a referência atualizada
-- caso o identificador do produto seja alterado.

-- Carrinho → Estoque:
-- CASCADE no DELETE para remover os registros do carrinho
-- relacionados a um item de estoque que foi excluído.
-- CASCADE no UPDATE para manter a referência atualizada
-- caso o identificador do estoque seja alterado.

-- Histórico → Serviço:
-- RESTRICT no DELETE para impedir a exclusão de um serviço
-- que possua registro no histórico, preservando o histórico.
-- CASCADE no UPDATE para manter a referência atualizada
-- caso o identificador do serviço seja alterado.

-- Histórico → Cliente:
-- RESTRICT no DELETE para impedir a exclusão de um cliente
-- que possua registros no histórico, preservando os registros.
-- CASCADE no UPDATE para manter a referência atualizada
-- caso o identificador do cliente seja alterado.

-- Histórico → Pet:
-- RESTRICT no DELETE para impedir a exclusão de um pet
-- que possua registros no histórico, preservando os registros.
-- CASCADE no UPDATE para manter a referência atualizada
-- caso o identificador do pet seja alterado.

-- Histórico → Produto:
-- RESTRICT no DELETE para impedir a exclusão de um produto
-- que possua registros no histórico, preservando os registros.
-- CASCADE no UPDATE para manter a referência atualizada
-- caso o identificador do produto seja alterado.

-- Histórico → Pedido:
-- RESTRICT no DELETE para impedir a exclusão de um pedido
-- que possua registro no histórico, preservando o histórico.
-- CASCADE no UPDATE para manter a referência atualizada
-- caso o identificador do pedido seja alterado.

-- Histórico → Funcionário:
-- RESTRICT no DELETE para impedir a exclusão de um funcionário
-- que possua registros no histórico, preservando os registros.
-- CASCADE no UPDATE para manter a referência atualizada
-- caso o identificador do funcionário seja alterado.