-- Script para criação das functions do Sistema ERP Comercial

-- Function para calcular desconto
CREATE OR REPLACE FUNCTION calcular_desconto (
    p_valor_total IN NUMBER,
    p_percentual_desconto IN NUMBER
) RETURN NUMBER IS
    v_valor_com_desconto NUMBER;
BEGIN
    IF p_percentual_desconto < 0 OR p_percentual_desconto > 100 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Percentual de desconto inválido. Deve ser entre 0 e 100.');
    END IF;
    v_valor_com_desconto := p_valor_total * (1 - (p_percentual_desconto / 100));
    RETURN v_valor_com_desconto;
END;
/

-- Function para calcular comissão (exemplo: 5% sobre o valor da venda)
CREATE OR REPLACE FUNCTION calcular_comissao (
    p_valor_venda IN NUMBER
) RETURN NUMBER IS
    v_comissao NUMBER;
BEGIN
    v_comissao := p_valor_venda * 0.05; -- 5% de comissão
    RETURN v_comissao;
END;
/

-- Function para verificar se cliente é VIP (exemplo: clientes com mais de 5 vendas)
CREATE OR REPLACE FUNCTION verificar_cliente_vip (
    p_cliente_id IN NUMBER
) RETURN VARCHAR2 IS
    v_total_vendas NUMBER;
    v_is_vip VARCHAR2(1);
BEGIN
    SELECT COUNT(venda_id)
    INTO v_total_vendas
    FROM Venda
    WHERE cliente_id = p_cliente_id
    AND status = 'Concluida';

    IF v_total_vendas >= 5 THEN
        v_is_vip := 'S';
    ELSE
        v_is_vip := 'N';
    END IF;

    RETURN v_is_vip;
END;
/
