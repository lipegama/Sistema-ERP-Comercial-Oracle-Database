-- Script para criação dos índices do Sistema ERP Comercial

-- Índices para chaves estrangeiras (melhoram o desempenho de JOINs)
CREATE INDEX idx_endereco_cliente_id ON Endereco (cliente_id);
CREATE INDEX idx_funcionario_cargo_id ON Funcionario (cargo_id);
CREATE INDEX idx_produto_categoria_id ON Produto (categoria_id);
CREATE INDEX idx_produto_fornecedor_id ON Produto (fornecedor_id);
CREATE INDEX idx_compra_fornecedor_id ON Compra (fornecedor_id);
CREATE INDEX idx_compra_funcionario_id ON Compra (funcionario_id);
CREATE INDEX idx_itemcompra_compra_id ON ItemCompra (compra_id);
CREATE INDEX idx_itemcompra_produto_id ON ItemCompra (produto_id);
CREATE INDEX idx_venda_cliente_id ON Venda (cliente_id);
CREATE INDEX idx_venda_funcionario_id ON Venda (funcionario_id);
CREATE INDEX idx_itemvenda_venda_id ON ItemVenda (venda_id);
CREATE INDEX idx_itemvenda_produto_id ON ItemVenda (produto_id);
CREATE INDEX idx_pagamento_venda_id ON Pagamento (venda_id);
CREATE INDEX idx_usuario_funcionario_id ON Usuario (funcionario_id);
CREATE INDEX idx_usuario_perfil_id ON Usuario (perfil_id);
CREATE INDEX idx_auditoria_usuario_id ON Auditoria (usuario_id);

-- Índices para colunas frequentemente consultadas
CREATE INDEX idx_cliente_cpf ON Cliente (cpf);
CREATE INDEX idx_cliente_email ON Cliente (email);
CREATE INDEX idx_funcionario_cpf ON Funcionario (cpf);
CREATE INDEX idx_funcionario_email ON Funcionario (email);
CREATE INDEX idx_fornecedor_cnpj ON Fornecedor (cnpj);
CREATE INDEX idx_fornecedor_razao_social ON Fornecedor (razao_social);
CREATE INDEX idx_produto_nome ON Produto (nome_produto);
CREATE INDEX idx_produto_estoque ON Produto (estoque);
CREATE INDEX idx_venda_data ON Venda (data_venda);
CREATE INDEX idx_usuario_username ON Usuario (username);
CREATE INDEX idx_auditoria_tabela_acao ON Auditoria (tabela_afetada, acao);
