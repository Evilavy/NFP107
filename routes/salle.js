const express = require('express');
const { pool } = require('../lib/db');

const router = express.Router();

// GET /Salle - récupérer toutes les salles
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT Id_Salle, code_salle FROM Salle ORDER BY Id_Salle ASC');
    res.json(result.rows);
  } catch (err) {
    console.error('GET /Salle erreur :', err);
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// POST /Salle - créer une salle { Id_Salle, code_salle }
router.post('/', async (req, res) => {
  const { Id_Salle, code_salle } = req.body;
  if (!Id_Salle || !code_salle) {
    return res.status(400).json({ erreur: 'Id_Salle et code_salle sont obligatoires' });
  }
  try {
    const insertQuery = `
      INSERT INTO Salle (Id_Salle, code_salle)
      VALUES ($1, $2)
      RETURNING Id_Salle, code_salle
    `;
    const values = [Id_Salle, code_salle];
    const result = await pool.query(insertQuery, values);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('POST /Salle erreur :', err);
    if (err.code === '23505') { // violation de contrainte unique
      return res.status(409).json({ erreur: 'Id_Salle déjà existant' });
    }
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// DELETE /Salle - supprimer une salle par Id_Salle (body)
router.delete('/', async (req, res) => {
  const { Id_Salle } = req.body;
  if (!Id_Salle) {
    return res.status(400).json({ erreur: "Id_Salle est obligatoire" });
  }
  try {
    const deleteQuery = `
      DELETE FROM Salle
      WHERE Id_Salle = $1
    `;
    const values = [Id_Salle];
    const result = await pool.query(deleteQuery, values);
    if (result.rowCount === 0) {
      return res.status(404).json({ erreur: 'Salle introuvable' });
    }
    return res.status(204).send();
  } catch (err) {
    console.error('DELETE /Salle erreur :', err);
    return res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// DELETE /Salle/:Id_Salle - supprimer une salle par Id_Salle
router.delete('/:Id_Salle', async (req, res) => {
  const { Id_Salle } = req.params;
  if (!Id_Salle) {
    return res.status(400).json({ erreur: "Id_Salle est obligatoire" });
  }
  try {
    const deleteByIdQuery = `
      DELETE FROM Salle
      WHERE Id_Salle = $1
    `;
    const result = await pool.query(deleteByIdQuery, [Id_Salle]);
    if (result.rowCount === 0) {
      return res.status(404).json({ erreur: 'Salle introuvable' });
    }
    return res.status(204).send();
  } catch (err) {
    console.error('DELETE /Salle/:Id_Salle erreur :', err);
    return res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

module.exports = router;  