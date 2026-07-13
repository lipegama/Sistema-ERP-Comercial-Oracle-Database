-- Script para criação das procedures do Sistema ERP Comercial

-- Procedure para cadastro de cliente
CREATE OR REPLACE PROCEDURE prc_cadastrar_cliente (
    p_nome IN VARCHAR2,
    p_cpf IN VARCHAR2,
    p_email IN VARCHAR2 DEFAULT NULL,
    p_telefone IN VARCHAR2 DEFAULT NULL
) IS
BEGIN
    INSERT INTO Cliente (nome, cpf, email, telefone)
    VALUES (p_nome, p_cpf, p_email, p_telefone);
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20002, 'CPF ou Email já cadastrado.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003, 'Erro ao cadastrar cliente: ' || SQLERRM);
END;
/

-- Procedure para cadastro de produto
CREATE OR REPLACE PROCEDURE prc_cadastrar_produto (
    p_nome_produto IN VARCHAR2,
    p_descricao IN VARCHAR2 DEFAULT NULL,
    p_preco_unitario IN NUMBER,
    p_estoque IN NUMBER,
    p_categoria_id IN NUMBER,
    p_fornecedor_id IN NUMBER
) IS
BEGIN
    INSERT INTO Produto (nome_produto, descricao, preco_unitario, estoque, categoria_id, fornecedor_id)
    VALUES (p_nome_produto, p_descricao, p_preco_unitario, p_estoque, p_categoria_id, p_fornecedor_id);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, 'Erro ao cadastrar produto: ' || SQLERRM);
END;
/

-- Procedure para realização de venda
CREATE OR REPLACE PROCEDURE prc_realizar_venda (
    p_cliente_id IN NUMBER,
    p_funcionario_id IN NUMBER,
    p_produtos IN SYS.ODCINUMBERLIST, -- Lista de IDs de produtos
    p_quantidades IN SYS.ODCINUMBERLIST -- Lista de quantidades correspondentes
) IS
    v_venda_id NUMBER;
    v_valor_total_venda NUMBER := 0;
    v_preco_unitario_produto NUMBER;
    v_estoque_atual NUMBER;
BEGIN
    -- Verificar se o cliente está ativo
    DECLARE
        v_cliente_ativo CHAR(1);
    BEGIN
        SELECT ativo INTO v_cliente_ativo FROM Cliente WHERE cliente_id = p_cliente_id;
        IF v_cliente_ativo = 'N' THEN
            RAISE_APPLICATION_ERROR(-20005, 'Cliente inativo não pode realizar compras.');
        END IF;
    END;

    -- Criar a venda
    INSERT INTO Venda (cliente_id, funcionario_id, data_venda, valor_total)
    VALUES (p_cliente_id, p_funcionario_id, SYSDATE, 0) -- Valor total será atualizado depois
    RETURNING venda_id INTO v_venda_id;

    -- Inserir itens da venda e atualizar estoque
    FOR i IN 1..p_produtos.COUNT LOOP
        SELECT preco_unitario, estoque INTO v_preco_unitario_produto, v_estoque_atual FROM Produto WHERE produto_id = p_produtos(i);

        IF v_estoque_atual < p_quantidades(i) THEN
            RAISE_APPLICATION_ERROR(-20006, 'Estoque insuficiente para o produto ID: ' || p_produtos(i));
        END IF;

        INSERT INTO ItemVenda (venda_id, produto_id, quantidade, preco_unitario, subtotal)
        VALUES (v_venda_id, p_produtos(i), p_quantidades(i), v_preco_unitario_produto, v_preco_unitario_produto * p_quantidades(i));

        UPDATE Produto
        SET estoque = estoque - p_quantidades(i)
        WHERE produto_id = p_produtos(i);

        v_valor_total_venda := v_valor_total_venda + (v_preco_unitario_produto * p_quantidades(i));
    END LOOP;

    -- Atualizar valor total da venda
    UPDATE Venda
    SET valor_total = v_valor_total_venda
    WHERE venda_id = v_venda_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20007, 'Erro ao realizar venda: ' || SQLERRM);
END;
/

-- Procedure para cancelamento de venda
CREATE OR REPLACE PROCEDURE prc_cancelar_venda (
    p_venda_id IN NUMBER
) IS
BEGIN
    -- Atualizar status da venda para 'Cancelada'
    UPDATE Venda
    SET status = 'Cancelada'
    WHERE venda_id = p_venda_id;

    -- Devolver estoque dos produtos da venda cancelada
    FOR item IN (SELECT produto_id, quantidade FROM ItemVenda WHERE venda_id = p_venda_id) LOOP
        UPDATE Produto
        SET estoque = estoque + item.quantidade
        WHERE produto_id = item.produto_id;
    END LOOP;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20008, 'Erro ao cancelar venda: ' || SQLERRM);
END;
/

-- Procedure para reposição de estoque
CREATE OR REPLACE PROCEDURE prc_repor_estoque (
    p_produto_id IN NUMBER,
    p_quantidade IN NUMBER
) IS
BEGIN
    UPDATE Produto
    SET estoque = estoque + p_quantidade
    WHERE produto_id = p_produto_id;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20009, 'Erro ao repor estoque: ' || SQLERRM);
END;
/
