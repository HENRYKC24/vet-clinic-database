/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50),
    data_of_birth DATE,
    escape_attempts INTEGER,
    neutered BOOLEAN DEFAULT false,
    weight_kg DECIMAL
);
