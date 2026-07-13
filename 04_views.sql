-- Script para criação das views do Sistema ERP Comercial

-- View: Top 10 produtos mais vendidos
CREATE OR REPLACE VIEW vw_top_10_produtos_vendidos AS
SELECT
    p.nome_produto,
    SUM(iv.quantidade) AS total_vendido
FROM
    Produto p
JOIN
    ItemVenda iv ON p.produto_id = iv.produto_id
GROUP BY
    p.nome_produto
ORDER BY
    total_vendido DESC
FETCH FIRST 10 ROWS ONLY;

-- View: Ranking de vendedores
CREATE OR REPLACE VIEW vw_ranking_vendedores AS
SELECT
    f.nome AS nome_vendedor,
    COUNT(v.venda_id) AS total_vendas,
    SUM(v.valor_total) AS valor_total_vendido
FROM
    Funcionario f
JOIN
    Venda v ON f.funcionario_id = v.funcionario_id
GROUP BY
    f.nome
ORDER BY
    valor_total_vendido DESC;

-- View: Faturamento mensal
CREATE OR REPLACE VIEW vw_faturamento_mensal AS
SELECT
    TO_CHAR(data_venda, 'YYYY-MM') AS ano_mes,
    SUM(valor_total) AS faturamento
FROM
    Venda
WHERE
    status = 'Concluida'
GROUP BY
    TO_CHAR(data_venda, 'YYYY-MM')
ORDER BY
    ano_mes;

-- View: Ticket médio por cliente
CREATE OR REPLACE VIEW vw_ticket_medio_cliente AS
SELECT
    c.nome AS nome_cliente,
    COUNT(v.venda_id) AS total_vendas,
    AVG(v.valor_total) AS ticket_medio
FROM
    Cliente c
JOIN
    Venda v ON c.cliente_id = v.cliente_id
WHERE
    v.status = 'Concluida'
GROUP BY
    c.nome
ORDER BY
    ticket_medio DESC;

-- View: Produtos com estoque abaixo do mínimo (considerando mínimo como 10 unidades para exemplo)
CREATE OR REPLACE VIEW vw_produtos_estoque_baixo AS
SELECT
    produto_id,
    nome_produto,
    estoque
FROM
    Produto
WHERE
    estoque < 10
ORDER BY
    estoque ASC;
