WITH Anfitriao_withInfo as (
	SELECT A.nome, A.sobrenome, A.num_tel, Loc.cidade, count(*) as qtd_propriedade
	FROM Anfitriao A 
		JOIN Localizacao Loc USING (id_local)
		JOIN Propriedade P ON A.nome = P.nome_anf AND A.sobrenome = P.sobrenome_anf AND A.num_tel = P.num_tel_anf
	GROUP BY(A.nome, A.sobrenome, A.num_tel, Loc.cidade)
)

SELECT A.nome || ' ' || A.sobrenome as nome_completo, A.cidade, A.qtd_propriedade, count(*) as qtd_locacao
FROM Anfitriao_withInfo A 
	JOIN Propriedade P ON A.nome = P.nome_anf AND A.sobrenome = P.sobrenome_anf AND A.num_tel = P.num_tel_anf
	JOIN Locacao Loc   ON Loc.nome_prop = P.nome AND Loc.endereco_prop = P.endereco
GROUP BY (A.nome, A.sobrenome, A.num_tel, A.qtd_propriedade, A.cidade)
    HAVING count(*) >= 3