-- Exercício 8:

SELECT U.user_id, U.nome,'Rio de Janeiro' AS cidade, count(*) AS qtt_propriedades
FROM Usuario U JOIN Propriedade P USING(user_id)
GROUP BY U.user_id, U.nome, U.sobrenome
HAVING count(*) >= 3
LIMIT 20

-- Índice na coluna user_id da tabela Propriedade
CREATE INDEX idx_propriedade_user_id ON Propriedade(user_id);
-- Índice composto nas colunas user_id, nome e sobrenome da tabela Usuario
CREATE INDEX idx_usuario_user_id_nome_sobrenome ON Usuario(user_id, nome, sobrenome);