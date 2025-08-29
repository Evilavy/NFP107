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


-- =============================================================
-- =============== DONNÉES SUPPLÉMENTAIRES MASSIVES ============
-- =============================================================

-- PROMOS supplémentaires
INSERT INTO Promo (nom, annee_universitaire) VALUES
('Promo L1 Info', '2024-2025'),
('Promo L2 Info', '2024-2025'),
('Promo L3 Info B', '2024-2025'),
('Promo M1 Info B', '2024-2025'),
('Promo M2 Cyber', '2024-2025');

-- FILIÈRES supplémentaires
INSERT INTO Filiere (nom_filiere) VALUES
('Data Science'),
('Réseaux'),
('Intelligence Artificielle'),
('Systèmes embarqués'),
('Robotique');

-- SALLES supplémentaires
INSERT INTO Salle (code_salle) VALUES
('D101'), ('D102'), ('D103'), ('D104'), ('D105'),
('D201'), ('D202'), ('D203'), ('D204'), ('D205');

-- PROFESSEURS supplémentaires (création dans Utilisateur + Professeur)
INSERT INTO Utilisateur VALUES
('cperrin', 'Perrin', 'Chloé', 'cperrin@univ.fr', '5 rue de Brest', '0600000005', encode(digest('password', 'sha512'), 'hex'), 2),
('rmoreau', 'Moreau', 'Romain', 'rmoreau@univ.fr', '6 rue de Metz', '0600000006', encode(digest('password', 'sha512'), 'hex'), 2),
('tlambert', 'Lambert', 'Théo', 'tlambert@univ.fr', '7 rue de Nice', '0600000007', encode(digest('password', 'sha512'), 'hex'), 2),
('lfontaine', 'Fontaine', 'Lina', 'lfontaine@univ.fr', '8 rue de Nancy', '0600000008', encode(digest('password', 'sha512'), 'hex'), 2),
('grousseau', 'Rousseau', 'Gaëtan', 'grousseau@univ.fr', '9 rue de Tours', '0600000009', encode(digest('password', 'sha512'), 'hex'), 2),
('acarre', 'Carré', 'Aurore', 'acarre@univ.fr', '10 rue de Brest', '0600000016', encode(digest('password', 'sha512'), 'hex'), 2),
('broy', 'Roy', 'Bastien', 'broy@univ.fr', '11 rue de Nancy', '0600000017', encode(digest('password', 'sha512'), 'hex'), 2),
('scolas', 'Colas', 'Sara', 'scolas@univ.fr', '12 rue de Rennes', '0600000018', encode(digest('password', 'sha512'), 'hex'), 2),
('fbaron', 'Baron', 'Florian', 'fbaron@univ.fr', '13 rue de Reims', '0600000019', encode(digest('password', 'sha512'), 'hex'), 2),
('mmorel', 'Morel', 'Maud', 'mmorel@univ.fr', '14 rue de Caen', '0600000020', encode(digest('password', 'sha512'), 'hex'), 2);

INSERT INTO Professeur VALUES
('cperrin'), ('rmoreau'), ('tlambert'), ('lfontaine'), ('grousseau'),
('acarre'), ('broy'), ('scolas'), ('fbaron'), ('mmorel');

-- ÉTUDIANTS supplémentaires (50 étudiants)
INSERT INTO Utilisateur VALUES
('s001', 'Arnaud', 'Sophie', 's001@univ.fr', '1 rue AA', '0611000001', encode(digest('password', 'sha512'), 'hex'), 1),
('s002', 'Bernard', 'Lucas', 's002@univ.fr', '2 rue AB', '0611000002', encode(digest('password', 'sha512'), 'hex'), 1),
('s003', 'Cohen', 'Léa', 's003@univ.fr', '3 rue AC', '0611000003', encode(digest('password', 'sha512'), 'hex'), 1),
('s004', 'Dubois', 'Noah', 's004@univ.fr', '4 rue AD', '0611000004', encode(digest('password', 'sha512'), 'hex'), 1),
('s005', 'Etienne', 'Mila', 's005@univ.fr', '5 rue AE', '0611000005', encode(digest('password', 'sha512'), 'hex'), 1),
('s006', 'Fabre', 'Jules', 's006@univ.fr', '6 rue AF', '0611000006', encode(digest('password', 'sha512'), 'hex'), 1),
('s007', 'Garnier', 'Lina', 's007@univ.fr', '7 rue AG', '0611000007', encode(digest('password', 'sha512'), 'hex'), 1),
('s008', 'Henri', 'Tom', 's008@univ.fr', '8 rue AH', '0611000008', encode(digest('password', 'sha512'), 'hex'), 1),
('s009', 'Ibrahim', 'Amy', 's009@univ.fr', '9 rue AI', '0611000009', encode(digest('password', 'sha512'), 'hex'), 1),
('s010', 'Joly', 'Evan', 's010@univ.fr', '10 rue AJ', '0611000010', encode(digest('password', 'sha512'), 'hex'), 1),
('s011', 'Khaled', 'Nina', 's011@univ.fr', '11 rue AK', '0611000011', encode(digest('password', 'sha512'), 'hex'), 1),
('s012', 'Leroy', 'Adam', 's012@univ.fr', '12 rue AL', '0611000012', encode(digest('password', 'sha512'), 'hex'), 1),
('s013', 'Marchand', 'Zoé', 's013@univ.fr', '13 rue AM', '0611000013', encode(digest('password', 'sha512'), 'hex'), 1),
('s014', 'Nguyen', 'Liam', 's014@univ.fr', '14 rue AN', '0611000014', encode(digest('password', 'sha512'), 'hex'), 1),
('s015', 'Olivier', 'Emma', 's015@univ.fr', '15 rue AO', '0611000015', encode(digest('password', 'sha512'), 'hex'), 1),
('s016', 'Petit', 'Nathan', 's016@univ.fr', '16 rue AP', '0611000016', encode(digest('password', 'sha512'), 'hex'), 1),
('s017', 'Quentin', 'Lola', 's017@univ.fr', '17 rue AQ', '0611000017', encode(digest('password', 'sha512'), 'hex'), 1),
('s018', 'Robin', 'Timéo', 's018@univ.fr', '18 rue AR', '0611000018', encode(digest('password', 'sha512'), 'hex'), 1),
('s019', 'Simon', 'Anna', 's019@univ.fr', '19 rue AS', '0611000019', encode(digest('password', 'sha512'), 'hex'), 1),
('s020', 'Thomas', 'Hugo', 's020@univ.fr', '20 rue AT', '0611000020', encode(digest('password', 'sha512'), 'hex'), 1),
('s021', 'Urbain', 'Chloé', 's021@univ.fr', '21 rue AU', '0611000021', encode(digest('password', 'sha512'), 'hex'), 1),
('s022', 'Vidal', 'Gabriel', 's022@univ.fr', '22 rue AV', '0611000022', encode(digest('password', 'sha512'), 'hex'), 1),
('s023', 'Wagner', 'Camille', 's023@univ.fr', '23 rue AW', '0611000023', encode(digest('password', 'sha512'), 'hex'), 1),
('s024', 'Xavier', 'Noé', 's024@univ.fr', '24 rue AX', '0611000024', encode(digest('password', 'sha512'), 'hex'), 1),
('s025', 'Young', 'Eva', 's025@univ.fr', '25 rue AY', '0611000025', encode(digest('password', 'sha512'), 'hex'), 1),
('s026', 'Zimmer', 'Jade', 's026@univ.fr', '26 rue AZ', '0611000026', encode(digest('password', 'sha512'), 'hex'), 1),
('s027', 'Albert', 'Sacha', 's027@univ.fr', '27 rue BA', '0611000027', encode(digest('password', 'sha512'), 'hex'), 1),
('s028', 'Bauer', 'Soline', 's028@univ.fr', '28 rue BB', '0611000028', encode(digest('password', 'sha512'), 'hex'), 1),
('s029', 'Carlier', 'Noa', 's029@univ.fr', '29 rue BC', '0611000029', encode(digest('password', 'sha512'), 'hex'), 1),
('s030', 'Delmas', 'Louise', 's030@univ.fr', '30 rue BD', '0611000030', encode(digest('password', 'sha512'), 'hex'), 1),
('s031', 'Evrard', 'Maël', 's031@univ.fr', '31 rue BE', '0611000031', encode(digest('password', 'sha512'), 'hex'), 1),
('s032', 'Faure', 'Léane', 's032@univ.fr', '32 rue BF', '0611000032', encode(digest('password', 'sha512'), 'hex'), 1),
('s033', 'Gerard', 'Rayan', 's033@univ.fr', '33 rue BG', '0611000033', encode(digest('password', 'sha512'), 'hex'), 1),
('s034', 'Herve', 'Myriam', 's034@univ.fr', '34 rue BH', '0611000034', encode(digest('password', 'sha512'), 'hex'), 1),
('s035', 'Imbert', 'Noémie', 's035@univ.fr', '35 rue BI', '0611000035', encode(digest('password', 'sha512'), 'hex'), 1),
('s036', 'Jacquet', 'Ilyes', 's036@univ.fr', '36 rue BJ', '0611000036', encode(digest('password', 'sha512'), 'hex'), 1),
('s037', 'Klein', 'Alicia', 's037@univ.fr', '37 rue BK', '0611000037', encode(digest('password', 'sha512'), 'hex'), 1),
('s038', 'Legrand', 'Marin', 's038@univ.fr', '38 rue BL', '0611000038', encode(digest('password', 'sha512'), 'hex'), 1),
('s039', 'Masson', 'Yanis', 's039@univ.fr', '39 rue BM', '0611000039', encode(digest('password', 'sha512'), 'hex'), 1),
('s040', 'Navarro', 'Roxane', 's040@univ.fr', '40 rue BN', '0611000040', encode(digest('password', 'sha512'), 'hex'), 1),
('s041', 'Oury', 'Louna', 's041@univ.fr', '41 rue BO', '0611000041', encode(digest('password', 'sha512'), 'hex'), 1),
('s042', 'Pires', 'Nolan', 's042@univ.fr', '42 rue BP', '0611000042', encode(digest('password', 'sha512'), 'hex'), 1),
('s043', 'Quillot', 'Mia', 's043@univ.fr', '43 rue BQ', '0611000043', encode(digest('password', 'sha512'), 'hex'), 1),
('s044', 'Rault', 'Naël', 's044@univ.fr', '44 rue BR', '0611000044', encode(digest('password', 'sha512'), 'hex'), 1),
('s045', 'Sauvage', 'Ambre', 's045@univ.fr', '45 rue BS', '0611000045', encode(digest('password', 'sha512'), 'hex'), 1),
('s046', 'Tanguy', 'Kylian', 's046@univ.fr', '46 rue BT', '0611000046', encode(digest('password', 'sha512'), 'hex'), 1),
('s047', 'Urbain', 'Mélyna', 's047@univ.fr', '47 rue BU', '0611000047', encode(digest('password', 'sha512'), 'hex'), 1),
('s048', 'Valentin', 'Lison', 's048@univ.fr', '48 rue BV', '0611000048', encode(digest('password', 'sha512'), 'hex'), 1),
('s049', 'Wang', 'Elisa', 's049@univ.fr', '49 rue BW', '0611000049', encode(digest('password', 'sha512'), 'hex'), 1),
('s050', 'Xu', 'Ilan', 's050@univ.fr', '50 rue BX', '0611000050', encode(digest('password', 'sha512'), 'hex'), 1);

-- Association étudiants supplémentaires -> Etudiant
-- On répartit sur plusieurs filières et promos (en utilisant les IDs existants + nouveaux)
-- Filières (existantes + nouvelles) ont des Id_Filiere croissants à partir de 1
-- Promos (existantes + nouvelles) ont des Id_Promo croissants à partir de 1
INSERT INTO Etudiant VALUES
('s001', 4, 1), ('s002', 2, 2), ('s003', 1, 3), ('s004', 3, 1), ('s005', 5, 2),
('s006', 6, 3), ('s007', 7, 4), ('s008', 8, 5), ('s009', 1, 2), ('s010', 2, 1),
('s011', 3, 3), ('s012', 4, 2), ('s013', 5, 1), ('s014', 6, 2), ('s015', 7, 3),
('s016', 8, 4), ('s017', 1, 5), ('s018', 2, 3), ('s019', 3, 2), ('s020', 4, 1),
('s021', 5, 3), ('s022', 6, 1), ('s023', 7, 2), ('s024', 8, 3), ('s025', 1, 4),
('s026', 2, 5), ('s027', 3, 1), ('s028', 4, 3), ('s029', 5, 2), ('s030', 6, 4),
('s031', 7, 5), ('s032', 8, 1), ('s033', 1, 2), ('s034', 2, 3), ('s035', 3, 4),
('s036', 4, 5), ('s037', 5, 1), ('s038', 6, 2), ('s039', 7, 3), ('s040', 8, 4),
('s041', 1, 5), ('s042', 2, 1), ('s043', 3, 2), ('s044', 4, 3), ('s045', 5, 4),
('s046', 6, 5), ('s047', 7, 1), ('s048', 8, 2), ('s049', 1, 3), ('s050', 2, 4);

-- UE supplémentaires (nouvelles matières)
INSERT INTO UE VALUES
('UE401', 'Programmation Système', 40, 6, 'cperrin'),
('UE402', 'Réseaux avancés', 45, 6, 'rmoreau'),
('UE403', 'Deep Learning', 40, 9, 'tlambert'),
('UE404', 'Vision par ordinateur', 35, 6, 'lfontaine'),
('UE405', 'Big Data', 40, 6, 'grousseau'),
('UE406', 'Sécurité Réseaux', 30, 6, 'acarre'),
('UE407', 'DevOps', 35, 6, 'broy'),
('UE408', 'Architecture des OS', 45, 6, 'scolas'),
('UE409', 'Traitement du langage', 40, 9, 'fbaron'),
('UE410', 'Systèmes embarqués', 40, 6, 'mmorel');

-- Enseignements supplémentaires
INSERT INTO Enseigne VALUES
('cperrin', 'UE401'), ('rmoreau', 'UE401'),
('rmoreau', 'UE402'),
('tlambert', 'UE403'), ('lfontaine', 'UE404'),
('grousseau', 'UE405'),
('acarre', 'UE406'), ('broy', 'UE407'),
('scolas', 'UE408'), ('fbaron', 'UE409'),
('mmorel', 'UE410');

-- Planning supplémentaire
INSERT INTO Planning (plage_horaire, date_, identifiant, Id_Promo, code, Id_Salle) VALUES
('08:30-12:00', '2024-09-18', 'cperrin', 4, 'UE401', 4),
('13:30-17:00', '2024-09-18', 'rmoreau', 4, 'UE402', 5),
('08:30-12:00', '2024-09-19', 'tlambert', 5, 'UE403', 6),
('13:30-17:00', '2024-09-19', 'lfontaine', 5, 'UE404', 7),
('08:30-12:00', '2024-09-20', 'grousseau', 6, 'UE405', 8),
('13:30-17:00', '2024-09-20', 'acarre', 6, 'UE406', 9),
('08:30-12:00', '2024-09-21', 'broy', 7, 'UE407', 10),
('13:30-17:00', '2024-09-21', 'scolas', 7, 'UE408', 1),
('08:30-12:00', '2024-09-22', 'fbaron', 8, 'UE409', 2),
('13:30-17:00', '2024-09-22', 'mmorel', 8, 'UE410', 3);

-- Notes supplémentaires
INSERT INTO Note (note, identifiant, code) VALUES
(12.0, 's001', 'UE401'), (13.5, 's002', 'UE401'), (15.0, 's003', 'UE402'),
(11.0, 's004', 'UE402'), (16.0, 's005', 'UE403'), (9.5, 's006', 'UE403'),
(14.0, 's007', 'UE404'), (10.5, 's008', 'UE404'), (13.0, 's009', 'UE405'),
(15.5, 's010', 'UE405'), (12.5, 's011', 'UE406'), (14.0, 's012', 'UE406'),
(11.5, 's013', 'UE407'), (16.0, 's014', 'UE407'), (10.0, 's015', 'UE408'),
(13.5, 's016', 'UE408'), (14.5, 's017', 'UE409'), (12.0, 's018', 'UE409'),
(15.0, 's019', 'UE410'), (11.0, 's020', 'UE410');

-- Plus d'UE pour étoffer fortement le catalogue
INSERT INTO UE VALUES
('UE411', 'Analyse de données', 40, 6, 'cperrin'),
('UE412', 'Réseaux mobiles', 35, 6, 'rmoreau'),
('UE413', 'RL et Agents', 40, 9, 'tlambert'),
('UE414', 'NLP avancé', 40, 9, 'fbaron'),
('UE415', 'Crypto appliquée', 30, 6, 'acarre'),
('UE416', 'Conteneurs et Orchestration', 35, 6, 'broy'),
('UE417', 'Sécurité applicative', 30, 6, 'mmorel'),
('UE418', 'Calcul distribué', 45, 6, 'grousseau'),
('UE419', 'Probabilités pour l’IA', 30, 6, 'lfontaine'),
('UE420', 'Systèmes temps réel', 40, 6, 'mmorel'),
('UE421', 'Graphes et réseaux', 35, 6, 'rmoreau'),
('UE422', 'Infra as Code', 35, 6, 'broy'),
('UE423', 'Sécurité cloud', 30, 6, 'acarre'),
('UE424', 'Vision 3D', 40, 9, 'lfontaine'),
('UE425', 'AutoML', 30, 9, 'tlambert'),
('UE426', 'Bases NoSQL', 35, 6, 'cperrin'),
('UE427', 'Optimisation', 40, 6, 'grousseau'),
('UE428', 'Virtualisation', 35, 6, 'scolas'),
('UE429', 'Sécurité matérielle', 30, 6, 'mmorel'),
('UE430', 'Edge Computing', 35, 6, 'cperrin');

-- Enseignements associés aux nouvelles UE
INSERT INTO Enseigne VALUES
('cperrin', 'UE411'), ('rmoreau', 'UE412'),
('tlambert', 'UE413'), ('fbaron', 'UE414'),
('acarre', 'UE415'), ('broy', 'UE416'),
('mmorel', 'UE417'), ('grousseau', 'UE418'),
('lfontaine', 'UE419'), ('mmorel', 'UE420'),
('rmoreau', 'UE421'), ('broy', 'UE422'),
('acarre', 'UE423'), ('lfontaine', 'UE424'),
('tlambert', 'UE425'), ('cperrin', 'UE426'),
('grousseau', 'UE427'), ('scolas', 'UE428'),
('mmorel', 'UE429'), ('cperrin', 'UE430');

-- Planning enrichi pour les nouvelles UE
INSERT INTO Planning (plage_horaire, date_, identifiant, Id_Promo, code, Id_Salle) VALUES
('08:30-12:00', '2024-09-23', 'cperrin', 1, 'UE411', 4),
('13:30-17:00', '2024-09-23', 'rmoreau', 2, 'UE412', 5),
('08:30-12:00', '2024-09-24', 'tlambert', 3, 'UE413', 6),
('13:30-17:00', '2024-09-24', 'fbaron', 4, 'UE414', 7),
('08:30-12:00', '2024-09-25', 'acarre', 5, 'UE415', 8),
('13:30-17:00', '2024-09-25', 'broy', 6, 'UE416', 9),
('08:30-12:00', '2024-09-26', 'mmorel', 7, 'UE417', 10),
('13:30-17:00', '2024-09-26', 'grousseau', 8, 'UE418', 1),
('08:30-12:00', '2024-09-27', 'lfontaine', 1, 'UE419', 2),
('13:30-17:00', '2024-09-27', 'mmorel', 2, 'UE420', 3),
('08:30-12:00', '2024-09-28', 'rmoreau', 3, 'UE421', 4),
('13:30-17:00', '2024-09-28', 'broy', 4, 'UE422', 5),
('08:30-12:00', '2024-09-29', 'acarre', 5, 'UE423', 6),
('13:30-17:00', '2024-09-29', 'lfontaine', 6, 'UE424', 7),
('08:30-12:00', '2024-09-30', 'tlambert', 7, 'UE425', 8),
('13:30-17:00', '2024-09-30', 'cperrin', 8, 'UE426', 9),
('08:30-12:00', '2024-10-01', 'grousseau', 1, 'UE427', 10),
('13:30-17:00', '2024-10-01', 'scolas', 2, 'UE428', 1),
('08:30-12:00', '2024-10-02', 'mmorel', 3, 'UE429', 2),
('13:30-17:00', '2024-10-02', 'cperrin', 4, 'UE430', 3);

-- Beaucoup plus de notes (répartition sur étudiants s001..s050 et quelques existants)
INSERT INTO Note (note, identifiant, code) VALUES
(12.5, 's021', 'UE411'), (14.0, 's022', 'UE411'), (9.0, 's023', 'UE412'), (15.5, 's024', 'UE412'),
(13.0, 's025', 'UE413'), (11.5, 's026', 'UE413'), (16.0, 's027', 'UE414'), (10.0, 's028', 'UE414'),
(14.5, 's029', 'UE415'), (12.0, 's030', 'UE415'), (13.5, 's031', 'UE416'), (11.0, 's032', 'UE416'),
(15.0, 's033', 'UE417'), (10.5, 's034', 'UE417'), (12.0, 's035', 'UE418'), (14.0, 's036', 'UE418'),
(13.0, 's037', 'UE419'), (15.5, 's038', 'UE419'), (11.5, 's039', 'UE420'), (16.0, 's040', 'UE420'),
(10.0, 's041', 'UE421'), (13.5, 's042', 'UE421'), (14.0, 's043', 'UE422'), (12.0, 's044', 'UE422'),
(15.0, 's045', 'UE423'), (11.0, 's046', 'UE423'), (14.5, 's047', 'UE424'), (9.5, 's048', 'UE424'),
(13.0, 's049', 'UE425'), (12.5, 's050', 'UE425'), (15.5, 's001', 'UE426'), (10.5, 's002', 'UE426'),
(14.0, 's003', 'UE427'), (12.0, 's004', 'UE427'), (13.5, 's005', 'UE428'), (11.0, 's006', 'UE428'),
(15.0, 's007', 'UE429'), (10.0, 's008', 'UE429'), (14.5, 's009', 'UE430'), (12.0, 's010', 'UE430'),
(13.0, 'adupont', 'UE411'), (14.0, 'bnguyen', 'UE412'), (12.5, 'cgarcia', 'UE413'), (15.0, 'dlefevre', 'UE414'),
(11.5, 'eroux', 'UE415'), (16.0, 'fthomas', 'UE416'), (10.5, 'ghenry', 'UE417'), (14.5, 'hnguyen', 'UE418'),
(12.0, 'ijoly', 'UE419'), (15.0, 'jcaron', 'UE420');
