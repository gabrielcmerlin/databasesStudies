-- Exercício 7:

DROP VIEW IF EXISTS PropriedadesDisponíveis;
CREATE VIEW PropriedadesDisponíveis AS
	SELECT prop_id,	nome, endereco, date, preco_noite
	FROM Propriedade P JOIN calendar C ON (P.prop_id = C.listing_id)
	WHERE available = true and EXTRACT(Year from date) = 2024

SELECT prop_id,  nome, endereco, EXTRACT(Month from date) AS month, trunc(AVG(preco_noite),2) AS preco_medio
FROM PropriedadesDisponíveis
GROUP BY prop_id, nome, endereco, EXTRACT(Month from date)
LIMIT 24