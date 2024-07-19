-- 10.1 - Os locatários que são mais jovens do que algum anfitrião
SELECT L.nome, L.sobrenome, EXTRACT(YEAR from NOW()) - EXTRACT(YEAR from L.data_nasc) AS "idade"
        FROM Locatario L
        WHERE 
            EXTRACT(YEAR from NOW()) - EXTRACT(YEAR from L.data_nasc) < ANY
                (
                    SELECT EXTRACT(YEAR from NOW()) - EXTRACT(YEAR from A.data_nasc)
                    FROM Anfitriao A
                );

-- 10.2 - Os locatários que são mais jovens do que todos os anfitriões
SELECT L.nome, L.sobrenome, EXTRACT(YEAR from NOW()) - EXTRACT(YEAR from L.data_nasc) AS "idade"
       FROM Locatario L
       WHERE EXTRACT(YEAR from NOW()) - EXTRACT(YEAR from L.data_nasc) < 
            (
                SELECT MIN(EXTRACT(YEAR from NOW()) - EXTRACT(YEAR from A.data_nasc))
                FROM Anfitriao A
            );