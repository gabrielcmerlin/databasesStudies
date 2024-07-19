-- Criando as tabelas fornecidas pelo Airbnb.
DROP TABLE IF EXISTS Listings CASCADE;
CREATE TABLE Listings (
    id BIGINT PRIMARY KEY,
    name TEXT,
    host_id SERIAL,
    host_name VARCHAR(50),
    neighbourhood_group VARCHAR(50),
    neighbourhood VARCHAR(50),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    room_type VARCHAR(50),
    price INTEGER,
    minimum_nights INTEGER,
    number_of_reviews INTEGER,
    last_review DATE,
    reviews_per_month DOUBLE PRECISION,
    calculated_host_listings_count SMALLINT,
    availability_365 INTEGER,
    number_of_reviews_ltm SMALLINT,
    license VARCHAR(50)
);

DROP TABLE IF EXISTS Calendar CASCADE;
CREATE TABLE Calendar (
    listing_id BIGINT,
    date DATE,
    available BOOLEAN,
    price TEXT,
    adjusted_price DOUBLE PRECISION,
    minimum_nights SMALLINT,
    maximum_nights SMALLINT,
    PRIMARY KEY (listing_id, date),
    FOREIGN KEY (listing_id) REFERENCES Listings
);

DROP TABLE IF EXISTS Reviews CASCADE;
CREATE TABLE Reviews (
    listing_id BIGINT,
    id BIGINT PRIMARY KEY,
    date DATE,
    reviewer_id SERIAL,
    reviewer_name VARCHAR(50),
    comments TEXT,
    FOREIGN KEY (listing_id) REFERENCES Listings
);

-- Copiando as informações dos CSVs obtidos para as tabelas recém criadas, sendo
-- que esses arquivos estão dentro da pasta de dados do Postgres.
COPY Listings FROM 'listings.csv' WITH (FORMAT CSV, HEADER);
COPY Calendar FROM 'calendar.csv' WITH (FORMAT CSV, HEADER);
COPY Reviews FROM 'reviews.csv' WITH (FORMAT CSV, HEADER);