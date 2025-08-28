const express = require('express');
const cors = require('cors');
const path = require('path');
const swaggerUi = require('swagger-ui-express');
const fs = require('fs');
require('dotenv').config();

const { pool } = require('./lib/db');
const usersRouter = require('./routes/users');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Healthcheck
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// Swagger setup
const swaggerPath = path.join(__dirname, 'swagger.json');
const swaggerDocument = JSON.parse(fs.readFileSync(swaggerPath, 'utf8'));
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

// Routes
app.use('/users', usersRouter);

// Server
const PORT = process.env.PORT || 3000;

app.listen(PORT, async () => {
  const apiUrl = `http://localhost:${PORT}`;
  const swaggerUrl = `${apiUrl}/api-docs`;
  console.log(`[api] Listening on ${apiUrl}`);
  console.log(`[api] Swagger UI available at ${swaggerUrl}`);

  // Try a simple DB ping
  try {
    const { rows } = await pool.query('SELECT NOW() AS now');
    console.log(`[db] Connected. Server time: ${rows[0].now}`);
  } catch (err) {
    console.error('[db] Connection failed:', err.message);
  }
});


