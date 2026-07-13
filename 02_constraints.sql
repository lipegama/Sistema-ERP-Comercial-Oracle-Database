-- Script para adicionar as constraints (chaves estrangeiras) do Sistema ERP Comercial

ALTER TABLE Endereco
ADD CONSTRAINT fk_endereco_cliente
FOREIGN KEY (cliente_id)
REFERENCES Cliente(cliente_id);

ALTER TABLE Funcionario
ADD CONSTRAINT fk_funcionario_cargo
FOREIGN KEY (cargo_id)
REFERENCES Cargo(cargo_id);

ALTER TABLE Produto
ADD CONSTRAINT fk_produto_categoria
FOREIGN KEY (categoria_id)
REFERENCES Categoria(categoria_id);

ALTER TABLE Produto
ADD CONSTRAINT fk_produto_fornecedor
FOREIGN KEY (fornecedor_id)
REFERENCES Fornecedor(fornecedor_id);

ALTER TABLE Compra
ADD CONSTRAINT fk_compra_fornecedor
FOREIGN KEY (fornecedor_id)
REFERENCES Fornecedor(fornecedor_id);

ALTER TABLE Compra
ADD CONSTRAINT fk_compra_funcionario
FOREIGN KEY (funcionario_id)
REFERENCES Funcionario(funcionario_id);

ALTER TABLE ItemCompra
ADD CONSTRAINT fk_itemcompra_compra
FOREIGN KEY (compra_id)
REFERENCES Compra(compra_id);

ALTER TABLE ItemCompra
ADD CONSTRAINT fk_itemcompra_produto
FOREIGN KEY (produto_id)
REFERENCES Produto(produto_id);

ALTER TABLE Venda
ADD CONSTRAINT fk_venda_cliente
FOREIGN KEY (cliente_id)
REFERENCES Cliente(cliente_id);

ALTER TABLE Venda
ADD CONSTRAINT fk_venda_funcionario
FOREIGN KEY (funcionario_id)
REFERENCES Funcionario(funcionario_id);

ALTER TABLE ItemVenda
ADD CONSTRAINT fk_itemvenda_venda
FOREIGN KEY (venda_id)
REFERENCES Venda(venda_id);

ALTER TABLE ItemVenda
ADD CONSTRAINT fk_itemvenda_produto
FOREIGN KEY (produto_id)
REFERENCES Produto(produto_id);

ALTER TABLE Pagamento
ADD CONSTRAINT fk_pagamento_venda
FOREIGN KEY (venda_id)
REFERENCES Venda(venda_id);

ALTER TABLE Usuario
ADD CONSTRAINT fk_usuario_funcionario
FOREIGN KEY (funcionario_id)
REFERENCES Funcionario(funcionario_id);

ALTER TABLE Usuario
ADD CONSTRAINT fk_usuario_perfil
FOREIGN KEY (perfil_id)
REFERENCES Perfil(perfil_id);

ALTER TABLE Auditoria
ADD CONSTRAINT fk_auditoria_usuario
FOREIGN KEY (usuario_id)
REFERENCES Usuario(usuario_id);
