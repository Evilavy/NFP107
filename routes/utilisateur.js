const express = require('express');
const { pool } = require('../lib/db');
const crypto = require('crypto');
const { signUserToken, authenticateBearer, requireRole, requireAnyRole } = require('../lib/auth');

const router = express.Router();

// GET /Utilisateur - récupérer tous les utilisateurs
router.get('/', authenticateBearer, async (req, res) => {
  try {
    const { identifiant } = req.user || {};
    if (!identifiant) {
      return res.status(401).json({ erreur: 'Token invalide' });
    }
    const result = await pool.query('SELECT identifiant, nom, prenom, email, adresse, telephone FROM Utilisateur ORDER BY identifiant ASC');
    res.json(result.rows);
  } catch (err) {
    console.error('GET /Utilisateur erreur :', err);
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// POST /Utilisateur/create - créer un utilisateur { identifiant, nom, prenom, email, adresse, telephone, password }
router.post('/create', authenticateBearer, requireRole('secretaire'), async (req, res) => {
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
    console.error('POST /Utilisateur/create erreur :', err);
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
      SELECT u.identifiant, u.nom, u.prenom, u.email, u.adresse, u.telephone, r.nom as role
      FROM Utilisateur u
      JOIN Role r ON u.Id_Role = r.Id_Role
      WHERE u.identifiant = $1 AND u.password = $2
    `;
    const values = [identifiant, hashedPassword];
    const result = await pool.query(compareQuery, values);
    if (result.rowCount === 0) {
      return res.status(401).json({ erreur: 'Identifiants invalides' });
    }
    const user = result.rows[0];
    const token = signUserToken({ 
      identifiant: user.identifiant, 
      email: user.email, 
      nom: user.nom, 
      prenom: user.prenom,
      role: user.role 
    });
    return res.status(200).json({ token, user });
  } catch (err) {
    console.error('POST /Utilisateur/login erreur :', err);
    res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
})

// GET /Utilisateur/me - profil utilisateur authentifié
router.get('/me', authenticateBearer, async (req, res) => {
  const { identifiant } = req.user || {};
  if (!identifiant) {
    return res.status(401).json({ erreur: 'Token invalide' });
  }
  try {
    const query = `
      SELECT u.identifiant, u.nom, u.prenom, u.email, u.adresse, u.telephone, r.nom as role
      FROM Utilisateur u
      JOIN Role r ON u.Id_Role = r.Id_Role
      WHERE u.identifiant = $1
    `;
    const { rows, rowCount } = await pool.query(query, [identifiant]);
    if (rowCount === 0) {
      return res.status(404).json({ erreur: 'Utilisateur introuvable' });
    }
    return res.json(rows[0]);
  } catch (err) {
    console.error('GET /Utilisateur/me erreur :', err);
    return res.status(500).json({ erreur: 'Erreur interne du serveur' });
  }
});

// DELETE /Utilisateur - supprimer un utilisateur par identifiant (body)
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
      return res.status(404).json({ erreur: 'Utilisateur introuvable' });
    }
    return res.status(204).send();
  } catch (err) {
    console.error('DELETE /Utilisateur erreur :', err);
    return res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// DELETE /Utilisateur/:identifiant - supprimer un utilisateur par identifiant
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
      return res.status(404).json({ erreur: 'Utilisateur introuvable' });
    }
    return res.status(204).send();
  } catch (err) {
    console.error('DELETE /Utilisateur/:identifiant erreur :', err);
    return res.status(500).json({ erreur: "Erreur interne du serveur" });
  }
});

// ====== ROUTES AVEC VÉRIFICATION DE RÔLES ======

// Route accessible uniquement aux étudiants
router.get('/etudiant-only', authenticateBearer, requireRole('etudiant'), (req, res) => {
  res.json({ 
    message: 'Accès autorisé pour les étudiants',
    user: req.user 
  });
});

// Route accessible uniquement aux professeurs
router.get('/professeur-only', authenticateBearer, requireRole('professeur'), (req, res) => {
  res.json({ 
    message: 'Accès autorisé pour les professeurs',
    user: req.user 
  });
});

// Route accessible uniquement aux secrétaires
router.get('/secretaire-only', authenticateBearer, requireRole('secretaire'), (req, res) => {
  res.json({ 
    message: 'Accès autorisé pour les secrétaires',
    user: req.user 
  });
});

// Route accessible aux professeurs ET secrétaires
router.get('/admin', authenticateBearer, requireAnyRole(['professeur', 'secretaire']), (req, res) => {
  res.json({ 
    message: 'Accès autorisé pour les administrateurs (professeurs et secrétaires)',
    user: req.user 
  });
});

// Route pour obtenir les informations de rôle de l'utilisateur connecté
router.get('/my-role', authenticateBearer, (req, res) => {
  res.json({ 
    message: 'Informations de rôle',
    role: req.user.role,
    user: req.user 
  });
});

module.exports = router;  