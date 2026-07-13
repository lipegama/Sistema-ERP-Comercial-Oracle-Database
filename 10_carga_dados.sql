-- Script para carga de dados fictícios no Sistema ERP Comercial
-- Este script é um exemplo e pode ser expandido para gerar mais dados.
-- Para grandes volumes, considere ferramentas de geração de dados ou scripts PL/SQL mais complexos.

-- Inserção de dados para Cargo
INSERT INTO Cargo (nome_cargo, descricao) VALUES (
    'Gerente', 'Responsável pela gestão geral da equipe e operações.'
);
INSERT INTO Cargo (nome_cargo, descricao) VALUES (
    'Vendedor', 'Responsável pelas vendas e atendimento ao cliente.'
);
INSERT INTO Cargo (nome_cargo, descricao) VALUES (
    'Estoquista', 'Responsável pelo controle e organização do estoque.'
);
INSERT INTO Cargo (nome_cargo, descricao) VALUES (
    'Analista de TI', 'Responsável pela manutenção e desenvolvimento de sistemas.'
);

-- Inserção de dados para Perfil
INSERT INTO Perfil (nome_perfil, descricao) VALUES (
    'Administrador', 'Acesso total ao sistema.'
);
INSERT INTO Perfil (nome_perfil, descricao) VALUES (
    'Vendas', 'Acesso a módulos de vendas e clientes.'
);
INSERT INTO Perfil (nome_perfil, descricao) VALUES (
    'Estoque', 'Acesso a módulos de estoque e produtos.'
);

-- Inserção de dados para Funcionário
INSERT INTO Funcionario (nome, cpf, email, telefone, cargo_id) VALUES (
    'João Silva', '111.111.111-11', 'joao.silva@empresa.com', '11987654321', (SELECT cargo_id FROM Cargo WHERE nome_cargo = 'Gerente')
);
INSERT INTO Funcionario (nome, cpf, email, telefone, cargo_id) VALUES (
    'Maria Souza', '222.222.222-22', 'maria.souza@empresa.com', '11987654322', (SELECT cargo_id FROM Cargo WHERE nome_cargo = 'Vendedor')
);
INSERT INTO Funcionario (nome, cpf, email, telefone, cargo_id) VALUES (
    'Pedro Santos', '333.333.333-33', 'pedro.santos@empresa.com', '11987654323', (SELECT cargo_id FROM Cargo WHERE nome_cargo = 'Estoquista')
);

-- Inserção de dados para Usuário
INSERT INTO Usuario (funcionario_id, username, senha, perfil_id) VALUES (
    (SELECT funcionario_id FROM Funcionario WHERE nome = 'João Silva'), 'joao.admin', 'senha123', (SELECT perfil_id FROM Perfil WHERE nome_perfil = 'Administrador')
);
INSERT INTO Usuario (funcionario_id, username, senha, perfil_id) VALUES (
    (SELECT funcionario_id FROM Funcionario WHERE nome = 'Maria Souza'), 'maria.vendas', 'senha123', (SELECT perfil_id FROM Perfil WHERE nome_perfil = 'Vendas')
);

-- Inserção de dados para Fornecedor
INSERT INTO Fornecedor (nome_fantasia, razao_social, cnpj, email, telefone) VALUES (
    'Tech Suprimentos', 'Tech Suprimentos Ltda', '00.000.000/0001-00', 'contato@techsuprimentos.com', '1130001000'
);
INSERT INTO Fornecedor (nome_fantasia, razao_social, cnpj, email, telefone) VALUES (
    'Eletrônicos SA', 'Eletrônicos S.A.', '01.000.000/0001-01', 'vendas@eletronicos.com', '1130001001'
);

-- Inserção de dados para Categoria
INSERT INTO Categoria (nome_categoria, descricao) VALUES (
    'Eletrônicos', 'Produtos eletrônicos em geral.'
);
INSERT INTO Categoria (nome_categoria, descricao) VALUES (
    'Informática', 'Componentes e periféricos de informática.'
);
INSERT INTO Categoria (nome_categoria, descricao) VALUES (
    'Escritório', 'Materiais e equipamentos de escritório.'
);

-- Inserção de dados para Produto
INSERT INTO Produto (nome_produto, descricao, preco_unitario, estoque, categoria_id, fornecedor_id) VALUES (
    'Smartphone X', 'Smartphone de última geração com câmera avançada.', 2500.00, 100, (SELECT categoria_id FROM Categoria WHERE nome_categoria = 'Eletrônicos'), (SELECT fornecedor_id FROM Fornecedor WHERE nome_fantasia = 'Tech Suprimentos')
);
INSERT INTO Produto (nome_produto, descricao, preco_unitario, estoque, categoria_id, fornecedor_id) VALUES (
    'Notebook Gamer', 'Notebook de alta performance para jogos.', 7000.00, 50, (SELECT categoria_id FROM Categoria WHERE nome_categoria = 'Informática'), (SELECT fornecedor_id FROM Fornecedor WHERE nome_fantasia = 'Eletrônicos SA')
);
INSERT INTO Produto (nome_produto, descricao, preco_unitario, estoque, categoria_id, fornecedor_id) VALUES (
    'Monitor LED 24', 'Monitor Full HD para uso geral.', 800.00, 200, (SELECT categoria_id FROM Categoria WHERE nome_categoria = 'Eletrônicos'), (SELECT fornecedor_id FROM Fornecedor WHERE nome_fantasia = 'Tech Suprimentos')
);
INSERT INTO Produto (nome_produto, descricao, preco_unitario, estoque, categoria_id, fornecedor_id) VALUES (
    'Teclado Mecânico', 'Teclado mecânico RGB para gamers.', 350.00, 150, (SELECT categoria_id FROM Categoria WHERE nome_categoria = 'Informática'), (SELECT fornecedor_id FROM Fornecedor WHERE nome_fantasia = 'Eletrônicos SA')
);

-- Inserção de dados para Cliente
-- Gerar 20.000 clientes fictícios
DECLARE
    v_nome VARCHAR2(100);
    v_cpf VARCHAR2(14);
    v_email VARCHAR2(100);
    v_telefone VARCHAR2(20);
BEGIN
    FOR i IN 1..20000 LOOP
        v_nome := 'Cliente ' || i;
        v_cpf := TO_CHAR(i) || TO_CHAR(i+1) || TO_CHAR(i+2) || '.' || TO_CHAR(i+3) || TO_CHAR(i+4) || TO_CHAR(i+5) || '.' || TO_CHAR(i+6) || TO_CHAR(i+7) || TO_CHAR(i+8) || '-' || TO_CHAR(i+9) || TO_CHAR(i+10);
        v_email := 'cliente' || i || '@email.com';
        v_telefone := '55' || LPAD(TO_CHAR(DBMS_RANDOM.VALUE(1000000000, 9999999999)), 10, '0');

        INSERT INTO Cliente (nome, cpf, email, telefone, ativo)
        VALUES (v_nome, v_cpf, v_email, v_telefone, CASE WHEN MOD(i, 100) = 0 THEN 'N' ELSE 'S' END); -- 1% de clientes inativos
    END LOOP;
    COMMIT;
END;
/

-- Inserção de dados para Endereço (para alguns clientes)
DECLARE
    v_cliente_id NUMBER;
BEGIN
    FOR i IN 1..5000 LOOP -- Gerar endereços para 5000 clientes
        SELECT cliente_id INTO v_cliente_id FROM Cliente WHERE ROWNUM = 1 AND cliente_id >= i ORDER BY cliente_id;
        INSERT INTO Endereco (cliente_id, logradouro, numero, complemento, bairro, cidade, estado, cep, tipo_endereco) VALUES (
            v_cliente_id, 'Rua Fictícia ' || i, TO_CHAR(MOD(i, 100) + 1), 'Apto ' || TO_CHAR(MOD(i, 10)), 'Centro', 'Cidade Fictícia', 'SP', '00000-00' || TO_CHAR(MOD(i, 10)), 'Residencial'
        );
    END LOOP;
    COMMIT;
END;
/

-- Inserção de dados para Venda e ItemVenda
-- Gerar 80.000 vendas fictícias
DECLARE
    v_cliente_id NUMBER;
    v_funcionario_id NUMBER;
    v_data_venda DATE;
    v_venda_id NUMBER;
    v_produto_id NUMBER;
    v_quantidade NUMBER;
    v_preco_unitario NUMBER;
    v_valor_total_venda NUMBER;
BEGIN
    FOR i IN 1..80000 LOOP
        -- Selecionar cliente e funcionário aleatoriamente
        SELECT cliente_id INTO v_cliente_id FROM Cliente WHERE ativo = 'S' ORDER BY DBMS_RANDOM.VALUE FETCH FIRST 1 ROW ONLY;
        SELECT funcionario_id INTO v_funcionario_id FROM Funcionario WHERE cargo_id = (SELECT cargo_id FROM Cargo WHERE nome_cargo = 'Vendedor') ORDER BY DBMS_RANDOM.VALUE FETCH FIRST 1 ROW ONLY;

        -- Data da venda nos últimos 2 anos
        v_data_venda := TRUNC(SYSDATE - DBMS_RANDOM.VALUE(1, 730));

        -- Criar a venda
        INSERT INTO Venda (cliente_id, funcionario_id, data_venda, valor_total, status)
        VALUES (v_cliente_id, v_funcionario_id, v_data_venda, 0, CASE WHEN MOD(i, 20) = 0 THEN 'Cancelada' ELSE 'Concluida' END) -- 5% de vendas canceladas
        RETURNING venda_id INTO v_venda_id;

        v_valor_total_venda := 0;

        -- Adicionar 1 a 3 itens por venda
        FOR j IN 1..TRUNC(DBMS_RANDOM.VALUE(1, 4)) LOOP
            SELECT produto_id, preco_unitario INTO v_produto_id, v_preco_unitario FROM Produto ORDER BY DBMS_RANDOM.VALUE FETCH FIRST 1 ROW ONLY;
            v_quantidade := TRUNC(DBMS_RANDOM.VALUE(1, 5)); -- Quantidade entre 1 e 4

            INSERT INTO ItemVenda (venda_id, produto_id, quantidade, preco_unitario, subtotal)
            VALUES (v_venda_id, v_produto_id, v_quantidade, v_preco_unitario, v_preco_unitario * v_quantidade);

            v_valor_total_venda := v_valor_total_venda + (v_preco_unitario * v_quantidade);
        END LOOP;

        -- Atualizar valor total da venda
        UPDATE Venda
        SET valor_total = v_valor_total_venda
        WHERE venda_id = v_venda_id;

        -- Inserir pagamento para vendas concluídas
        IF (SELECT status FROM Venda WHERE venda_id = v_venda_id) = 'Concluida' THEN
            INSERT INTO Pagamento (venda_id, data_pagamento, valor_pagamento, metodo_pagamento, status)
            VALUES (v_venda_id, v_data_venda + DBMS_RANDOM.VALUE(0, 7), v_valor_total_venda, 'Cartão de Crédito', 'Aprovado');
        END IF;

    END LOOP;
    COMMIT;
END;
/

-- Inserção de dados para Compra e ItemCompra
-- Gerar algumas compras fictícias
DECLARE
    v_fornecedor_id NUMBER;
    v_funcionario_id NUMBER;
    v_data_compra DATE;
    v_compra_id NUMBER;
    v_produto_id NUMBER;
    v_quantidade NUMBER;
    v_preco_unitario NUMBER;
    v_valor_total_compra NUMBER;
BEGIN
    FOR i IN 1..1000 LOOP -- Gerar 1000 compras
        SELECT fornecedor_id INTO v_fornecedor_id FROM Fornecedor ORDER BY DBMS_RANDOM.VALUE FETCH FIRST 1 ROW ONLY;
        SELECT funcionario_id INTO v_funcionario_id FROM Funcionario WHERE cargo_id = (SELECT cargo_id FROM Cargo WHERE nome_cargo = 'Estoquista') ORDER BY DBMS_RANDOM.VALUE FETCH FIRST 1 ROW ONLY;

        v_data_compra := TRUNC(SYSDATE - DBMS_RANDOM.VALUE(1, 365));

        INSERT INTO Compra (fornecedor_id, funcionario_id, data_compra, valor_total)
        VALUES (v_fornecedor_id, v_funcionario_id, v_data_compra, 0)
        RETURNING compra_id INTO v_compra_id;

        v_valor_total_compra := 0;

        FOR j IN 1..TRUNC(DBMS_RANDOM.VALUE(1, 3)) LOOP -- 1 a 2 itens por compra
            SELECT produto_id, preco_unitario INTO v_produto_id, v_preco_unitario FROM Produto ORDER BY DBMS_RANDOM.VALUE FETCH FIRST 1 ROW ONLY;
            v_quantidade := TRUNC(DBMS_RANDOM.VALUE(5, 20)); -- Quantidade entre 5 e 19

            INSERT INTO ItemCompra (compra_id, produto_id, quantidade, preco_unitario, subtotal)
            VALUES (v_compra_id, v_produto_id, v_quantidade, v_preco_unitario * 0.8, (v_preco_unitario * 0.8) * v_quantidade); -- Preço de compra 80% do preço de venda

            v_valor_total_compra := v_valor_total_compra + ((v_preco_unitario * 0.8) * v_quantidade);

            -- Atualizar estoque do produto
            UPDATE Produto
            SET estoque = estoque + v_quantidade
            WHERE produto_id = v_produto_id;
        END LOOP;

        UPDATE Compra
        SET valor_total = v_valor_total_compra
        WHERE compra_id = v_compra_id;

    END LOOP;
    COMMIT;
END;
/

-- Inserção de dados de auditoria (exemplo, triggers já cuidam disso)
-- INSERT INTO Auditoria (tabela_afetada, id_registro_afetado, acao, valor_antigo, valor_novo, usuario_id)
-- VALUES ('Produto', 1, 'UPDATE', 'Estoque: 100', 'Estoque: 99', 1);

COMMIT;
