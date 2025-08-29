const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'dev-secret-change-me';
const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || '2h';

function signUserToken(payload) {
  return jwt.sign(payload, JWT_SECRET, { expiresIn: JWT_EXPIRES_IN });
}

function authenticateBearer(req, res, next) {
  const authHeader = req.headers['authorization'] || '';
  const [scheme, token] = authHeader.split(' ');
  if (scheme !== 'Bearer' || !token) {
    return res.status(401).json({ erreur: 'Token manquant ou invalide' });
  }
  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.user = decoded;
    return next();
  } catch (err) {
    return res.status(401).json({ erreur: 'Token invalide' });
  }
}

// Middleware pour vérifier si l'utilisateur a un rôle spécifique
function requireRole(role) {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({ erreur: 'Token manquant ou invalide' });
    }
    
    if (req.user.role !== role) {
      return res.status(403).json({ 
        erreur: `Accès refusé. Rôle requis: ${role}, Rôle actuel: ${req.user.role}` 
      });
    }
    
    return next();
  };
}

// Middleware pour vérifier si l'utilisateur a l'un des rôles spécifiés
function requireAnyRole(roles) {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({ erreur: 'Token manquant ou invalide' });
    }
    
    if (!roles.includes(req.user.role)) {
      return res.status(403).json({ 
        erreur: `Accès refusé. Rôles autorisés: ${roles.join(', ')}, Rôle actuel: ${req.user.role}` 
      });
    }
    
    return next();
  };
}

module.exports = { signUserToken, authenticateBearer, requireRole, requireAnyRole };


