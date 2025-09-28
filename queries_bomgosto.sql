-- BomGosto Cafeteria - Script SQL
-- Observação: O DDL abaixo é opcional. As consultas (itens 1 a 5) funcionam desde que as tabelas
-- existam com os nomes e colunas indicados. O script usa SQL padrão compatível com PostgreSQL/MySQL/SQL Server
-- (pode haver pequenas diferenças de tipos/constraints entre SGBDs).

/*
Tabelas esperadas:

cardapio(
  codigo            INT PRIMARY KEY,
  nome              VARCHAR(120) UNIQUE NOT NULL,
  descricao         VARCHAR(500),
  preco_unitario    DECIMAL(10,2) NOT NULL
)

comanda(
  codigo            INT PRIMARY KEY,
  data              DATE NOT NULL,
  mesa              INT NOT NULL,
  cliente           VARCHAR(150) NOT NULL
)

item_comanda(
  comanda_codigo    INT NOT NULL,
  cardapio_codigo   INT NOT NULL,
  quantidade        INT NOT NULL,
  PRIMARY KEY (comanda_codigo, cardapio_codigo),
  FOREIGN KEY (comanda_codigo) REFERENCES comanda(codigo),
  FOREIGN KEY (cardapio_codigo) REFERENCES cardapio(codigo)
  -- Regra de negócio: não repetir o mesmo cardápio na mesma comanda garantida pela PK composta
)
*/

-- Opcional: DDL genérico (ajuste para seu SGBD se necessário)
-- Remova os comentários das linhas abaixo se quiser criar as tabelas do zero.
/*
CREATE TABLE cardapio (
  codigo INT PRIMARY KEY,
  nome VARCHAR(120) UNIQUE NOT NULL,
  descricao VARCHAR(500),
  preco_unitario DECIMAL(10,2) NOT NULL
);

CREATE TABLE comanda (
  codigo INT PRIMARY KEY,
  data DATE NOT NULL,
  mesa INT NOT NULL,
  cliente VARCHAR(150) NOT NULL
);

CREATE TABLE item_comanda (
  comanda_codigo INT NOT NULL,
  cardapio_codigo INT NOT NULL,
  quantidade INT NOT NULL,
  PRIMARY KEY (comanda_codigo, cardapio_codigo),
  CONSTRAINT fk_item_comanda__comanda FOREIGN KEY (comanda_codigo) REFERENCES comanda(codigo),
  CONSTRAINT fk_item_comanda__cardapio FOREIGN KEY (cardapio_codigo) REFERENCES cardapio(codigo)
);
*/

-- 1) Faça uma listagem do cardápio ordenada por nome
SELECT
  c.codigo,
  c.nome,
  c.descricao,
  c.preco_unitario
FROM cardapio c
ORDER BY c.nome;

-- 2) Apresente todas as comandas e os itens da comanda com preços, ordenando por data, código da comanda e nome do café
SELECT
  co.codigo            AS codigo_comanda,
  co.data              AS data,
  co.mesa              AS mesa,
  co.cliente           AS cliente,
  ca.nome              AS nome_cafe,
  ca.descricao         AS descricao_cafe,
  ic.quantidade        AS quantidade,
  ca.preco_unitario    AS preco_unitario,
  (ic.quantidade * ca.preco_unitario) AS preco_total_item
FROM comanda co
JOIN item_comanda ic ON ic.comanda_codigo = co.codigo
JOIN cardapio ca ON ca.codigo = ic.cardapio_codigo
ORDER BY co.data, co.codigo, ca.nome;

-- 3) Liste todas as comandas com uma coluna do valor total da comanda. Ordene por data
SELECT
  co.codigo,
  co.data,
  co.mesa,
  co.cliente,
  SUM(ic.quantidade * ca.preco_unitario) AS total_comanda
FROM comanda co
JOIN item_comanda ic ON ic.comanda_codigo = co.codigo
JOIN cardapio ca ON ca.codigo = ic.cardapio_codigo
GROUP BY co.codigo, co.data, co.mesa, co.cliente
ORDER BY co.data;

-- 4) Mesma listagem da questão anterior, mas apenas comandas com mais de um tipo de café
-- Assumimos que "mesmo tipo" refere-se a códigos distintos de cardápio na comanda
SELECT
  co.codigo,
  co.data,
  co.mesa,
  co.cliente,
  SUM(ic.quantidade * ca.preco_unitario) AS total_comanda
FROM comanda co
JOIN item_comanda ic ON ic.comanda_codigo = co.codigo
JOIN cardapio ca ON ca.codigo = ic.cardapio_codigo
GROUP BY co.codigo, co.data, co.mesa, co.cliente
HAVING COUNT(DISTINCT ic.cardapio_codigo) > 1
ORDER BY co.data;

-- 5) Total de faturamento por data, ordenado por data
SELECT
  co.data,
  SUM(ic.quantidade * ca.preco_unitario) AS faturamento_total
FROM comanda co
JOIN item_comanda ic ON ic.comanda_codigo = co.codigo
JOIN cardapio ca ON ca.codigo = ic.cardapio_codigo
GROUP BY co.data
ORDER BY co.data;