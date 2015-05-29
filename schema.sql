DROP TABLE IF EXISTS beers, reviews, breweries;

CREATE TABLE breweries (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE beers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  description VARCHAR(255) NOT NULL,
  brewery_id INTEGER NOT NULL REFERENCES breweries(id)
);

CREATE TABLE reviews (
  id SERIAL PRIMARY KEY,
  body VARCHAR(255),
  beer_id INTEGER NOT NULL REFERENCES beers(id)
);

