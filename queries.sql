-- Queries that provide answers to the questions from all projects.

-- Find all animals whose name ends in "mon".
SELECT * FROM animals WHERE name LIKE '%mon';

-- List the name of all animals born between 2016 and 2019.
SELECT name FROM animals WHERE EXTRACT(year FROM date_of_birth) BETWEEN 2016 AND 2019;

-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;

-- List date of birth of all animals named either "Agumon" or "Pikachu".
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';

-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

-- Find all animals that are neutered.
SELECT * FROM animals WHERE neutered = true;

-- Find all animals not named Gabumon.
SELECT * FROM animals WHERE NOT name = 'Gabumon';

/* 
** Find all animals with a weight between 10.4kg and 17.3kg (including the 
** animals with the weights that equals precisely 10.4kg or 17.3kg)
*/
SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;

-- Start a transaction to set all species to 'unspecified' and roll it back afterwards
BEGIN;
UPDATE animals SET species='unspecified';
SELECT * FROM animals;
ROLLBACK;


-- Start a transaction and persist the data afterwards
BEGIN:
/*
Update the animals table by setting the species column
** to digimon for all animals that have a name ending in mon
*/
UPDATE animals SET species='pigimon' WHERE name LIKE '%mon';
/*
** Update the animals table by setting the species column
** to pokemon for all animals that don't have species already set.
*/
UPDATE animals SET species='pokemon' WHERE name NOT LIKE '%mon';
-- Commit the transaction.
COMMIT;
-- Verify that change was made and persists after commit.
SELECT * FROM animals;


-- Inside a transaction delete all records and roll it back.
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;


-- Begin a transaction.
BEGIN;
-- Delete all animals born after Jan 1st, 2022.
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
-- Create a savepoint for the transaction.
SAVEPOINT deleted_records_after_jan_01_2022;
-- Update all animals' weight to be their weight multiplied by -1.
UPDATE animals SET weight_kg = weight_kg * -1;
-- Rollback to the savepoint.
ROLLBACK TO deleted_records_after_jan_01_2022;
-- Update all animals' weights that are negative to be their weight multiplied by -1.
UPDATE animals 
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;
-- Commit transaction
COMMIT;


-- How many animals are there?
SELECT count(*) from animals;
-- How many animals have never tried to escape?
SELECT count(*) from animals WHERE escape_attempts = 0;
-- What is the average weight of animals?
SELECT SUM(weight_kg) / count(*) AS average_weight FROM animals;
-- Takes care of null weight if any

-- Who escapes the most, neutered or not neutered animals?
select neutered, sum from (
  select neutered, sum(escape_attempts) from animals
  group by neutered) as foo
  where sum = (
    select max(sum) from (
      select neutered, sum(escape_attempts) from animals
      group by neutered
  ) as bar
);
-- What is the minimum and maximum weight of each type of animal?
SELECT species, max(weight_kg), min(weight_kg) FROM animals GROUP BY species;
-- What is the average number of escape attempts per animal type of
-- those born between 1990 and 2000?
select species, avg(escape_attempts) from animals
where EXTRACT(year FROM date_of_birth) BETWEEN 1990 AND 2000 group by species;
