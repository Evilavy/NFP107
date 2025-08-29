const express = require('express');
const { pool } = require('../lib/db');

const router = express.Router();

// GET /CorrespondanceFiliereUE - récupérer toutes les correspondances Filiere-UE
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT Id_Filiere, code FROM Correspond ORDER BY Id_Filiere ASC');
    res.json(result.rows);
  } catch (err) {
    console.error('GET /CorrespondanceFiliereUE erreur :', err);
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// POST /CorrespondanceFiliereUE - créer une correspondace Filiere-UE { Id_Filiere, code }
router.post('/', async (req, res) => {
  const { Id_Filiere, code } = req.body;
  if (!Id_Filiere || !code) {
    return res.status(400).json({ erreur: 'Id_Filiere et code sont obligatoires' });
  }
  try {
    const insertQuery = `
      INSERT INTO Correspond (Id_Filiere, code)
      VALUES ($1, $2)
      RETURNING Id_Filiere, code
    `;
    const values = [Id_Filiere, code];
    const result = await pool.query(insertQuery, values);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('POST /CorrespondanceFiliereUE erreur :', err);
    if (err.code === '23505') { // violation de contrainte unique
      return res.status(409).json({ erreur: 'Id_Filiere ou code déjà existant' });
    }
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// DELETE /CorrespondanceFiliereUE - supprimer une correspondance par les 2 identifiants (body)
router.delete('/', async (req, res) => {
  const { Id_Filiere, code } = req.body;
  if (!Id_Filiere || !code) {
    return res.status(400).json({ erreur: "Id_Filiere et code sont obligatoires" });
  }
  try {
    const deleteQuery = `
      DELETE FROM Correspond
      WHERE Id_Filiere = $1 
      AND code = $2
    `;
    const values = [Id_Filiere, code];
    const result = await pool.query(deleteQuery, values);
    if (result.rowCount === 0) {
      return res.status(404).json({ erreur: 'Correspondance Filière-UE introuvable' });
    }
    return res.status(204).send();
  } catch (err) {
    console.error('DELETE /CorrespondanceFiliereUE erreur :', err);
    return res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// DELETE /CorrespondanceFiliereUE/:Id_Filiere/:code - supprimer une correspondance par les 2 identifiants
router.delete('/:Id_Filiere/:code', async (req, res) => {
  const { Id_Filiere, code } = req.params;
  if (!Id_Filiere || !code) {
    return res.status(400).json({ erreur: "Id_Filiere et code sont obligatoires" });
  }
  try {
    const deleteByIdQuery = `
      DELETE FROM Correspond
      WHERE Id_Filiere = $1 
      AND code = $2
    `;
    const result = await pool.query(deleteByIdQuery, [Id_Filiere, code]);
    if (result.rowCount === 0) {
      return res.status(404).json({ erreur: 'Correspondance Filière-UE introuvable' });
    }
    return res.status(204).send();
  } catch (err) {
    console.error('DELETE /CorrespondanceFiliereUE/:Id_Filiere/:code erreur :', err);
    return res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

module.exports = router;  