const express = require('express');
const { pool } = require('../lib/db');

const router = express.Router();

// GET /enseignants - récupérer toutes les enseignants
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT id, nom, prenom, email, telephone, identifiant, mdp FROM enseignant ORDER BY id ASC');
    res.json(result.rows);
  } catch (err) {
    console.error('GET /enseignants erreur :', err);
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

module.exports = router;