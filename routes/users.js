const express = require('express');
const { pool } = require('../lib/db');

const router = express.Router();

// GET /users - fetch all users
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT id, name, email, created_at FROM users ORDER BY id ASC');
    res.json(result.rows);
  } catch (err) {
    console.error('GET /users error:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// POST /users - create a user { name, email }
router.post('/', async (req, res) => {
  const { name, email } = req.body;
  if (!name || !email) {
    return res.status(400).json({ error: 'name and email are required' });
  }
  try {
    const insertQuery = `
      INSERT INTO users (name, email)
      VALUES ($1, $2)
      RETURNING id, name, email, created_at
    `;
    const values = [name, email];
    const result = await pool.query(insertQuery, values);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('POST /users error:', err);
    if (err.code === '23505') {
      return res.status(409).json({ error: 'email already exists' });
    }
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;


