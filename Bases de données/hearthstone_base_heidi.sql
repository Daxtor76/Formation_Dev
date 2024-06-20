
START TRANSACTION;

CREATE TABLE IF NOT EXISTS classe (
    id_classe INTEGER AUTO_INCREMENT,
    nom VARCHAR(30),
    PRIMARY KEY(id_classe)
);

CREATE TABLE IF NOT EXISTS rarete (
    id_rarete INTEGER AUTO_INCREMENT,
    nom VARCHAR(20),
    PRIMARY KEY(id_rarete)
);

CREATE TABLE IF NOT EXISTS carte (
    id_carte INTEGER AUTO_INCREMENT,
    nom VARCHAR(50),
    descriptif VARCHAR(200),
    id_rarete INT NOT NULL,
    id_classe INT NOT NULL,
    PRIMARY KEY(id_carte),
    FOREIGN KEY(id_classe) REFERENCES classe(id_classe),
    FOREIGN KEY(id_rarete) REFERENCES rarete(id_rarete)
);

CREATE TABLE IF NOT EXISTS mots_cles (
    id_mots_cles INTEGER AUTO_INCREMENT,
    nom VARCHAR(50),
    PRIMARY KEY(id_mots_cles)
);

CREATE TABLE IF NOT EXISTS mots_cles_carte (
    id_mots_cles INT,
    id_carte INT,
    PRIMARY KEY(id_mots_cles, id_carte),
    FOREIGN KEY(id_carte) REFERENCES carte(id_carte),
    FOREIGN KEY(id_mots_cles) REFERENCES mots_cles(id_mots_cles)
);

INSERT INTO classe (nom) VALUES 
('Chasseur de démons'),
('Mage'),
('Voleur'),
('Démoniste'),
('Guerrier');

INSERT INTO rarete (nom) VALUES 
('Commun'),
('Rare'),
('Épique'),
('Légendaire');

INSERT INTO carte (nom, descriptif, id_rarete, id_classe) VALUES 
('Démon belliqueux', 'Une fois que votre héros a attaqué, gagne +1 ATQ.', 1, 1),
('Boule de feu', 'Inflige 6 (point,points) de dégâts.', 1, 2),
('Attaque pernicieuse', 'Inflige 3 (point,points) de dégâts au héros adverse.', 2, 3),
('Néant distordu', 'Détruit tous les serviteurs.', 3, 4),
('Lame contrefaite', 'Cri de guerre : gagne un Râle d’agonie allié aléatoire déclenché pendant cette partie.', 3, 3),
('Geôlier gangrâme', 'Cri de guerre : votre adversaire se défausse d’un serviteur. Râle d’agonie : rend le serviteur défaussé.', 3, 4),
('Dame S''Theno', 'Insensible quand elle attaque. Une fois que vous avez lancé un sort, attaque l’adversaire aux PV les plus bas.', 4, 1),
('Canaille du port', 'Cri de guerre : vous piochez un Pirate.', 1, 5);

INSERT INTO mots_cles (nom) VALUES 
('Cri de guerre'),
('Râle d’agonie'),
('Insensible');

INSERT INTO mots_cles_carte (id_mots_cles, id_carte) VALUES 
(1,5),
(2,5),
(1,6),
(2,6),
(3,7),
(1,8);

COMMIT;
