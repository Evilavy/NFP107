const express = require('express');
const { pool } = require('../lib/db');

const router = express.Router();

// GET /Promo - récupérer toutes les promos
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT nom, annee_universitaire FROM Promo ORDER BY Id_Promo ASC');
    res.json(result.rows);
  } catch (err) {
    console.error('GET /Promo erreur :', err);
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// POST /Promo - créer une promo { nom, annee_universitaire }
router.post('/', async (req, res) => {
  const { nom, annee_universitaire } = req.body;
  if (!nom || !annee_universitaire) {
    return res.status(400).json({ erreur: 'nom et annee_universitaire sont obligatoires' });
  }
  try {
    const insertQuery = `
      INSERT INTO Utilisateur (nom, annee_universitaire)
      VALUES ($1, $2)
      RETURNING nom, annee_universitaire
    `;
    const values = [nom, annee_universitaire];
    const result = await pool.query(insertQuery, values);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('POST /Promo erreur :', err);
    if (err.code === '23505') { // violation de contrainte unique
      return res.status(409).json({ erreur: 'Id_Promo déjà existant' });
    }
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// DELETE /Promo - supprimer une promo par Id_Promo (body)
router.delete('/', async (req, res) => {
  const { Id_Promo } = req.body;
  if (!Id_Promo) {
    return res.status(400).json({ erreur: "Id_Promo est obligatoire" });
  }
  try {
    const deleteQuery = `
      DELETE FROM Promo
      WHERE Id_Promo = $1
    `;
    const values = [Id_Promo];
    const result = await pool.query(deleteQuery, values);
    if (result.rowCount === 0) {
      return res.status(404).json({ erreur: 'Promo introuvable' });
    }
    return res.status(204).send();
  } catch (err) {
    console.error('DELETE /Promo erreur :', err);
    return res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// DELETE /Promo/:Id_Promo - supprimer une promo par Id_Promo
router.delete('/:Id_Promo', async (req, res) => {
  const { Id_Promo } = req.params;
  if (!Id_Promo) {
    return res.status(400).json({ erreur: "Id_Promo est obligatoire" });
  }
  try {
    const deleteByIdQuery = `
      DELETE FROM Promo
      WHERE Id_Promo = $1
    `;
    const result = await pool.query(deleteByIdQuery, [Id_Promo]);
    if (result.rowCount === 0) {
      return res.status(404).json({ erreur: 'Promo introuvable' });
    }
    return res.status(204).send();
  } catch (err) {
    console.error('DELETE /Promo/:Id_Promo erreur :', err);
    return res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

module.exports = router;


