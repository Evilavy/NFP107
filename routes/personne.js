const express = require('express');
const { pool } = require('../lib/db');
const crypto = require('crypto');
const { signUserToken, authenticateBearer } = require('../lib/auth');

const router = express.Router();

// GET /Personne - récupérer toutes les personnes
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT identifiant, nom, prenom, email, adresse, telephone FROM Utilisateur ORDER BY identifiant ASC');
    res.json(result.rows);
  } catch (err) {
    console.error('GET /Personne erreur :', err);
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// POST /Personne - créer une personne { identifiant, nom, prenom, email, adresse, telephone, password }
router.post('/', async (req, res) => {
  const { identifiant, nom, prenom, email, adresse, telephone, password } = req.body;
  if (!identifiant || !nom || !prenom || !email || !adresse || !telephone || !password) {
    return res.status(400).json({ erreur: 'identifiant, nom, prenom, email, adresse, telephone et password sont obligatoires' });
  }
  try {
    const hashedPassword = crypto.createHash('sha512').update(password).digest('hex');
    const insertQuery = `
      INSERT INTO Utilisateur (identifiant, nom, prenom, email, adresse, telephone, password)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING identifiant, nom, prenom, email, adresse, telephone
    `;
    const values = [identifiant, nom, prenom, email, adresse, telephone, hashedPassword];
    const result = await pool.query(insertQuery, values);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('POST /Personne erreur :', err);
    if (err.code === '23505') { // violation de contrainte unique
      return res.status(409).json({ erreur: 'identifiant ou email déjà existant' });
    }
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

router.post('/login', async (req, res) => {
  const { identifiant, password } = req.body;
  if (!identifiant || !password) {
    return res.status(400).json({ erreur: 'identifiant, mdp sont obligatoires' });
  }
  try {
    const hashedPassword = crypto.createHash('sha512').update(password).digest('hex');
    const compareQuery = `
      SELECT identifiant, nom, prenom, email, adresse, telephone
      FROM Utilisateur
      WHERE identifiant = $1 AND password = $2
    `;
    const values = [identifiant, hashedPassword];
    const result = await pool.query(compareQuery, values);
    if (result.rowCount === 0) {
      return res.status(401).json({ erreur: 'Identifiants invalides' });
    }
    const user = result.rows[0];
    const token = signUserToken({ identifiant: user.identifiant, email: user.email, nom: user.nom, prenom: user.prenom });
    return res.status(200).json({ token, user });
  } catch (err) {
    console.error('POST /Personne/login erreur :', err);
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
})

// GET /Personne/me - profil utilisateur authentifié
router.get('/me', authenticateBearer, async (req, res) => {
  const { identifiant } = req.user || {};
  if (!identifiant) {
    return res.status(401).json({ erreur: 'Token invalide' });
  }
  try {
    const query = `
      SELECT identifiant, nom, prenom, email, adresse, telephone
      FROM Utilisateur
      WHERE identifiant = $1
    `;
    const { rows, rowCount } = await pool.query(query, [identifiant]);
    if (rowCount === 0) {
      return res.status(404).json({ erreur: 'Utilisateur introuvable' });
    }
    return res.json(rows[0]);
  } catch (err) {
    console.error('GET /Personne/me erreur :', err);
    return res.status(500).json({ erreur: 'Erreur interne du serveur' });
  }
});

// DELETE /Personne - supprimer une personne par identifiant (body)
router.delete('/', async (req, res) => {
  const { identifiant } = req.body;
  if (!identifiant) {
    return res.status(400).json({ erreur: "identifiant est obligatoire" });
  }
  try {
    const deleteQuery = `
      DELETE FROM Utilisateur
      WHERE identifiant = $1
    `;
    const values = [identifiant];
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

// DELETE /Personne/:identifiant - supprimer une personne par identifiant
router.delete('/:identifiant', async (req, res) => {
  const { identifiant } = req.params;
  if (!identifiant) {
    return res.status(400).json({ erreur: "identifiant est obligatoire" });
  }
  try {
    const deleteByIdQuery = `
      DELETE FROM Utilisateur
      WHERE identifiant = $1
    `;
    const result = await pool.query(deleteByIdQuery, [identifiant]);
    if (result.rowCount === 0) {
      return res.status(404).json({ erreur: 'Personne introuvable' });
    }
    return res.status(204).send();
  } catch (err) {
    console.error('DELETE /Personne/:identifiant erreur :', err);
    return res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

module.exports = router;  