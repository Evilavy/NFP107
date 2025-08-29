# Système de Rôles - API

## Vue d'ensemble

L'application utilise un système de rôles basé sur JWT pour contrôler l'accès aux différentes fonctionnalités. Trois rôles sont disponibles :

- **etudiant** : Accès aux fonctionnalités étudiantes
- **professeur** : Accès aux fonctionnalités d'enseignement
- **secretaire** : Accès aux fonctionnalités administratives

## Authentification

### Connexion (Login)

```http
POST /Personne/login
Content-Type: application/json

{
  "identifiant": "adupont",
  "password": "password"
}
```

**Réponse :**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "identifiant": "adupont",
    "nom": "Dupont",
    "prenom": "Alice",
    "email": "adupont@univ.fr",
    "adresse": "10 rue A",
    "telephone": "0610000001",
    "role": "etudiant"
  }
}
```

Le token JWT contient maintenant le rôle de l'utilisateur.

## Middlewares de Rôles

### `requireRole(role)`
Vérifie que l'utilisateur a le rôle spécifié.

### `requireAnyRole(roles)`
Vérifie que l'utilisateur a l'un des rôles spécifiés dans le tableau.

## Routes d'Exemple

### Routes spécifiques par rôle

```http
# Route accessible uniquement aux étudiants
GET /Personne/etudiant-only
Authorization: Bearer <token>

# Route accessible uniquement aux professeurs
GET /Personne/professeur-only
Authorization: Bearer <token>

# Route accessible uniquement aux secrétaires
GET /Personne/secretaire-only
Authorization: Bearer <token>
```

### Routes multi-rôles

```http
# Route accessible aux professeurs ET secrétaires
GET /Personne/admin
Authorization: Bearer <token>
```

### Informations de rôle

```http
# Obtenir les informations de rôle de l'utilisateur connecté
GET /Personne/my-role
Authorization: Bearer <token>
```

## Utilisation dans vos Routes

### Exemple 1 : Route pour étudiants uniquement
```javascript
router.get('/mes-notes', authenticateBearer, requireRole('etudiant'), async (req, res) => {
  // Logique pour récupérer les notes de l'étudiant
});
```

### Exemple 2 : Route pour professeurs uniquement
```javascript
router.post('/ajouter-note', authenticateBearer, requireRole('professeur'), async (req, res) => {
  // Logique pour ajouter une note
});
```

### Exemple 3 : Route pour administrateurs (professeurs + secrétaires)
```javascript
router.get('/liste-etudiants', authenticateBearer, requireAnyRole(['professeur', 'secretaire']), async (req, res) => {
  // Logique pour lister les étudiants
});
```

## Gestion des Erreurs

### Token manquant ou invalide
```json
{
  "erreur": "Token manquant ou invalide"
}
```

### Accès refusé (mauvais rôle)
```json
{
  "erreur": "Accès refusé. Rôle requis: professeur, Rôle actuel: etudiant"
}
```

## Utilisateurs de Test

### Étudiants
- `adupont` / `password` (L3 Info)
- `bnguyen` / `password` (L3 Info)
- `fthomas` / `password` (M1 Info)

### Professeurs
- `mdupont` / `password`
- `jmartin` / `password`
- `pbernard` / `password`

### Secrétaires
- `sdupond` / `password`

## Structure du Token JWT

Le token contient les informations suivantes :
```json
{
  "identifiant": "adupont",
  "email": "adupont@univ.fr",
  "nom": "Dupont",
  "prenom": "Alice",
  "role": "etudiant",
  "iat": 1234567890,
  "exp": 1234574490
}
```
