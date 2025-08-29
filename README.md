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

## Exécuter en local (sans Docker)
1. Lancer une base PostgreSQL (locale ou distante) et créer la table:
```sql
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```
2. Installer les dépendances:
```bash
npm install
```
3. Exporter les variables d'environnement (exemple macOS/Linux):
```bash
export PORT=3000
export DB_HOST=localhost
export DB_PORT=5432
export DB_USER=postgres
export DB_PASSWORD=postgres
export DB_NAME=postgres
```
4. Démarrer l'API:
```bash
npm start
```
5. Ouvrir:
- http://localhost:3000
- http://localhost:3000/api-docs

## Structure du projet
- `index.js` — Entrée Express, montage routes et Swagger
- `routes/personne.js` — Endpoints `GET /users`, `POST /users`
- `lib/db.js` — Connexion PostgreSQL (pg Pool)
- `swagger.json` — Spécification OpenAPI 3
- `db/init.sql` — Script d'init pour créer la table `users`
- `Dockerfile`, `docker-compose.yml`, `.dockerignore`
- `package.json`

## Notes
- Au premier démarrage Docker, Postgres peut prendre quelques secondes; si un `ECONNREFUSED` apparaît au boot, réessayez la requête une fois la DB prête.
