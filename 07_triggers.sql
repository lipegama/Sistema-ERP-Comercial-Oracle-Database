-- Script para criação dos triggers do Sistema ERP Comercial

-- Trigger para atualizar estoque após venda
CREATE OR REPLACE TRIGGER trg_atualizar_estoque_pos_venda
AFTER INSERT ON ItemVenda
FOR EACH ROW
BEGIN
    UPDATE Produto
    SET estoque = estoque - :NEW.quantidade
    WHERE produto_id = :NEW.produto_id;
END;
/

-- Trigger para registrar auditoria em alterações de produtos
CREATE OR REPLACE TRIGGER trg_auditar_produto_changes
AFTER UPDATE OR DELETE ON Produto
FOR EACH ROW
DECLARE
    v_acao VARCHAR2(20);
    v_usuario_id NUMBER;
BEGIN
    -- Obter o ID do usuário logado (exemplo, pode ser ajustado conforme a autenticação)
    -- Para este exemplo, vamos assumir um usuário padrão ou nulo se não houver contexto de sessão
    SELECT usuario_id INTO v_usuario_id FROM Usuario WHERE username = USER AND ROWNUM = 1;

    IF UPDATING THEN
        v_acao := 'UPDATE';
        INSERT INTO Auditoria (tabela_afetada, coluna_afetada, id_registro_afetado, acao, valor_antigo, valor_novo, usuario_id)
        VALUES (
            'Produto',
            'ALL',
            :OLD.produto_id,
            v_acao,
            'Nome: ' || :OLD.nome_produto || ', Preço: ' || :OLD.preco_unitario || ', Estoque: ' || :OLD.estoque,
            'Nome: ' || :NEW.nome_produto || ', Preço: ' || :NEW.preco_unitario || ', Estoque: ' || :NEW.estoque,
            v_usuario_id
        );
    ELSIF DELETING THEN
        v_acao := 'DELETE';
        INSERT INTO Auditoria (tabela_afetada, coluna_afetada, id_registro_afetado, acao, valor_antigo, valor_novo, usuario_id)
        VALUES (
            'Produto',
            'ALL',
            :OLD.produto_id,
            v_acao,
            'Nome: ' || :OLD.nome_produto || ', Preço: ' || :OLD.preco_unitario || ', Estoque: ' || :OLD.estoque,
            NULL,
            v_usuario_id
        );
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Usuário não encontrado, registrar com usuario_id nulo
        IF UPDATING THEN
            v_acao := 'UPDATE';
            INSERT INTO Auditoria (tabela_afetada, coluna_afetada, id_registro_afetado, acao, valor_antigo, valor_novo, usuario_id)
            VALUES (
                'Produto',
                'ALL',
                :OLD.produto_id,
                v_acao,
                'Nome: ' || :OLD.nome_produto || ', Preço: ' || :OLD.preco_unitario || ', Estoque: ' || :OLD.estoque,
                'Nome: ' || :NEW.nome_produto || ', Preço: ' || :NEW.preco_unitario || ', Estoque: ' || :NEW.estoque,
                NULL
            );
        ELSIF DELETING THEN
            v_acao := 'DELETE';
            INSERT INTO Auditoria (tabela_afetada, coluna_afetada, id_registro_afetado, acao, valor_antigo, valor_novo, usuario_id)
            VALUES (
                'Produto',
                'ALL',
                :OLD.produto_id,
                v_acao,
                'Nome: ' || :OLD.nome_produto || ', Preço: ' || :OLD.preco_unitario || ', Estoque: ' || :OLD.estoque,
                NULL,
                NULL
            );
        END IF;
    WHEN OTHERS THEN
        -- Tratar outros erros, se necessário
        NULL;
END;
/

-- Trigger para bloquear exclusão de clientes com vendas
CREATE OR REPLACE TRIGGER trg_bloquear_exclusao_cliente
BEFORE DELETE ON Cliente
FOR EACH ROW
DECLARE
    v_total_vendas NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_total_vendas
    FROM Venda
    WHERE cliente_id = :OLD.cliente_id;

    IF v_total_vendas > 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Não é possível excluir cliente que possui vendas registradas.');
    END IF;
END;
/
