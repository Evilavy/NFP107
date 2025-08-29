const express = require('express');
const { pool } = require('../lib/db');
const crypto = require('crypto');

const router = express.Router();

// GET /Filiere - récupérer toutes les filieres
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT nom_filiere FROM Filiere ORDER BY Id_filiere ASC');
    res.json(result.rows);
  } catch (err) {
    console.error('GET /Filiere erreur :', err);
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// POST /Filiere - créer une filière { nom_filiere }
router.post('/', async (req, res) => {
  const { nom_filiere } = req.body;
  if (!nom_filiere) {
    return res.status(400).json({ erreur: 'nom_filiere est obligatoire' });
  }
  try {
    const hashedPassword = crypto.createHash('sha512').update(password).digest('hex');
    const insertQuery = `
      INSERT INTO Filiere (nom_filiere)
      VALUES ($1)
      RETURNING nom_filiere
    `;
    const values = [nom_filiere];
    const result = await pool.query(insertQuery, values);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('POST /Filiere erreur :', err);
    if (err.code === '23505') { // violation de contrainte unique
      return res.status(409).json({ erreur: 'Id_filiere déjà existant' });
    }
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// DELETE /Filiere - supprimer une filière par Id_filiere (body)
router.delete('/', async (req, res) => {
  const { Id_filiere } = req.body;
  if (!Id_filiere) {
    return res.status(400).json({ erreur: "Id_filiere est obligatoire" });
  }
  try {
    const deleteQuery = `
      DELETE FROM Filiere
      WHERE Id_filiere = $1
    `;
    const values = [Id_filiere];
    const result = await pool.query(deleteQuery, values);
    if (result.rowCount === 0) {
      return res.status(404).json({ erreur: 'Filière introuvable' });
    }
    return res.status(204).send();
  } catch (err) {
    console.error('DELETE /Filiere erreur :', err);
    return res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// DELETE /Filiere/:Id_filiere - supprimer une filière par Id_filiere
router.delete('/:Id_filiere', async (req, res) => {
  const { Id_filiere } = req.params;
  if (!Id_filiere) {
    return res.status(400).json({ erreur: "Id_filiere est obligatoire" });
  }
  try {
    const deleteByIdQuery = `
      DELETE FROM Filiere
      WHERE Id_filiere = $1
    `;
    const result = await pool.query(deleteByIdQuery, [Id_filiere]);
    if (result.rowCount === 0) {
      return res.status(404).json({ erreur: 'Filière introuvable' });
    }
    return res.status(204).send();
  } catch (err) {
    console.error('DELETE /Filiere/:Id_filiere erreur :', err);
    return res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

module.exports = router;


