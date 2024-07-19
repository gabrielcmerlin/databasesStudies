-- Exercício 6:

/* Mostre o conteúdo feito para a relação que implementa o conceito de Propriedades
do sistema: */

-- a) Mostre a estrutura da relação, mostrando os atributos de 10 tuplas aleatoriamente;

SELECT *
FROM Propriedade
ORDER BY RANDOM()
LIMIT 10;

-- Usamos a função RANDOM() para selecionar 10 tuplas aleatoriamente.

-- b) Mostre quantas Propriedades existem de cada classe (casa inteira, etc.);

-- Sem NULLs
SELECT tipo, COUNT(*) AS quantidade
FROM Propriedade
GROUP BY tipo;

-- Com NULLs
SELECT tipo, COUNT(tipo) AS quantidade
FROM Propriedade
GROUP BY tipo
HAVING tipo IS NOT NULL;

-- Utilizamos a função GROUP BY() para contar a quantidade de cada tipo

-- c) Mostre quantas localizações existem na base (usando os dados obtidos a partir do atributo Listings.neighbourhood cleansed).

SELECT count(DISTINCT bairro) as quantidade_localizacoes
FROM Localizacao