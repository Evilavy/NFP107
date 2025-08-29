CREATE TABLE Utilisateur(
   identifiant VARCHAR(50),
   nom VARCHAR(50),
   prenom VARCHAR(50),
   email VARCHAR(50),
   adresse VARCHAR(50),
   telephone VARCHAR(50),
   password VARCHAR(128),
   PRIMARY KEY(identifiant)
);

CREATE TABLE Professeur(
   identifiant VARCHAR(50),
   PRIMARY KEY(identifiant),
   FOREIGN KEY(identifiant) REFERENCES Utilisateur(identifiant)
);

CREATE TABLE Promo(
   Id_Promo SERIAL,
   nom VARCHAR(50),
   annee_universitaire VARCHAR(50),
   PRIMARY KEY(Id_Promo)
);

CREATE TABLE Filiere(
   Id_Filiere SERIAL,
   nom_filiere VARCHAR(50) NOT NULL,
   PRIMARY KEY(Id_Filiere)
);

CREATE TABLE UE(
   code VARCHAR(50),
   intitule VARCHAR(50),
   nombre_heure INTEGER,
   nombre_ects INTEGER,
   identifiant VARCHAR(50) NOT NULL,
   PRIMARY KEY(code),
   FOREIGN KEY(identifiant) REFERENCES Professeur(identifiant)
);

CREATE TABLE Salle(
   Id_Salle SERIAL,
   code_salle VARCHAR(50),
   PRIMARY KEY(Id_Salle)
);

CREATE TABLE Etudiant(
   identifiant VARCHAR(50),
   Id_Filiere INTEGER NOT NULL,
   Id_Promo INTEGER NOT NULL,
   PRIMARY KEY(identifiant),
   FOREIGN KEY(identifiant) REFERENCES Utilisateur(identifiant),
   FOREIGN KEY(Id_Filiere) REFERENCES Filiere(Id_Filiere),
   FOREIGN KEY(Id_Promo) REFERENCES Promo(Id_Promo)
);

CREATE TABLE Note(
   Id_Note SERIAL,
   note NUMERIC(4,2),
   identifiant VARCHAR(50) NOT NULL,
   code VARCHAR(50) NOT NULL,
   PRIMARY KEY(Id_Note),
   FOREIGN KEY(identifiant) REFERENCES Etudiant(identifiant),
   FOREIGN KEY(code) REFERENCES UE(code)
);

CREATE TABLE Planning(
   Id_Planning SERIAL,
   plage_horaire VARCHAR(50),
   date_ DATE NOT NULL,
   identifiant VARCHAR(50) NOT NULL,
   Id_Promo INTEGER NOT NULL,
   code VARCHAR(50) NOT NULL,
   Id_Salle INTEGER NOT NULL,
   PRIMARY KEY(Id_Planning),
   FOREIGN KEY(identifiant) REFERENCES Professeur(identifiant),
   FOREIGN KEY(Id_Promo) REFERENCES Promo(Id_Promo),
   FOREIGN KEY(code) REFERENCES UE(code),
   FOREIGN KEY(Id_Salle) REFERENCES Salle(Id_Salle)
);

CREATE TABLE Enseigne(
   identifiant VARCHAR(50),
   code VARCHAR(50),
   PRIMARY KEY(identifiant, code),
   FOREIGN KEY(identifiant) REFERENCES Professeur(identifiant),
   FOREIGN KEY(code) REFERENCES UE(code)
);


-- ================================
-- UTILISATEURS (profs + étudiants)
-- ================================
INSERT INTO Utilisateur (identifiant, nom, prenom, email, adresse, telephone, password) VALUES
-- Profs
('pdurand',   'Durand',   'Paul',    'paul.durand@univ.fr',    '1 rue des profs',     '0600000001', 'hashedpwd1'),
('cmartin',   'Martin',   'Claire',  'claire.martin@univ.fr',  '2 rue des profs',     '0600000002', 'hashedpwd2'),
('ljacquet',  'Jacquet',  'Luc',     'luc.jacquet@univ.fr',    '3 rue des profs',     '0600000003', 'hashedpwd3'),
('mroche',    'Roche',    'Marie',   'marie.roche@univ.fr',    '4 rue des profs',     '0600000004', 'hashedpwd4'),
('fnguyen',   'Nguyen',   'Franck',  'franck.nguyen@univ.fr',  '5 rue des profs',     '0600000005', 'hashedpwd5'),

-- Étudiants promo L3
('adupont',   'Dupont',   'Alice',   'alice.dupont@etu.univ.fr',   '10 rue des etudiants', '0611111111','hashedpwd6'),
('bbernard',  'Bernard',  'Lucas',   'lucas.bernard@etu.univ.fr',  '11 rue des etudiants', '0611111112','hashedpwd7'),
('ppetit',    'Petit',    'Emma',    'emma.petit@etu.univ.fr',     '12 rue des etudiants', '0611111113','hashedpwd8'),
('mgarcia',   'Garcia',   'Maxime',  'maxime.garcia@etu.univ.fr',  '13 rue des etudiants', '0611111114','hashedpwd9'),
('cdupuis',   'Dupuis',   'Chloé',   'chloe.dupuis@etu.univ.fr',   '14 rue des etudiants', '0611111115','hashedpwd10'),

-- Étudiants promo M1
('tcaron',    'Caron',    'Thomas',  'thomas.caron@etu.univ.fr',   '15 rue des etudiants', '0611111116','hashedpwd11'),
('jmoreau',   'Moreau',   'Julie',   'julie.moreau@etu.univ.fr',   '16 rue des etudiants', '0611111117','hashedpwd12'),
('rlambert',  'Lambert',  'Romain',  'romain.lambert@etu.univ.fr', '17 rue des etudiants', '0611111118','hashedpwd13'),
('sdurand',   'Durand',   'Sophie',  'sophie.durand@etu.univ.fr',  '18 rue des etudiants', '0611111119','hashedpwd14'),
('pfernandez','Fernandez','Pierre',  'pierre.fernandez@etu.univ.fr','19 rue des etudiants','0611111120','hashedpwd15');

-- ================================
-- PROFESSEURS
-- ================================
INSERT INTO Professeur (identifiant) VALUES
('pdurand'), ('cmartin'), ('ljacquet'), ('mroche'), ('fnguyen');

-- ================================
-- PROMOS
-- ================================
INSERT INTO Promo (nom, annee_universitaire) VALUES
('L3 Info', '2024-2025'),
('M1 Info', '2024-2025');

-- ================================
-- FILIERES
-- ================================
INSERT INTO Filiere (nom_filiere) VALUES
('informatique'),
('math-info');

-- ================================
-- ETUDIANTS (affectés à promo + filière)
-- ================================
-- L3 étudiants
INSERT INTO Etudiant (identifiant, Id_Filiere, Id_Promo) VALUES
('adupont', 1, 1),
('bbernard',1, 1),
('ppetit',  1, 1),
('mgarcia', 1, 1),
('cdupuis', 2, 1);

-- M1 étudiants
INSERT INTO Etudiant (identifiant, Id_Filiere, Id_Promo) VALUES
('tcaron',    1, 2),
('jmoreau',   2, 2),
('rlambert',  1, 2),
('sdurand',   1, 2),
('pfernandez',2, 2);

-- ================================
-- SALLES
-- ================================
INSERT INTO Salle (code_salle) VALUES
('b101'), ('b102'), ('c201'), ('c202');

-- ================================
-- UEs (chaque UE a un prof responsable)
-- ================================
INSERT INTO UE (code, intitule, nombre_heure, nombre_ects, identifiant) VALUES
('ue1', 'algorithmique avancée', 40, 6, 'pdurand'),
('ue2', 'bases de données',      30, 5, 'cmartin'),
('ue3', 'systèmes distribués',   35, 6, 'ljacquet'),
('ue4', 'programmation web',     25, 4, 'mroche'),
('ue5', 'intelligence artificielle', 40, 8, 'fnguyen');

-- ================================
-- ENSEIGNE (plusieurs profs peuvent enseigner la même UE)
-- ================================
INSERT INTO Enseigne (identifiant, code) VALUES
('pdurand',  'ue1'),
('cmartin',  'ue2'),
('ljacquet', 'ue3'),
('mroche',   'ue4'),
('fnguyen',  'ue5'),
('cmartin',  'ue1'),
('mroche',   'ue2');

-- ================================
-- NOTES (exemple simplifié : chaque étudiant a des notes sur 3 UEs)
-- ================================
INSERT INTO Note (note, identifiant, code) VALUES
-- Promo L3
(14.0, 'adupont',  'ue1'), (15.5, 'adupont',  'ue2'), (13.0, 'adupont',  'ue3'),
(11.0, 'bbernard', 'ue1'), (16.0, 'bbernard', 'ue2'), (12.5, 'bbernard', 'ue3'),
(17.0, 'ppetit',   'ue1'), (14.5, 'ppetit',   'ue2'), (16.0, 'ppetit',   'ue3'),
(10.5, 'mgarcia',  'ue1'), (13.0, 'mgarcia',  'ue2'), (14.0, 'mgarcia',  'ue3'),
(12.0, 'cdupuis',  'ue1'), (15.0, 'cdupuis',  'ue2'), (11.5, 'cdupuis',  'ue3'),

-- Promo M1
(13.5, 'tcaron',    'ue2'), (16.0, 'tcaron',    'ue4'), (14.0, 'tcaron',    'ue5'),
(12.0, 'jmoreau',   'ue2'), (11.5, 'jmoreau',   'ue4'), (13.0, 'jmoreau',   'ue5'),
(15.0, 'rlambert',  'ue2'), (17.0, 'rlambert',  'ue4'), (18.0, 'rlambert',  'ue5'),
(14.0, 'sdurand',   'ue2'), (13.5, 'sdurand',   'ue4'), (12.0, 'sdurand',   'ue5'),
(16.5, 'pfernandez','ue2'), (15.0, 'pfernandez','ue4'), (17.5, 'pfernandez','ue5');

-- ================================
-- PLANNING (quelques cours planifiés)
-- ================================
INSERT INTO Planning (plage_horaire, date_, identifiant, Id_Promo, code, Id_Salle) VALUES
('08h00-10h00','2024-10-01','pdurand', 1,'ue1',1),
('10h15-12h15','2024-10-01','cmartin', 1,'ue2',2),
('14h00-16h00','2024-10-02','ljacquet',1,'ue3',3),
('08h00-10h00','2024-10-03','mroche',  2,'ue4',4),
('10h15-12h15','2024-10-03','fnguyen', 2,'ue5',2);
