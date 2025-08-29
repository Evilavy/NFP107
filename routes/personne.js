const express = require('express');
const { pool } = require('../lib/db');

const router = express.Router();

// GET /Personne - récupérer toutes les personnes
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT id, nom, prenom, email, telephone, identifiant, mdp, created_at FROM Personne ORDER BY id ASC');
    res.json(result.rows);
  } catch (err) {
    console.error('GET /Personne erreur :', err);
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// POST /Personne - créer une personne { nom, prenom, email, telephone, identifiant, mdp }
router.post('/', async (req, res) => {
  const { nom, prenom, email, telephone, identifiant, mdp } = req.body;
  if (!nom || !prenom || !email || !telephone || !identifiant || !mdp) {
    return res.status(400).json({ erreur: 'nom, prenom, email, telephone, identifiant et mdp sont obligatoires' });
  }
  try {
    const insertQuery = `
      INSERT INTO Personne (nom, prenom, email, telephone, identifiant, mdp)
      VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING id, nom, prenom, email, telephone, identifiant, mdp, created_at
    `;
    const values = [nom, prenom, email, telephone, identifiant, mdp];
    const result = await pool.query(insertQuery, values);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('POST /Personne erreur :', err);
    if (err.code === '23505') {
      return res.status(409).json({ erreur: 'email déjà existant' });
    }
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// DELETE /Personne - supprimer une personne par nom et email (optionnel)
router.delete('/', async (req, res) => {
  const { nom, email } = req.body;
  if (!nom || !email) {
    return res.status(400).json({ erreur: 'nom et email sont obligatoires' });
  }
  try {
    const deleteQuery = `
      DELETE FROM Personne
      WHERE nom = $1 AND email = $2
    `;
    const values = [nom, email];
    const result = await pool.query(deleteQuery, values);
    if (result.rowCount === 0) {
      return res.status(404).json({ erreur: 'Personne introuvable' });
    }
    return res.status(204).send();
  } catch (err) {
    console.error('DELETE /Personne erreur :', err);
    return res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// DELETE /Personne/:id - supprimer une personne par id
router.delete('/:id', async (req, res) => {
  const { id } = req.params;
  const userId = Number(id);
  if (!Number.isInteger(userId) || userId <= 0) {
    return res.status(400).json({ erreur: "l'id doit être un entier positif" });
  }
  try {
    const deleteByIdQuery = `
      DELETE FROM Personne
      WHERE id = $1
    `;
    const result = await pool.query(deleteByIdQuery, [userId]);
    if (result.rowCount === 0) {
      return res.status(404).json({ erreur: 'Personne introuvable' });
    }
    return res.status(204).send();
  } catch (err) {
    console.error('DELETE /Personne/:id erreur :', err);
    return res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

module.exports = router;


