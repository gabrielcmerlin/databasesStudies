SELECT A.nome, A.sobrenome, A.num_tel
    FROM Locatario L JOIN
        (Localizacao LO JOIN Anfitriao A ON 
        LO.id_local = A.id_local) ON
        LO.id_local = L.id_local
    WHERE (A.nome = L.nome AND
           A.sobrenome = L.sobrenome AND
           A.num_tel = L.num_tel)