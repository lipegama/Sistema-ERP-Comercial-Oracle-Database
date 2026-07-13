-- Script para consultas analíticas avançadas do Sistema ERP Comercial

-- 1. Top 10 produtos mais vendidos (já existe na view, mas aqui como consulta direta)
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

-- 2. Ranking de vendedores (já existe na view, mas aqui como consulta direta)
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

-- 3. Faturamento mensal (já existe na view, mas aqui como consulta direta)
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

-- 4. Ticket médio por cliente (já existe na view, mas aqui como consulta direta)
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

-- 5. Produtos com estoque abaixo do mínimo (já existe na view, mas aqui como consulta direta)
SELECT
    produto_id,
    nome_produto,
    estoque
FROM
    Produto
WHERE
    estoque < 10 -- Exemplo de mínimo
ORDER BY
    estoque ASC;

-- 6. Clientes que não compram há mais de 6 meses
SELECT
    c.cliente_id,
    c.nome,
    c.email
FROM
    Cliente c
LEFT JOIN (
    SELECT
        cliente_id,
        MAX(data_venda) AS ultima_compra
    FROM
        Venda
    WHERE
        status = 'Concluida'
    GROUP BY
        cliente_id
) ult_venda ON c.cliente_id = ult_venda.cliente_id
WHERE
    ult_venda.ultima_compra IS NULL OR ult_venda.ultima_compra < ADD_MONTHS(SYSDATE, -6);

-- 7. Lucro por categoria (exemplo simplificado: preço de venda - 70% do preço de venda como custo)
SELECT
    cat.nome_categoria,
    SUM(iv.subtotal - (iv.subtotal * 0.70)) AS lucro_estimado -- Assumindo custo de 70% do subtotal
FROM
    Categoria cat
JOIN
    Produto p ON cat.categoria_id = p.categoria_id
JOIN
    ItemVenda iv ON p.produto_id = iv.produto_id
JOIN
    Venda v ON iv.venda_id = v.venda_id
WHERE
    v.status = 'Concluida'
GROUP BY
    cat.nome_categoria
ORDER BY
    lucro_estimado DESC;

-- 8. Fornecedores com mais compras
SELECT
    f.nome_fantasia,
    COUNT(c.compra_id) AS total_compras,
    SUM(c.valor_total) AS valor_total_compras
FROM
    Fornecedor f
JOIN
    Compra c ON f.fornecedor_id = c.fornecedor_id
GROUP BY
    f.nome_fantasia
ORDER BY
    total_compras DESC;

-- 9. Produtos parados no estoque (sem vendas nos últimos 12 meses)
SELECT
    p.produto_id,
    p.nome_produto,
    p.estoque
FROM
    Produto p
LEFT JOIN (
    SELECT DISTINCT
        produto_id
    FROM
        ItemVenda
    JOIN
        Venda ON ItemVenda.venda_id = Venda.venda_id
    WHERE
        Venda.data_venda >= ADD_MONTHS(SYSDATE, -12)
) vendas_recentes ON p.produto_id = vendas_recentes.produto_id
WHERE
    vendas_recentes.produto_id IS NULL
    AND p.estoque > 0;

-- Exemplo de uso de CTE (Common Table Expression) para vendas por funcionário
WITH VendasPorFuncionario AS (
    SELECT
        f.funcionario_id,
        f.nome AS nome_funcionario,
        COUNT(v.venda_id) AS num_vendas,
        SUM(v.valor_total) AS total_vendido
    FROM
        Funcionario f
    JOIN
        Venda v ON f.funcionario_id = v.funcionario_id
    GROUP BY
        f.funcionario_id, f.nome
)
SELECT
    nome_funcionario,
    num_vendas,
    total_vendido
FROM
    VendasPorFuncionario
ORDER BY
    total_vendido DESC;

-- Exemplo de uso de ROW_NUMBER() para encontrar o produto mais caro por categoria
SELECT
    categoria_id,
    nome_produto,
    preco_unitario
FROM (
    SELECT
        categoria_id,
        nome_produto,
        preco_unitario,
        ROW_NUMBER() OVER (PARTITION BY categoria_id ORDER BY preco_unitario DESC) as rn
    FROM
        Produto
)
WHERE rn = 1;

-- Exemplo de uso de RANK() para ranking de clientes por valor total de compras
SELECT
    cliente_id,
    nome_cliente,
    total_gasto,
    RANK() OVER (ORDER BY total_gasto DESC) as ranking_cliente
FROM (
    SELECT
        c.cliente_id,
        c.nome AS nome_cliente,
        SUM(v.valor_total) AS total_gasto
    FROM
        Cliente c
    JOIN
        Venda v ON c.cliente_id = v.cliente_id
    WHERE
        v.status = 'Concluida'
    GROUP BY
        c.cliente_id, c.nome
);
