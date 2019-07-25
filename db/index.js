const { Pool } = require('pg');

const pool = new Pool({
  user: 'vagrant',
  host: 'localhost',
  database: 'lightbnb',
  password: ''
});

module.exports = {
  query: (text, params, callback) => {
    return pool.query(text, params, callback)
  },
};