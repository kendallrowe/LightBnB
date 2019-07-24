const properties = require('./json/properties.json');
const users = require('./json/users.json');

const { Pool } = require('pg');

const pool = new Pool({
  user: 'vagrant',
  host: 'localhost',
  database: 'lightbnb',
  password: ''
});

/// Users

/**
 * Get a single user from the database given their email.
 * @param {String} email The email of the user.
 * @return {Promise<{}>} A promise to the user.
 */

const getUserWithEmail = function(email) {
  return pool.query(`
    SELECT id, name, email, password
    FROM users
    WHERE email = $1;
  `, [email])
  .then(res => {
    if (res.rows) {
      return res.rows[0];
    }
    return null;
  })
  .catch(err => {
    console.error('query error', err.stack);
    return false;
  });
}
exports.getUserWithEmail = getUserWithEmail;

/**
 * Get a single user from the database given their id.
 * @param {string} id The id of the user.
 * @return {Promise<{}>} A promise to the user.
 */
const getUserWithId = function(id) {
  return pool.query(`
    SELECT id, name, email, password
    FROM users
    WHERE id = $1;
  `, [id])
  .then(res => {
    if (res.rows) {
      return res.rows[0];
    }
    return null;
  })
  .catch(err => {
    console.error('query error', err.stack);
    return false;
  });
}
exports.getUserWithId = getUserWithId;


/**
 * Add a new user to the database.
 * @param {{name: string, password: string, email: string}} user
 * @return {Promise<{}>} A promise to the user.
 */

const addUser =  function(user) {
  return pool.query(`
    INSERT INTO users (name, email, password) 
    VALUES ($1, $2, $3) RETURNING *;
  `, [user.name, user.email, user.password])
  .then((results) => {
    return results.rows})
  .catch(err => {
    console.error('query error', err.stack);
    return false;
  });
}
exports.addUser = addUser;

/// Reservations

/**
 * Get all reservations for a single user.
 * @param {string} guest_id The id of the user.
 * @return {Promise<[{}]>} A promise to the reservations.
 */
// SELECT properties.*, reservations.*, avg(rating) as average_rating
// FROM reservations
// JOIN properties ON reservations.property_id = properties.id
// JOIN property_reviews ON properties.id = property_reviews.property_id 
// WHERE reservations.guest_id = 1
// AND reservations.end_date < now()::date
// GROUP BY properties.id, reservations.id
// ORDER BY reservations.start_date
// LIMIT 10;

const getAllReservations = function(guest_id, limit = 10) {
  return pool.query(`
    SELECT properties.*, reservations.*, avg(rating) as average_rating
    FROM reservations
    JOIN properties ON reservations.property_id = properties.id
    JOIN property_reviews ON properties.id = property_reviews.property_id 
    WHERE reservations.guest_id = $1
    AND reservations.end_date < now()::date
    GROUP BY properties.id, reservations.id
    ORDER BY reservations.start_date
    LIMIT $2;
  `, [guest_id, limit])
  .then(res => res.rows)
  .catch(err => {
    console.error('query error', err.stack);
    return false;
  });;
}
exports.getAllReservations = getAllReservations;

/// Properties

/**
 * Get all properties.
 * @param {{}} options An object containing query options.
 * @param {*} limit The number of results to return.
 * @return {Promise<[{}]>}  A promise to the properties.
 */

const getAllProperties = function(options, limit) {
  const queryParams = [];
  let whereAnd = "WHERE";
  let minimumHaving = ``;
  limit = 10;

  let queryString = `
  SELECT properties.*, avg(property_reviews.rating) as average_rating
  FROM properties
  JOIN property_reviews ON properties.id = property_id
  `;

  if (options.city) {
    queryParams.push(`%${options.city}%`);
    queryString += `${whereAnd} city LIKE $${queryParams.length} `;
  }

  if (queryParams.length >= 1) {
    whereAnd = "AND";
  }

  if (options.owner_id) {
    queryParams.push(`${options.owner_id}`);
    queryString += `${whereAnd} owner_id = $${queryParams.length} `;
  }

  if (queryParams.length >= 1) {
    whereAnd = "AND";
  }

  if (options.minimum_price_per_night) {
    queryParams.push(`${options.minimum_price_per_night}`);
    queryString += `${whereAnd} cost_per_night >= $${queryParams.length} `;
  }

  if (queryParams.length >= 1) {
    whereAnd = "AND";
  }

  if (options.maximum_price_per_night) {
    queryParams.push(`${options.maximum_price_per_night}`);
    queryString += `${whereAnd} cost_per_night <= $${queryParams.length} `;
  }
  if (options.minimum_rating) {
    queryParams.push(`${options.minimum_rating}`);
    minimumHaving = `
    HAVING AVG(property_reviews.rating) >= $${queryParams.length} 
    `;
  }

  queryParams.push(limit);
  queryString += `
  GROUP BY properties.id
  ${minimumHaving}
  ORDER BY cost_per_night
  LIMIT $${queryParams.length};
  `;
  console.log(queryString);
  return pool.query(queryString, queryParams)
  .then(res => {
    return res.rows
  })
  .catch(err => {
    console.error('query error', err.stack);
    return false;
  });
}
exports.getAllProperties = getAllProperties;


/**
 * Add a property to the database
 * @param {{}} property An object containing all of the property details.
 * @return {Promise<{}>} A promise to the property.
 */
const addProperty = function(property) {
  const propertyId = Object.keys(properties).length + 1;
  property.id = propertyId;
  properties[propertyId] = property;
  return Promise.resolve(property);
}
exports.addProperty = addProperty;
