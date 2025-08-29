# NFP107 - Express + PostgreSQL API

API Node.js avec Express, PostgreSQL (pg) et Swagger UI.

## Prérequis
- Node.js >= 18 (pour un run local hors Docker)
- Docker + Docker Compose (recommandé)

## Démarrage rapide (Docker recommandé)
1. Builder et lancer les services:
```bash
docker compose up -d --build
```
2. Vérifier les logs de l'API (optionnel):
```bash
docker logs -f nfp107_api
```
3. Accéder à l'API et à la documentation:
- API: http://localhost:3000
- Swagger UI: http://localhost:3000/api-docs

Endpoints:
- GET http://localhost:3000/users
- POST http://localhost:3000/users
  - Body JSON: `{ "name": "Alice", "email": "alice@example.com" }`

Exemples cURL:
```bash
curl http://localhost:3000/users

curl -X POST http://localhost:3000/users \
  -H 'Content-Type: application/json' \
  -d '{"name":"Alice","email":"alice@example.com"}'
```

Les données PostgreSQL persistent dans le volume Docker `pgdata`.

## pgAdmin (administration PostgreSQL)
- URL: http://localhost:8080
- Connexion pgAdmin:
  - Email: `admin@example.com`
  - Mot de passe: `admin123`
- Serveur PostgreSQL préconfiguré dans pgAdmin: `NFP107 DB`
  - Host: `db`
  - Port: `5432`
  - Maintenance DB: `nfp_db`
  - Username: `nfp_user`
  - Password: `nfp_password`
  - Astuce: au premier clic sur le serveur dans pgAdmin, entrez/sauvegardez le mot de passe `nfp_password`.

## ⚡ Workflow quotidien avec Git
Ce guide explique comment mettre à jour ta branche de travail, coder, et envoyer tes modifications proprement.

### 1. Récupérer les dernières modifications (avant de bosser)
On se place sur la branche `develop` et on récupère les mises à jour du repo distant :
```bash
git checkout develop
git pull origin develop
```

### 2. Revenir sur ta branche et la mettre à jour
Ensuite, on revient sur sa branche de travail (exemple : `feature/enseignants`) et on la synchronise avec `develop` :
```bash
git checkout feature/enseignants
git merge develop   # ou: git rebase develop si vous êtes à l’aise
```

### 3. Coder, ajouter et commit
Après avoir fait tes changements, ajoute-les et crée un commit :
```bash
git add .
git commit -m "Ajout des routes enseignants"
```

### 4. Envoyer ton travail
Pousse ton travail sur ta branche distante :
```bash
git push origin feature/enseignants
```

### 5. Créer une Pull Request
Quand ta tâche est terminée, ouvre une Pull Request (PR) :
- De : `feature/ta-branche`
- Vers : `develop`

⚠️ Ne merge pas directement sur `main`. Le merge vers `main` ne se fera qu’une fois que toutes les features sont validées.

## Redémarrer après un pull (ATTENTION: réinitialise la base de données)
Après un `git pull`, pour repartir proprement et reconstruire les services Docker:
```bash
docker compose down -v
docker compose up -d --build
```
Attention: l'option `-v` supprime les volumes, donc toutes les données de la base seront perdues.

## Variables d'environnement (API)
L'API lit ces variables (déjà définies dans `docker-compose.yml` pour l'exécution via Docker):
- `PORT` (par défaut: 3000)
- `DB_HOST` (ex: `db` en Docker, `localhost` en local)
- `DB_PORT` (par défaut: 5432)
- `DB_USER` (ex: `nfp_user`)
- `DB_PASSWORD` (ex: `nfp_password`)
- `DB_NAME` (ex: `nfp_db`)