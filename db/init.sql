-- Activer l'extension pgcrypto
CREATE EXTENSION IF NOT EXISTS pgcrypto;

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

CREATE TABLE Salle(
   Id_Salle SERIAL,
   code_salle VARCHAR(50),
   PRIMARY KEY(Id_Salle)
);

CREATE TABLE Role(
   Id_Role SERIAL,
   nom VARCHAR(50),
   PRIMARY KEY(Id_Role)
);

CREATE TABLE Utilisateur(
   identifiant VARCHAR(50),
   nom VARCHAR(50),
   prenom VARCHAR(50),
   email VARCHAR(50),
   adresse VARCHAR(50),
   telephone VARCHAR(50),
   password VARCHAR(128),
   Id_Role INTEGER NOT NULL,
   PRIMARY KEY(identifiant),
   FOREIGN KEY(Id_Role) REFERENCES Role(Id_Role)
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

CREATE TABLE Professeur(
   identifiant VARCHAR(50),
   PRIMARY KEY(identifiant),
   FOREIGN KEY(identifiant) REFERENCES Utilisateur(identifiant)
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

CREATE TABLE Correspond(
   Id_Filiere INTEGER,
   code VARCHAR(50),
   PRIMARY KEY(Id_Filiere, code),
   FOREIGN KEY(Id_Filiere) REFERENCES Filiere(Id_Filiere),
   FOREIGN KEY(code) REFERENCES UE(code)
);

-- ====== ROLES ======
INSERT INTO Role (Id_Role, nom) VALUES
(1, 'etudiant'),
(2, 'professeur'),
(3, 'secretaire');

-- ====== PROMOS ======
INSERT INTO Promo (nom, annee_universitaire) VALUES
('Promo L3 Info', '2024-2025'),
('Promo M1 Info', '2024-2025'),
('Promo M2 Info', '2024-2025');

-- ====== FILIERES ======
INSERT INTO Filiere (nom_filiere) VALUES
('Informatique'),
('Mathématiques appliquées'),
('Cybersécurité');

-- ====== SALLES ======
INSERT INTO Salle (code_salle) VALUES
('A101'), ('B202'), ('C303');

-- ====== UTILISATEURS : SECRETAIRE ======
INSERT INTO Utilisateur VALUES
('sdupond', 'Dupond', 'Sophie', 'sdupond@univ.fr', '1 rue de Paris', '0600000001', encode(digest('password', 'sha512'), 'hex'), 3);

-- ====== UTILISATEURS : PROFESSEURS ======
INSERT INTO Utilisateur VALUES
('mdupont', 'Dupont', 'Marc', 'mdupont@univ.fr', '2 rue de Lyon', '0600000002', encode(digest('password', 'sha512'), 'hex'), 2),
('jmartin', 'Martin', 'Julie', 'jmartin@univ.fr', '3 rue de Nantes', '0600000003', encode(digest('password', 'sha512'), 'hex'), 2),
('pbernard', 'Bernard', 'Paul', 'pbernard@univ.fr', '4 rue de Lille', '0600000004', encode(digest('password', 'sha512'), 'hex'), 2);

INSERT INTO Professeur VALUES
('mdupont'),
('jmartin'),
('pbernard');

-- ====== UTILISATEURS : ETUDIANTS ======
-- Promo L3 Info
INSERT INTO Utilisateur VALUES
('adupont', 'Dupont', 'Alice', 'adupont@univ.fr', '10 rue A', '0610000001', encode(digest('password', 'sha512'), 'hex'), 1),
('bnguyen', 'Nguyen', 'Bao', 'bnguyen@univ.fr', '11 rue B', '0610000002', encode(digest('password', 'sha512'), 'hex'), 1),
('cgarcia', 'Garcia', 'Clara', 'cgarcia@univ.fr', '12 rue C', '0610000003', encode(digest('password', 'sha512'), 'hex'), 1),
('dlefevre', 'Lefevre', 'David', 'dlefevre@univ.fr', '13 rue D', '0610000004', encode(digest('password', 'sha512'), 'hex'), 1),
('eroux', 'Roux', 'Emma', 'eroux@univ.fr', '14 rue E', '0610000005', encode(digest('password', 'sha512'), 'hex'), 1);

-- Promo M1 Info
INSERT INTO Utilisateur VALUES
('fthomas', 'Thomas', 'François', 'fthomas@univ.fr', '15 rue F', '0610000006', encode(digest('password', 'sha512'), 'hex'), 1),
('ghenry', 'Henry', 'Gaëlle', 'ghenry@univ.fr', '16 rue G', '0610000007', encode(digest('password', 'sha512'), 'hex'), 1),
('hnguyen', 'Nguyen', 'Hugo', 'hnguyen@univ.fr', '17 rue H', '0610000008', encode(digest('password', 'sha512'), 'hex'), 1),
('ijoly', 'Joly', 'Inès', 'ijoly@univ.fr', '18 rue I', '0610000009', encode(digest('password', 'sha512'), 'hex'), 1),
('jcaron', 'Caron', 'Julien', 'jcaron@univ.fr', '19 rue J', '0610000010', encode(digest('password', 'sha512'), 'hex'), 1);

-- Promo M2 Info
INSERT INTO Utilisateur VALUES
('kpetit', 'Petit', 'Karim', 'kpetit@univ.fr', '20 rue K', '0610000011', encode(digest('password', 'sha512'), 'hex'), 1),
('ldurand', 'Durand', 'Laura', 'ldurand@univ.fr', '21 rue L', '0610000012', encode(digest('password', 'sha512'), 'hex'), 1),
('mleclerc', 'Leclerc', 'Mathis', 'mleclerc@univ.fr', '22 rue M', '0610000013', encode(digest('password', 'sha512'), 'hex'), 1),
('nblanc', 'Blanc', 'Nina', 'nblanc@univ.fr', '23 rue N', '0610000014', encode(digest('password', 'sha512'), 'hex'), 1),
('obenoit', 'Benoit', 'Olivier', 'obenoit@univ.fr', '24 rue O', '0610000015', encode(digest('password', 'sha512'), 'hex'), 1);

-- Association étudiants -> Etudiant (Filiere + Promo)
INSERT INTO Etudiant VALUES
('adupont', 1, 1), ('bnguyen', 1, 1), ('cgarcia', 2, 1), ('dlefevre', 3, 1), ('eroux', 1, 1),
('fthomas', 1, 2), ('ghenry', 2, 2), ('hnguyen', 1, 2), ('ijoly', 3, 2), ('jcaron', 1, 2),
('kpetit', 1, 3), ('ldurand', 2, 3), ('mleclerc', 3, 3), ('nblanc', 1, 3), ('obenoit', 2, 3);

-- ====== UE (responsables : profs) ======
INSERT INTO UE VALUES
('UE101', 'Bases de données', 40, 6, 'mdupont'),
('UE102', 'Algorithmique avancée', 45, 6, 'jmartin'),
('UE201', 'Sécurité informatique', 30, 6, 'pbernard'),
('UE202', 'Programmation Web', 35, 6, 'mdupont'),
('UE301', 'Machine Learning', 50, 9, 'jmartin'),
('UE302', 'Cloud Computing', 40, 9, 'pbernard');

-- ====== Enseigne (plusieurs profs pour une UE) ======
INSERT INTO Enseigne VALUES
('mdupont', 'UE101'), ('jmartin', 'UE101'),
('jmartin', 'UE102'),
('pbernard', 'UE201'),
('mdupont', 'UE202'), ('pbernard', 'UE202'),
('jmartin', 'UE301'),
('pbernard', 'UE302');

-- ====== Correspond (UE <-> Filières) ======
INSERT INTO Correspond VALUES
(1, 'UE101'), (1, 'UE102'), (1, 'UE202'), (1, 'UE301'),
(2, 'UE102'), (2, 'UE302'),
(3, 'UE201'), (3, 'UE202'), (3, 'UE302');

-- ====== Planning (1 cours par planning) ======
INSERT INTO Planning (plage_horaire, date_, identifiant, Id_Promo, code, Id_Salle) VALUES
('08:30-12:00', '2024-09-15', 'mdupont', 1, 'UE101', 1),
('13:30-17:00', '2024-09-15', 'jmartin', 1, 'UE102', 2),
('08:30-12:00', '2024-09-16', 'pbernard', 2, 'UE201', 2),
('13:30-17:00', '2024-09-16', 'mdupont', 2, 'UE202', 3),
('08:30-12:00', '2024-09-17', 'jmartin', 3, 'UE301', 1),
('13:30-17:00', '2024-09-17', 'pbernard', 3, 'UE302', 3);

-- ====== Notes ======
INSERT INTO Note (note, identifiant, code) VALUES
(14.5, 'adupont', 'UE101'),
(12.0, 'bnguyen', 'UE101'),
(9.5, 'cgarcia', 'UE102'),
(15.0, 'dlefevre', 'UE201'),
(11.0, 'eroux', 'UE202'),
(13.5, 'fthomas', 'UE301'),
(16.0, 'ghenry', 'UE302'),
(8.0, 'hnguyen', 'UE201'),
(10.5, 'ijoly', 'UE202'),
(14.0, 'jcaron', 'UE101'),
(15.5, 'kpetit', 'UE301'),
(12.5, 'ldurand', 'UE302'),
(13.0, 'mleclerc', 'UE201'),
(14.0, 'nblanc', 'UE102'),
(15.0, 'obenoit', 'UE302');

