-- --------------------------------------------------------
-- SCHEMA: contabil (COM PRÁTICA 01 INTEGRADA)
-- --------------------------------------------------------

CREATE SCHEMA IF NOT EXISTS contabil;

CREATE TABLE contabil.pagamento (
    id_pagamento SERIAL PRIMARY KEY,
    valor VARCHAR(10) NOT NULL,
    forma_pagamento VARCHAR(20) NOT NULL,
    data TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_servico_fk INT NOT NULL,
    id_pedido_fk INT NOT NULL,
    CONSTRAINT fk_pagamento_servico FOREIGN KEY (id_servico_fk) 
        REFERENCES site.servico (id_servico) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pagamento_pedido FOREIGN KEY (id_pedido_fk) 
        REFERENCES site.pedido (id_pedido) ON DELETE RESTRICT ON UPDATE CASCADE
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

    CONSTRAINT fk_conta_debito
        FOREIGN KEY (conta_debito_id)
        REFERENCES contabil.plano_contas (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_conta_credito
        FOREIGN KEY (conta_credito_id)
        REFERENCES contabil.plano_contas (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ========================================================
-- JUSTIFICATIVAS DAS FOREIGN KEYS
-- ========================================================

-- Pagamento - Serviço:
-- RESTRICT no DELETE para impedir que um serviço seja excluído
-- enquanto existir um pagamento relacionado a ele.
-- CASCADE no UPDATE para manter a referência atualizada caso
-- o identificador do serviço seja alterado.

-- Pagamento - Pedido:
-- RESTRICT no DELETE para impedir que um pedido seja excluído
-- enquanto existir um pagamento relacionado a ele, preservando
-- o registro financeiro da compra.
-- CASCADE no UPDATE para manter a referência atualizada caso
-- o identificador do pedido seja alterado.

-- Lançamento - Conta de débito:
-- RESTRICT no DELETE para impedir a exclusão de uma conta do
-- plano de contas que esteja sendo utilizada em lançamentos.
-- CASCADE no UPDATE para manter a referência atualizada caso
-- o identificador da conta seja alterado.

-- Lançamento - Conta de crédito:
-- RESTRICT no DELETE para impedir a exclusão de uma conta do
-- plano de contas que esteja sendo utilizada em lançamentos.
-- CASCADE no UPDATE para manter a referência atualizada caso
-- o identificador da conta seja alterado.