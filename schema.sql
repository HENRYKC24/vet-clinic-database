/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50),
    data_of_birth DATE,
    escape_attempts INTEGER,
    neutered BOOLEAN DEFAULT false,
    weight_kg DECIMAL
);

/*Add 'species' column to the animals table */
ALTER TABLE animals
ADD species VARCHAR(50);


CREATE TABLE owners(
 id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 full_name VARCHAR(50),
 age INT
);

CREATE TABLE species(
 id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 name VARCHAR(50)
);

ALTER TABLE animals DROP COLUMN species;

ALTER TABLE animals ADD species_id INT;
ALTER TABLE animals ADD CONSTRAINT fk_name FOREIGN KEY(species_id) REFERENCES species(id);
ALTER TABLE animals ADD owner_id INT;
ALTER TABLE animals ADD CONSTRAINT fk_name2 FOREIGN KEY(owner_id) REFERENCES owners(id);



/*FOURTH DAY*/

-- Create Vets Table
CREATE TABLE vets(
 id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 name VARCHAR(50),
 age INT,
 date_of_graduation DATE
);

-- Create Specializations Table
CREATE TABLE specializations (
 id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 vets_id INT,
 species_id INT,
 CONSTRAINT vet_fk FOREIGN KEY(vets_id) REFERENCES vets(id),
 CONSTRAINT species_fk FOREIGN KEY(species_id) REFERENCES species(id)
);

--  Create Visits Table
CREATE TABLE visits (
 id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 animals_id INT,
 vets_id INT,
 date_of_visit DATE,
 CONSTRAINT vet_fk FOREIGN KEY(vets_id) REFERENCES vets(id),
 CONSTRAINT animals_fk FOREIGN KEY(animals_id) REFERENCES animals(id) 
);

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

-- Find a way to decrease the execution time of the first query. Look for hints in the previous lessons.
EXPLAIN ANALYZE SELECT COUNT(*) FROM visits where animalS_id = 4;
CREATE INDEX visits_animals_id_asc ON visits(animals_id ASC);
\d visits
EXPLAIN ANALYZE SELECT COUNT(*) FROM visits where animalS_id = 4;

-- Decrease he execution time of the third query
EXPLAIN ANALYZE SELECT * FROM owners where email = 'owner_18327@mail.com';
CREATE INDEX owners_email_asc ON owners(email ASC);
\d owners;
EXPLAIN ANALYZE SELECT * FROM owners where email = 'owner_18327@mail.com';

