const express = require('express');
const { pool } = require('../lib/db');

const router = express.Router();

// GET /UE - récupérer toutes les UE
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT code, intitule, nombre_heure, nombre_etcs, identifiant FROM UE ORDER BY id ASC');
    res.json(result.rows);
  } catch (err) {
    console.error('GET /UE erreur :', err);
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// POST /UE - créer une UE { code, intitule, nombre_heure, nombre_etcs, identifiant }
router.post('/', async (req, res) => {
  const { code, intitule, nombre_heure, nombre_etcs, identifiant } = req.body;
  if (!code || !intitule || !nombre_heure || !nombre_etcs || !identifiant) {
    return res.status(400).json({ erreur: 'code, intitule, nombre_heure, nombre_etcs et identifiant sont obligatoires' });
  }
  try {
    const insertQuery = `
      INSERT INTO Utilisateur (code, intitule, nombre_heure, nombre_etcs, identifiant)
      VALUES ($1, $2, $3, $4, $5)
      RETURNING code, intitule, nombre_heure, nombre_etcs, identifiant
    `;
    const values = [code, intitule, nombre_heure, nombre_etcs, identifiant];
    const result = await pool.query(insertQuery, values);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('POST /UE erreur :', err);
    if (err.code === '23505') { // violation de contrainte unique
      return res.status(409).json({ erreur: 'code déjà existant' });
    }
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// DELETE /UE - supprimer une UE par code (body)
router.delete('/', async (req, res) => {
  const { code } = req.body;
  if (!code) {
    return res.status(400).json({ erreur: "code est obligatoire" });
  }
  try {
    const deleteQuery = `
      DELETE FROM UE
      WHERE code = $1
    `;
    const values = [code];
    const result = await pool.query(deleteQuery, values);
    if (result.rowCount === 0) {
      return res.status(404).json({ erreur: 'UE introuvable' });
    }
    return res.status(204).send();
  } catch (err) {
    console.error('DELETE /UE erreur :', err);
    return res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// DELETE /UE/:code - supprimer une UE par code
router.delete('/:code', async (req, res) => {
  const { UE } = req.params;
  if (!UE) {
    return res.status(400).json({ erreur: "UE est obligatoire" });
  }
  try {
    const deleteByIdQuery = `
      DELETE FROM UE
      WHERE code = $1
    `;
    const result = await pool.query(deleteByIdQuery, [code]);
    if (result.rowCount === 0) {
      return res.status(404).json({ erreur: 'UE introuvable' });
    }
    return res.status(204).send();
  } catch (err) {
    console.error('DELETE /UE/:identifiant erreur :', err);
    return res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

module.exports = router;
