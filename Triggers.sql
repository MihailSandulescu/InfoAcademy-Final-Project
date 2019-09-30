DELIMITER %

CREATE TRIGGER fill_fulldate BEFORE INSERT
ON Tabela_veche FOR EACH ROW

BEGIN

SET NEW.fulldate = format_data(NEW.data, NEW.ora);

END%

DELIMITER $

CREATE TRIGGER fill_from_veche BEFORE INSERT
ON Tabela_veche FOR EACH ROW

BEGIN

DECLARE vidc, vidsuc, vidtip INT;

INSERT IGNORE INTO Clienti(nume, prenume) VALUES(NEW.nume, NEW.prenume);

SELECT idc
FROM Clienti
WHERE nume = NEW.nume AND prenume = NEW.prenume
INTO vidc;

INSERT IGNORE INTO Sucursale(sucursala) VALUES(NEW.sucursala);

SELECT ids
FROM Sucursale
WHERE  sucursala = NEW.sucursala
INTO vidsuc;

INSERT IGNORE INTO Tipul_operatiunii(tip_op) VALUES(NEW.tip_op);

SELECT idto
FROM Tipul_operatiunii
WHERE tip_op = NEW.tip_op
INTO vidtip;

INSERT INTO Operatiuni(data_ora, id_cl, id_suc, id_tipop, suma) VALUES(NEW.fulldate, vidc, vidsuc, vidtip, NEW.suma);

END$

DELIMITER ;
