-- 5.1 - Mostre a relação inteira
SELECT *
FROM Propriedade
LIMIT 10; -- Facilitar visualização

-- 5.2 - Mostre quantas Propriedades existem de cada classe (casa inteira, etc.)
SELECT tipo_propriedade, COUNT(*)
FROM Propriedade
WHERE tipo_propriedade IS NOT NULL
GROUP BY (tipo_propriedade);

-- 5.3 - Mostre quantas Propriedades existem de cada Cidade
SELECT cidade , COUNT(cidade)
FROM Propriedade NATURAL JOIN Localizacao
GROUP BY cidade;