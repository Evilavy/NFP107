const express = require('express');
const { pool } = require('../lib/db');

const router = express.Router();

// GET /Note - récupérer toutes les notes
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT Id_Note, note, identifiant, code FROM Note ORDER BY Id_Note ASC');
    res.json(result.rows);
  } catch (err) {
    console.error('GET /Note erreur :', err);
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// POST /Note - créer une note { note }
router.post('/', async (req, res) => {
  const { note, identifiant, code } = req.body;
  if (!note || !identifiant || !code) {
    return res.status(400).json({ erreur: 'note, identifiant et code sont obligatoires' });
  }
  try {
    const insertQuery = `
      INSERT INTO Note (note, identifiant, code)
      VALUES ($1, $2, $3)
      RETURNING note, identifiant, code
    `;
    const values = [note, identifiant, code];
    const result = await pool.query(insertQuery, values);
    res.status(201).json(result.rows[0]);

    // Quand une nouvelle note est disponible, l'étudiant concerné est notifié (via mail) 
    // Planifier une tâche pour le lendemain à 8h
    // const task = cron.schedule("0 8 * * *", () => {
    //   console.log("📧 email nouvelle note disponible à envoyer");

      // On arrête la tâche pour qu’elle ne s’exécute qu’une seule fois
      // task.stop();
    // });
  } catch (err) {
    console.error('POST /Note erreur :', err);
    if (err.code === '23505') { // violation de contrainte unique
      return res.status(409).json({ erreur: 'Id_Note déjà existant' });
    }
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// DELETE /Note - supprimer une note par Id_Note (body)
router.delete('/', async (req, res) => {
  const { Id_Note } = req.body;
  if (!Id_Note) {
    return res.status(400).json({ erreur: "Id_Note est obligatoire" });
  }
  try {
    const deleteQuery = `
      DELETE FROM Note
      WHERE Id_Note = $1
    `;
    const values = [Id_Note];
    const result = await pool.query(deleteQuery, values);
    if (result.rowCount === 0) {
      return res.status(404).json({ erreur: 'Note introuvable' });
    }
    return res.status(204).send();
  } catch (err) {
    console.error('DELETE /Note erreur :', err);
    return res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// DELETE /Note/:Id_Note - supprimer une note par Id_Note
router.delete('/:Id_Note', async (req, res) => {
  const { Id_Note } = req.params;
  if (!Id_Note) {
    return res.status(400).json({ erreur: "Id_Note est obligatoire" });
  }
  try {
    const deleteByIdQuery = `
      DELETE FROM Note
      WHERE Id_Note = $1
    `;
    const result = await pool.query(deleteByIdQuery, [Id_Note]);
    if (result.rowCount === 0) {
      return res.status(404).json({ erreur: 'Note introuvable' });
    }
    return res.status(204).send();
  } catch (err) {
    console.error('DELETE /Note/:Id_Note erreur :', err);
    return res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

module.exports = router;


