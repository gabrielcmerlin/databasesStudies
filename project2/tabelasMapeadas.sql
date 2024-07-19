-- Criação das tabelas mapeadas pelo grupo a partir do texto-problema.

DROP TABLE IF EXISTS Usuario CASCADE;
CREATE TABLE Usuario (
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
    PRIMARY KEY (nome, sobrenome, num_tel),
    FOREIGN KEY (id_local) REFERENCES Localizacao(id_local)
);

DROP TABLE IF EXISTS Localizacao CASCADE;
CREATE TABLE Localizacao (
    id_local SERIAL PRIMARY KEY,
    pais VARCHAR(50),
    estado VARCHAR(50),
    cidade VARCHAR(50),
    bairro VARCHAR(50)
);

DROP TABLE IF EXISTS Propriedade CASCADE;
CREATE TABLE Propriedade (
    nome VARCHAR(100),
    endereco TEXT,
    tipo VARCHAR(50),
    qtd_quartos INT,
    qtd_banheiros INT,
    max_hospedes INT,
    min_noites INT,
    max_noites INT,
    preco_noite DECIMAL(10, 2),
    taxa_limpeza DECIMAL(10, 2),
    data_inicio DATE,
    data_fim DATE,
    horario_checkIn TIME,
    horario_checkOut TIME,
    nomeUsu VARCHAR(50),
    sobrenomeUsu VARCHAR(50),
    num_telUsu VARCHAR(15),
    id_local INT,
    PRIMARY KEY (nome, endereco),
    FOREIGN KEY (id_local) REFERENCES Localizacao(id_local),
    FOREIGN KEY (nomeUsu, sobrenomeUsu, num_telUsu) REFERENCES Usuario(nome, sobrenome, num_tel)
);

DROP TABLE IF EXISTS Quarto CASCADE;
CREATE TABLE Quarto (
    id_quarto SERIAL PRIMARY KEY,
    nomeProp VARCHAR(100),
    endProp TEXT,
    qtd_camas INT,
    tipo_cama VARCHAR(50),
    FOREIGN KEY (nomeProp, endProp) REFERENCES Propriedade(nome, endereco)
);

DROP TABLE IF EXISTS Conta CASCADE;
CREATE TABLE Conta (
    num_conta VARCHAR(20),
    nomeUsu VARCHAR(50),
    sobrenomeUsu VARCHAR(50),
    num_telUsu VARCHAR(15),
    num_roteamento VARCHAR(20),
    tipo_conta VARCHAR(50),
    PRIMARY KEY (num_conta, nomeUsu, sobrenomeUsu, num_telUsu),
    FOREIGN KEY (nomeUsu, sobrenomeUsu, num_telUsu) REFERENCES Usuario(nome, sobrenome, num_tel)
);

DROP TABLE IF EXISTS Locacao CASCADE;
CREATE TABLE Locacao (
    data_checkIn DATE,
    nomeUsu VARCHAR(50),
    sobrenomeUsu VARCHAR(50),
    num_telUsu VARCHAR(15),
    nomeProp VARCHAR(100),
    endProp TEXT,
    data_checkOut DATE,
    data_reserva DATE,
    qtd_hospedes INT,
    imposto DECIMAL(10, 2),
    preco_estadia DECIMAL(10, 2),
    cod_promocional VARCHAR(50),
    desconto DECIMAL(10, 2),
    preco_total DECIMAL(10, 2),
    condicao BOOLEAN,
    PRIMARY KEY (data_checkIn, nomeUsu, sobrenomeUsu, num_telUsu, nomeProp, endProp),
    FOREIGN KEY (nomeUsu, sobrenomeUsu, num_telUsu) REFERENCES Usuario(nome, sobrenome, num_tel),
    FOREIGN KEY (nomeProp, endProp) REFERENCES Propriedade(nome, endereco)
);

DROP TABLE IF EXISTS Avaliacao CASCADE;
CREATE TABLE Avaliacao (
    tempo TIMESTAMPTZ,
    nomeUsu VARCHAR(50),
    sobrenomeUsu VARCHAR(50),
    num_telUsu VARCHAR(15),
    nomeProp VARCHAR(100),
    endProp TEXT,
    data_checkIn DATE,
    fotos TEXT,
    rate_limpeza INT,
    rate_comunicacao INT,
    rate_localizacao INT,
    mensagem TEXT,
    PRIMARY KEY (tempo, nomeUsu, sobrenomeUsu, num_telUsu, nomeProp, endProp),
    FOREIGN KEY (nomeUsu, sobrenomeUsu, num_telUsu) REFERENCES Usuario(nome, sobrenome, num_tel),
    FOREIGN KEY (nomeProp, endProp) REFERENCES Propriedade(nome, endereco),
    FOREIGN KEY (data_checkIn, nomeUsu, sobrenomeUsu, num_telUsu, nomeProp, endProp) REFERENCES Locacao(data_checkIn, nomeUsu, sobrenomeUsu, num_telUsu, nomeProp, endProp)
);

DROP TABLE IF EXISTS Pts_Interesse CASCADE;
CREATE TABLE Pts_Interesse (
    ponto VARCHAR(100),
    id_local INT,
    PRIMARY KEY (ponto, id_local),
    FOREIGN KEY (id_local) REFERENCES Localizacao(id_local)
);

DROP TABLE IF EXISTS Comodidades CASCADE;
CREATE TABLE Comodidades (
    comodidade VARCHAR(100),
    nomeProp VARCHAR(100),
    endProp TEXT,
    PRIMARY KEY (comodidade, nomeProp, endProp),
    FOREIGN KEY (nomeProp, endProp) REFERENCES Propriedade(nome, endereco)
);

DROP TABLE IF EXISTS Regras CASCADE;
CREATE TABLE Regras (
    regra TEXT,
    nomeProp VARCHAR(100),
    endProp TEXT,
    PRIMARY KEY (regra, nomeProp, endProp),
    FOREIGN KEY (nomeProp, endProp) REFERENCES Propriedade(nome, endereco)
)