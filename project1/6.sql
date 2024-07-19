--Questão 6.1
SELECT id_locacao, nome_prop, endereco_prop
    FROM Locacao 
    WHERE data_checkIn >= '2024-04-01' AND condicao = 'confirmado'

--Questão 6.2
SELECT nome_prop AS "Propriedade", data_checkOut - data_checkIn AS "Total dias"
    FROM Locacao 
    WHERE data_checkIn >= '2024-04-01' AND condicao = 'confirmado'

--Questão 6.3
SELECT L.nome_prop AS "Propriedade", L.nome_hosp AS "Locatário", P.nome_anf AS "Anfitrião"
    FROM Locacao L JOIN Propriedade P ON 
    (L.nome_prop = P.nome AND
    L.endereco_prop = P.endereco)
    WHERE L.data_checkIn >= '2024-04-01' AND L.condicao = 'confirmado'

--Questão 6.4
SELECT L.nome_prop AS "Propriedade", P.preco_noite
    FROM Locacao L JOIN Propriedade P ON 
    (L.nome_prop = P.nome AND
    L.endereco_prop = P.endereco)
    WHERE L.data_checkIn >= '2024-04-01' AND L.condicao = 'confirmado'