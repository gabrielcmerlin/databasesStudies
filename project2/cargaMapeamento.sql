-- 1) Criação das tabelas mapeadas

DROP TABLE IF EXISTS Localizacao CASCADE;
CREATE TABLE Localizacao (
    id_local SERIAL PRIMARY KEY,
    pais VARCHAR(50),
    estado VARCHAR(50),
    cidade VARCHAR(50),
    bairro VARCHAR(50)
);

-- Aqui em usuário, precisamos mudar a chave de nome, sobrenome e num_tel
-- para apenas user_id. Os dados do Airbnb não possilitavam que a gente
-- utilizasse a nossa chave antiga, mas por sorte ele tinha o id do usuário
-- que serviria como chave.
DROP TABLE IF EXISTS Usuario CASCADE;
CREATE TABLE Usuario (
    user_id BIGINT PRIMARY KEY,
    nome VARCHAR(50),
    sobrenome VARCHAR(50),
    num_tel VARCHAR(15),
    data_nasc DATE,
    endereco TEXT,
    sexo CHAR(1),
    email VARCHAR(100),
    senha VARCHAR(255),
    eh_locatario BOOLEAN,
    eh_anfitriao BOOLEAN,
    id_local INT,
    FOREIGN KEY (id_local) REFERENCES Localizacao(id_local)
);

-- Originalmente, a chave de Propriedade era nome e endereço, mas, seguindo as 
-- tabelas do Airbnb, não é possível utilizar esses campos como chave, por falta 
-- de equivalência. Entretanto, nas tabelas do Airbnb, há o campo de id da 
-- propriedade. Assim, criamos o atributo prop_id. Além disso, a chave 
-- estrangeira referente a usuário foi alterada, de acordo com o que foi 
-- explicado anteriormente.
DROP TABLE IF EXISTS Propriedade CASCADE;
CREATE TABLE Propriedade (
    prop_id BIGINT PRIMARY KEY,
    nome TEXT,
    endereco TEXT,
    tipo VARCHAR(50),
    qtd_quartos TEXT,
    qtd_banheiros TEXT,
    max_hospedes INT,
    min_noites INT,
    max_noites INT,
    preco_noite DECIMAL(10, 2),
    taxa_limpeza DECIMAL(10, 2),
    data_inicio DATE,
    data_fim DATE,
    horario_checkIn TIME,
    horario_checkOut TIME,
    user_id BIGINT,
    id_local INT,
    FOREIGN KEY (id_local) REFERENCES Localizacao(id_local),
    FOREIGN KEY (user_id) REFERENCES Usuario(user_id)
);

-- Aqui, como mudamos a chave de propriedade, precisamos mudar o foreign key.
DROP TABLE IF EXISTS Quarto CASCADE;
CREATE TABLE Quarto (
    id_quarto SERIAL PRIMARY KEY,
    prop_id BIGINT,
    qtd_camas TEXT,
    tipo_cama VARCHAR(50),
    FOREIGN KEY (prop_id) REFERENCES Propriedade(prop_id)
);

-- Aqui, como mudamos a chave de usuário , precisamos mudar o foreign key. Além
-- disso, como os dados do Airbnb do trabalho não especifica qual o número da
-- conta dos usuários, foi necessário tirar o atributo 'num_conta' da chave.
DROP TABLE IF EXISTS Conta CASCADE;
CREATE TABLE Conta (
    num_conta VARCHAR(20),
    user_id BIGINT,
    num_roteamento VARCHAR(20),
    tipo_conta VARCHAR(50),
    PRIMARY KEY (user_id),
    FOREIGN KEY (user_id) REFERENCES Usuario(user_id)
);

-- Pelas orientações do trabalho, não é necessário popular a tabela de Locações.
-- Portanto, não faremos a criação dessa relação.
DROP TABLE IF EXISTS Locacao CASCADE;

-- Aqui, como mudamos a chave de usuário e de propriedade, precisamos mudar as 
-- foreign key. Além disso, como a Locacao nao tem mais informações, não haverá
-- mais  sobre uma foreign key para ela. Adiante, a nossa formulação para chave
-- primária dessa relação mostrou-se ineficaz quando usada no escopo dos dados
-- fornecidos pelo Airbnb, dessa forma tivemos que adaptar a chave para o
-- id_avaliacao, chave utilizada pela empresa de hospedagem.
DROP TABLE IF EXISTS Avaliacao CASCADE;
CREATE TABLE Avaliacao (
    id_avaliacao BIGINT PRIMARY KEY,
    tempo TIMESTAMPTZ,
    prop_id BIGINT,
    user_id BIGINT,
    data_checkIn DATE,
    fotos TEXT,
    rate_limpeza INT,
    rate_comunicacao INT,
    rate_localizacao INT,
    mensagem TEXT,
    FOREIGN KEY (user_id) REFERENCES Usuario(user_id),
    FOREIGN KEY (prop_id) REFERENCES Propriedade(prop_id)
);

-- Não há equivalências relevantes para a continuidade do uso dessa tabela criada
-- anteriormente pelo grupo, consequentemente não a usaremos.
DROP TABLE IF EXISTS Pts_Interesse CASCADE;

-- Aqui, como mudamos a chave de propriedade, precisamos mudar o foreign key.
DROP TABLE IF EXISTS Comodidades CASCADE;
CREATE TABLE Comodidades (
    comodidade VARCHAR(100),
    prop_id BIGINT,
    nomeProp TEXT,
    endereco VARCHAR(50),
    PRIMARY KEY (prop_id),
    FOREIGN KEY (prop_id) REFERENCES Propriedade(prop_id)
);

-- Aqui, como mudamos a chave de propriedade, precisamos mudar o foreign key.
DROP TABLE IF EXISTS Regras CASCADE;
CREATE TABLE Regras (
    regra TEXT,
    prop_id BIGINT,
    nomeProp TEXT,
    endereco VARCHAR(50),
    PRIMARY KEY (prop_id),
    FOREIGN KEY (prop_id) REFERENCES Propriedade(prop_id)
)

-- 2) Carga dos dados do Airbnb nessas tabelas

-- Inserção na tabela Usuario
INSERT INTO Usuario (user_id, nome, eh_locatario, eh_anfitriao)
SELECT 
    COALESCE(l.host_id, r.reviewer_id) AS user_id,
    COALESCE(l.host_name, r.reviewer_name) AS user_name,
    CASE WHEN l.host_id IS NOT NULL THEN true ELSE false END AS eh_locatario,
    CASE WHEN r.reviewer_id IS NOT NULL THEN true ELSE false END AS eh_anfitriao
FROM 
    (SELECT DISTINCT host_id, host_name FROM Listings) l 
FULL OUTER JOIN 
    (SELECT reviewer_id, reviewer_name 
     FROM (SELECT reviewer_id, reviewer_name, ROW_NUMBER() OVER(PARTITION BY reviewer_id ORDER BY ID ASC) rn 
           FROM Reviews) AS subquery 
     WHERE rn = 1) r 
ON l.host_id = r.reviewer_id;

INSERT INTO Localizacao (bairro, cidade, estado, pais)
SELECT DISTINCT neighbourhood, 'Rio de Janeiro' "Cidade", 'Rio de Janeiro' "Estado", 'Brasil' "País"
    FROM Listings;

INSERT INTO Propriedade (prop_id, nome, endereco, qtd_quartos, qtd_banheiros, tipo, min_noites, max_noites, preco_noite, data_inicio, data_fim, user_id)
SELECT id, name, neighbourhood, name, name, room_type, minimum_nights, maximum_nights, price, C.minDate, C.maxDate, host_id
    FROM Listings L JOIN (
        SELECT listing_id,
                COALESCE(AVG(maximum_nights), NULL) AS maximum_nights,
                COALESCE(MIN(date), NULL) AS minDate,
                COALESCE(MAX(date), NULL) AS maxDate
            FROM Calendar
            GROUP BY listing_id
    ) C ON (L.id = C.listing_id);

INSERT INTO Quarto (prop_id, qtd_camas)
SELECT id, name
    FROM Listings;

INSERT INTO Conta(user_id)
SELECT DISTINCT host_id
    FROM Listings;

INSERT INTO Avaliacao(id_avaliacao, tempo, user_id, prop_id, mensagem)
SELECT id, date, reviewer_id, listing_id, comments
    FROM Reviews;

INSERT INTO Comodidades(prop_id, nomeProp, endereco)
SELECT id, name, neighbourhood
    FROM Listings;

INSERT INTO Regras(prop_id, nomeProp, endereco)
SELECT id, name, neighbourhood
    FROM Listings;