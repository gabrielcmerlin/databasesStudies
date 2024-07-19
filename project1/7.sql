--Questão 7
SELECT EXTRACT(MONTH from L.data_reserva) AS "mês", AVG(P.preco_noite::numeric)::numeric(10,2) AS "média"
    FROM Locacao L JOIN Propriedade P ON 
    (L.nome_prop = P.nome AND
    L.endereco_prop = P.endereco)
    GROUP BY EXTRACT(MONTH from L.data_reserva)
        HAVING Count(*) > 0