const express = require('express');
const cors = require('cors');
const path = require('path');
const swaggerUi = require('swagger-ui-express');
const fs = require('fs');
require('dotenv').config();

const { pool } = require('./lib/db');
const personneRouter = require('./routes/personne');
const ueRouter = require('./routes/ue');
const enseignantRouter = require('./routes/enseignant');
const utilisateurRouter = require('./routes/utilisateur');
const planningRouter = require('./routes/planning');
const promoRouter = require('./routes/promo');
const noteRouter = require('./routes/note');
const filiereRouter = require('./routes/filiere');

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
app.use('/Personne', personneRouter);
app.use('/UE', ueRouter);
app.use('/Enseignant', enseignantRouter);
app.use('/Utilisateur', utilisateurRouter);
app.use('/planning', planningRouter);
app.use('/Promo', promoRouter);
app.use('/Note', noteRouter);
app.use('/Filiere', filiereRouter);

// Server
const PORT = process.env.PORT || 3000;

app.listen(PORT, async () => {
  const apiUrl = `http://localhost:${PORT}`;
  const swaggerUrl = `${apiUrl}/api-docs`;
  console.log(`[api] Écoute sur ${apiUrl}`);
  console.log(`[api] Swagger UI disponible sur ${swaggerUrl}`);

  // Try a simple DB ping
  try {
    const { rows } = await pool.query('SELECT NOW() AS now');
    console.log(`[db] Connecté. Heure du serveur: ${rows[0].now}`);
  } catch (err) {
    console.error('[db] Échec de la connexion :', err.message);
  }
});


