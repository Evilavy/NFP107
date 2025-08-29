const express = require('express');
const { pool } = require('../lib/db');

const router = express.Router();

// GET /planning - récupérer tous les plannings
router.get('/', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT * FROM planning
    `);
    res.json(result.rows);
  } catch (err) {
    console.error('GET /planning erreur :', err);
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// GET /planning/:id - récupérer un planning par son ID
router.get('/:id', async (req, res) => {
  const { id } = req.params;
  if (!id || isNaN(parseInt(id))) {
    return res.status(400).json({ erreur: "ID du planning invalide" });
  }
  
  try {
    const result = await pool.query(`
      SELECT 
        p.Id_Planning,
        p.plage_horaire,
        p.date_,
        p.identifiant as prof_identifiant,
        u.nom as prof_nom,
        u.prenom as prof_prenom,
        p.Id_Promo,
        pr.nom as promo_nom,
        p.code as ue_code,
        ue.intitule as ue_intitule,
        p.Id_Salle,
        s.code_salle
      FROM Planning p
      LEFT JOIN Utilisateur u ON p.identifiant = u.identifiant
      LEFT JOIN Promo pr ON p.Id_Promo = pr.Id_Promo
      LEFT JOIN UE ue ON p.code = ue.code
      LEFT JOIN Salle s ON p.Id_Salle = s.Id_Salle
      WHERE p.Id_Planning = $1
    `, [parseInt(id)]);
    
    if (result.rowCount === 0) {
      return res.status(404).json({ erreur: 'Planning introuvable' });
    }
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error('GET /planning/:id erreur :', err);
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// POST /planning - créer un planning
router.post('/', async (req, res) => {
  const { plage_horaire, date_, identifiant, Id_Promo, code, Id_Salle } = req.body;
  
  if (!plage_horaire || !date_ || !identifiant || !Id_Promo || !code || !Id_Salle) {
    return res.status(400).json({ 
      erreur: 'plage_horaire, date_, identifiant, Id_Promo, code et Id_Salle sont obligatoires' 
    });
  }
  
  try {
    // Vérifier que le professeur existe
    const profCheck = await pool.query('SELECT identifiant FROM Professeur WHERE identifiant = $1', [identifiant]);
    if (profCheck.rowCount === 0) {
      return res.status(400).json({ erreur: 'Professeur introuvable' });
    }
    
    // Vérifier que la promo existe
    const promoCheck = await pool.query('SELECT Id_Promo FROM Promo WHERE Id_Promo = $1', [Id_Promo]);
    if (promoCheck.rowCount === 0) {
      return res.status(400).json({ erreur: 'Promo introuvable' });
    }
    
    // Vérifier que l'UE existe
    const ueCheck = await pool.query('SELECT code FROM UE WHERE code = $1', [code]);
    if (ueCheck.rowCount === 0) {
      return res.status(400).json({ erreur: 'UE introuvable' });
    }
    
    // Vérifier que la salle existe
    const salleCheck = await pool.query('SELECT Id_Salle FROM Salle WHERE Id_Salle = $1', [Id_Salle]);
    if (salleCheck.rowCount === 0) {
      return res.status(400).json({ erreur: 'Salle introuvable' });
    }
    
    // Vérifier qu'il n'y a pas de conflit de planning (même salle, même date, même plage horaire)
    const conflictCheck = await pool.query(`
      SELECT Id_Planning FROM Planning 
      WHERE Id_Salle = $1 AND date_ = $2 AND plage_horaire = $3
    `, [Id_Salle, date_, plage_horaire]);
    
    if (conflictCheck.rowCount > 0) {
      return res.status(409).json({ erreur: 'Conflit de planning : la salle est déjà occupée à cette date et heure' });
    }
    
    const insertQuery = `
      INSERT INTO Planning (plage_horaire, date_, identifiant, Id_Promo, code, Id_Salle)
      VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING Id_Planning, plage_horaire, date_, identifiant, Id_Promo, code, Id_Salle
    `;
    const values = [plage_horaire, date_, identifiant, Id_Promo, code, Id_Salle];
    const result = await pool.query(insertQuery, values);
    
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('POST /planning erreur :', err);
    if (err.code === '23503') { // violation de contrainte de clé étrangère
      return res.status(400).json({ erreur: 'Référence invalide (professeur, promo, UE ou salle)' });
    }
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// PUT /planning/:id - modifier un planning
router.put('/:id', async (req, res) => {
  const { id } = req.params;
  const { plage_horaire, date_, identifiant, Id_Promo, code, Id_Salle } = req.body;
  
  if (!id || isNaN(parseInt(id))) {
    return res.status(400).json({ erreur: "ID du planning invalide" });
  }
  
  if (!plage_horaire || !date_ || !identifiant || !Id_Promo || !code || !Id_Salle) {
    return res.status(400).json({ 
      erreur: 'plage_horaire, date_, identifiant, Id_Promo, code et Id_Salle sont obligatoires' 
    });
  }
  
  try {
    // Vérifier que le planning existe
    const planningCheck = await pool.query('SELECT Id_Planning FROM Planning WHERE Id_Planning = $1', [parseInt(id)]);
    if (planningCheck.rowCount === 0) {
      return res.status(404).json({ erreur: 'Planning introuvable' });
    }
    
    // Vérifier les références comme pour le POST
    const profCheck = await pool.query('SELECT identifiant FROM Professeur WHERE identifiant = $1', [identifiant]);
    if (profCheck.rowCount === 0) {
      return res.status(400).json({ erreur: 'Professeur introuvable' });
    }
    
    const promoCheck = await pool.query('SELECT Id_Promo FROM Promo WHERE Id_Promo = $1', [Id_Promo]);
    if (promoCheck.rowCount === 0) {
      return res.status(400).json({ erreur: 'Promo introuvable' });
    }
    
    const ueCheck = await pool.query('SELECT code FROM UE WHERE code = $1', [code]);
    if (ueCheck.rowCount === 0) {
      return res.status(400).json({ erreur: 'UE introuvable' });
    }
    
    const salleCheck = await pool.query('SELECT Id_Salle FROM Salle WHERE Id_Salle = $1', [Id_Salle]);
    if (salleCheck.rowCount === 0) {
      return res.status(400).json({ erreur: 'Salle introuvable' });
    }
    
    // Vérifier qu'il n'y a pas de conflit de planning (exclure le planning actuel)
    const conflictCheck = await pool.query(`
      SELECT Id_Planning FROM Planning 
      WHERE Id_Salle = $1 AND date_ = $2 AND plage_horaire = $3 AND Id_Planning != $4
    `, [Id_Salle, date_, plage_horaire, parseInt(id)]);
    
    if (conflictCheck.rowCount > 0) {
      return res.status(409).json({ erreur: 'Conflit de planning : la salle est déjà occupée à cette date et heure' });
    }
    
    const updateQuery = `
      UPDATE Planning 
      SET plage_horaire = $1, date_ = $2, identifiant = $3, Id_Promo = $4, code = $5, Id_Salle = $6
      WHERE Id_Planning = $7
      RETURNING Id_Planning, plage_horaire, date_, identifiant, Id_Promo, code, Id_Salle
    `;
    const values = [plage_horaire, date_, identifiant, Id_Promo, code, Id_Salle, parseInt(id)];
    const result = await pool.query(updateQuery, values);
    
    res.json(result.rows[0]);
  } catch (err) {
    console.error('PUT /planning/:id erreur :', err);
    if (err.code === '23503') {
      return res.status(400).json({ erreur: 'Référence invalide (professeur, promo, UE ou salle)' });
    }
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// DELETE /planning/:id - supprimer un planning par son ID
router.delete('/:id', async (req, res) => {
  const { id } = req.params;
  
  if (!id || isNaN(parseInt(id))) {
    return res.status(400).json({ erreur: "ID du planning invalide" });
  }
  
  try {
    const deleteQuery = 'DELETE FROM Planning WHERE Id_Planning = $1';
    const result = await pool.query(deleteQuery, [parseInt(id)]);
    
    if (result.rowCount === 0) {
      return res.status(404).json({ erreur: 'Planning introuvable' });
    }
    
    return res.status(204).send();
  } catch (err) {
    console.error('DELETE /planning/:id erreur :', err);
    return res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

module.exports = router;