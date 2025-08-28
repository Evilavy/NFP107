const { Pool } = require('pg');
require('dotenv').config();

const databaseHost = process.env.DB_HOST || 'localhost';
const databasePort = parseInt(process.env.DB_PORT || '5432', 10);
const databaseUser = process.env.DB_USER || 'postgres';
const databasePassword = process.env.DB_PASSWORD || 'postgres';
const databaseName = process.env.DB_NAME || 'postgres';

const pool = new Pool({
  host: databaseHost,
  port: databasePort,
  user: databaseUser,
  password: databasePassword,
  database: databaseName,
  max: 10,
  idleTimeoutMillis: 30000
});

pool.on('connect', () => {
  console.log(`[db] Pool created to ${databaseUser}@${databaseHost}:${databasePort}/${databaseName}`);
});

pool.on('error', (err) => {
  console.error('[db] Unexpected error on idle client', err);
});

module.exports = { pool };


