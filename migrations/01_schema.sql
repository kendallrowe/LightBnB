DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS reservations CASCADE;
DROP TABLE IF EXISTS properties CASCADE;
DROP TABLE IF EXISTS property_reviews CASCADE;
DROP TABLE IF EXISTS rates CASCADE;
DROP TABLE IF EXISTS guest_reviews CASCADE;

-- Users Table
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL
);

-- Properties Table
CREATE TABLE properties (
  id SERIAL PRIMARY KEY,
  owner_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description VARCHAR(90000) NOT NULL,
  thumbnail_photo_url VARCHAR(255) NOT NULL,
  cover_photo_url VARCHAR(255) NOT NULL,
  cost_per_night BIGINT NOT NULL,
  parking_spaces SMALLINT NOT NULL,
  number_of_bathrooms SMALLINT NOT NULL,
  number_of_bedrooms SMALLINT NOT NULL,
  country VARCHAR(255) NOT NULL,
  street VARCHAR(255) NOT NULL,
  city VARCHAR(255) NOT NULL,
  provence VARCHAR(255) NOT NULL,
  post_code VARCHAR(255) NOT NULL,
  active BOOLEAN DEFAULT TRUE
);

-- Reservations Table
CREATE TABLE reservations (
  id SERIAL PRIMARY KEY,
  property_id INTEGER NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  guest_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  start_date TIMESTAMP NOT NULL DEFAULT Now(),
  end_date TIMESTAMP NOT NULL DEFAULT Now()
);

-- Property Reviews Table
CREATE TABLE property_reviews (
  id SERIAL PRIMARY KEY,
  guest_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  reservation_id INTEGER NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
  property_id INTEGER NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  rating SMALLINT NOT NULL,
  message VARCHAR(500) NOT NULL
);

-- Rates Table
CREATE TABLE rates (
  id SERIAL PRIMARY KEY,
  start_id TIMESTAMP NOT NULL DEFAULT Now(),
  end_date TIMESTAMP NOT NULL DEFAULT Now(),
  cost_per_night BIGINT NOT NULL,
  property_id INTEGER NOT NULL REFERENCES properties(id) ON DELETE CASCADE
);

-- Guest Reviews Table
CREATE TABLE guest_reviews (
  id SERIAL PRIMARY KEY,
  guest_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  owner_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  reservation_id INTEGER NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
  rating SMALLINT NOT NULL,
  message VARCHAR(500) NOT NULL
);