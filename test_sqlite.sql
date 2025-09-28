.headers on
.mode column

-- Reset
DROP TABLE IF EXISTS item_comanda;
DROP TABLE IF EXISTS comanda;
DROP TABLE IF EXISTS cardapio;

-- DDL (SQLite-friendly)
CREATE TABLE cardapio (
  codigo INTEGER PRIMARY KEY,
  nome TEXT UNIQUE NOT NULL,
  descricao TEXT,
  preco_unitario REAL NOT NULL
);

CREATE TABLE comanda (
  codigo INTEGER PRIMARY KEY,
  data TEXT NOT NULL,  -- usar formato 'YYYY-MM-DD'
  mesa INTEGER NOT NULL,
  cliente TEXT NOT NULL
);

CREATE TABLE item_comanda (
  comanda_codigo INTEGER NOT NULL,
  cardapio_codigo INTEGER NOT NULL,
  quantidade INTEGER NOT NULL,
  PRIMARY KEY (comanda_codigo, cardapio_codigo),
  FOREIGN KEY (comanda_codigo) REFERENCES comanda(codigo),
  FOREIGN KEY (cardapio_codigo) REFERENCES cardapio(codigo)
);

-- Dados de exemplo
INSERT INTO cardapio (codigo, nome, descricao, preco_unitario) VALUES
(1, 'Espresso', 'Café espresso tradicional', 6.50),
(2, 'Cappuccino', 'Espresso com leite vaporizado e espuma', 9.00),
(3, 'Latte', 'Espresso com leite vaporizado', 8.50);

INSERT INTO comanda (codigo, data, mesa, cliente) VALUES
(101, '2025-09-25', 5, 'Ana'),
(102, '2025-09-25', 7, 'Bruno'),
(103, '2025-09-26', 3, 'Carla');

INSERT INTO item_comanda (comanda_codigo, cardapio_codigo, quantidade) VALUES
(101, 1, 2),
(101, 2, 1),
(102, 2, 2),
(103, 3, 1);

.echo on

-- 1)
SELECT
  c.codigo,
  c.nome,
  c.descricao,
  c.preco_unitario
FROM cardapio c
ORDER BY c.nome;

-- 2)
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

-- 3)
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

-- 4)
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

-- 5)
SELECT
  co.data,
  SUM(ic.quantidade * ca.preco_unitario) AS faturamento_total
FROM comanda co
JOIN item_comanda ic ON ic.comanda_codigo = co.codigo
JOIN cardapio ca ON ca.codigo = ic.cardapio_codigo
GROUP BY co.data
ORDER BY co.data;

.echo off
