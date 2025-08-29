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

CREATE TABLE Date_(
   Id_Date DATE,
   PRIMARY KEY(Id_Date)
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
   note VARCHAR(50),
   identifiant VARCHAR(50) NOT NULL,
   code VARCHAR(50) NOT NULL,
   PRIMARY KEY(Id_Note),
   FOREIGN KEY(identifiant) REFERENCES Etudiant(identifiant),
   FOREIGN KEY(code) REFERENCES UE(code)
);

CREATE TABLE Planning(
   Id_Planning SERIAL,
   plage_horaire VARCHAR(50),
   identifiant VARCHAR(50) NOT NULL,
   Id_Date DATE NOT NULL,
   Id_Promo INTEGER NOT NULL,
   code VARCHAR(50) NOT NULL,
   Id_Salle INTEGER NOT NULL,
   PRIMARY KEY(Id_Planning),
   FOREIGN KEY(identifiant) REFERENCES Professeur(identifiant),
   FOREIGN KEY(Id_Date) REFERENCES Date_(Id_Date),
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
