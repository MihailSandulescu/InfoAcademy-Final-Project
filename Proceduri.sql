DROP DATABASE proiect;
CREATE DATABASE IF NOT EXISTS proiect;
USE proiect;

DELIMITER %

CREATE PROCEDURE tabele()
DETERMINISTIC

BEGIN

SET foreign_key_checks = 0;
DROP TABLES IF EXISTS Clienti, Sucursale, Tipul_operatiunii, Operatiuni, Tabela_veche;

CREATE TABLE Clienti(
					  idc INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                      nume VARCHAR(100),
                      prenume VARCHAR(100),
                      UNIQUE c1(nume, prenume)
					);

CREATE TABLE Sucursale(
						ids INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                        sucursala VARCHAR(100),
                        UNIQUE s1(sucursala)
					  );
                      
CREATE TABLE Tipul_operatiunii(
								idto INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                tip_op ENUM('Extragere cash', 'Depunere cash', 'Plata cu OP', 'Incasare cu OP', 'Salariu', 'Credit'),
                                UNIQUE t1(tip_op)
							  );
                              
CREATE TABLE Operatiuni(
						 ido INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                         data_ora DATETIME,
                         id_cl INT NOT NULL,
                         id_suc INT NOT NULL,
                         id_tipop INT NOT NULL,
                         suma INT, 
                         FOREIGN KEY (id_cl) REFERENCES Clienti(idc),
                         FOREIGN KEY (id_suc) REFERENCES Sucursale(ids),
                         FOREIGN KEY (id_tipop) REFERENCES Tipul_operatiunii(idto)
                         );

CREATE TABLE Tabela_veche(
						  data CHAR(10),
                          ora CHAR(10),
                          nume VARCHAR(100),
                          prenume VARCHAR(100),
                          tip_op ENUM('Extragere cash', 'Depunere cash', 'Plata cu OP', 'Incasare cu OP', 'Salariu', 'Credit'),
                          suma INT,
                          sucursala VARCHAR(100),
                          fulldate DATETIME
                          );

SET foreign_key_checks = 1;

END%

-- cursor pentru popularea tabelelor, alternativa la triggerul fill_from_veche

DELIMITER $

CREATE PROCEDURE populeaza_tabele()
DETERMINISTIC

BEGIN

DECLARE vdata, vora CHAR(10);
DECLARE vnume, vprenume, vsuc VARCHAR(100);
DECLARE vtip_op ENUM('Extragere cash', 'Depunere cash', 'Plata cu OP', 'Incasare cu OP', 'Salariu', 'Credit');
DECLARE vsuma, vidc, vidsuc, vidtip INT;
DECLARE vfulld DATETIME;

DECLARE stop_cursor CONDITION FOR 1329;
DECLARE crt_row CURSOR FOR
				SELECT *
                FROM Tabela_veche;
DECLARE EXIT HANDLER FOR stop_cursor BEGIN END;

SET foreign_key_checks = 0;

OPEN crt_row;

LOOP

FETCH crt_row INTO vdata, vora, vnume, vprenume, vtip_op, vsuma, vsuc, vfulld;

INSERT IGNORE INTO Clienti(nume, prenume) VALUES(vnume, vprenume);

SELECT idc
FROM Clienti
WHERE nume = vnume AND prenume = vprenume
INTO vidc;

INSERT IGNORE INTO Sucursale(sucursala) VALUES(vsuc);

SELECT ids
FROM Sucursale
WHERE vsuc = sucursala
INTO vidsuc;

INSERT IGNORE INTO Tipul_operatiunii(tip_op) VALUES(vtip_op);

SELECT idto
FROM Tipul_operatiunii
WHERE tip_op = vtip_op
INTO vidtip;

INSERT IGNORE INTO Operatiuni(data_ora, id_cl, id_suc, id_tipop, suma) VALUES(vfulld, vidc, vidsuc, vidtip, vsuma);

END LOOP;

SET foreign_key_checks = 1;
CLOSE crt_row;

END$

DELIMITER %

CREATE PROCEDURE rapoarte()
DETERMINISTIC

BEGIN

DECLARE vids, vidop INT;

SELECT CONCAT_WS(' ', nume, prenume) AS `Client`, SUM(suma) AS `Sold final`
FROM operatiuni JOIN clienti ON id_cl = idc
GROUP BY `Client`;

SELECT CONCAT_WS(' ', nume, prenume) AS `Client`
FROM clienti JOIN operatiuni ON idc = id_cl
			 JOIN sucursale ON id_suc = ids
WHERE sucursala = 'Hawai'
GROUP BY `Client`
ORDER BY COUNT(*) DESC
LIMIT 1;

SELECT sucursala
FROM sucursale JOIN operatiuni ON ids = id_suc
			   JOIN tipul_operatiunii ON id_tipop = idto
WHERE tip_op = 'Depunere cash' OR tip_op = 'Extragere cash'
GROUP BY sucursala
ORDER BY COUNT(*) DESC
LIMIT 1;

SELECT CONCAT_WS(' ', nume, prenume) AS `Client`, sucursala, SUM(suma) AS `Incasari din salarii`
FROM clienti JOIN operatiuni ON idc = id_cl
			 JOIN tipul_operatiunii ON id_tipop = idto
             JOIN sucursale ON id_suc = ids
GROUP BY `Client`
HAVING SUM(suma) > 12000
ORDER BY sucursala;

SELECT tip_op AS Operatiune, sucursala, COUNT(*) AS `Numar de efectuari`
FROM tipul_operatiunii JOIN operatiuni ON idto = id_tipop
					   JOIN sucursale ON id_suc = ids
GROUP BY tip_op, sucursala;

SELECT sucursala AS `Sucursala`, CONCAT_WS(' ', nume, prenume) AS `Client`, tip_op AS `Operatiune`, data_ora AS `Data`
FROM sucursale JOIN operatiuni ON ids = id_suc
			   JOIN clienti ON id_cl = idc
               JOIN tipul_operatiunii ON id_tipop = idto
WHERE nume = 'Tilley' AND prenume = 'Scott' OR nume = 'Dupuis' AND prenume = 'Glenn'
GROUP BY `Sucursala`, `Client`, `Operatiune`;

SELECT ids FROM sucursale WHERE sucursala = 'Miami' INTO vids;
SELECT idto FROM tipul_operatiunii WHERE tip_op = 'Incasare cu OP' INTO vidop;

SELECT MAX(suma) AS `Incasare maxima`
FROM operatiuni
WHERE id_suc = vids 
	  AND id_tipop = vidop 
      AND MONTH(data_ora) = 5
      AND YEAR(data_ora) = 2016;

END %

DELIMITER ;
