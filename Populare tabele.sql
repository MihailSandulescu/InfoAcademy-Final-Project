CALL tabele();

-- am folosit innodb_autoinc_lock_mode = 0 in my.ini, pentru a obtine valori consecutive cu auto_increment la insert ignore

LOAD DATA INFILE 'C:/wt/nume_fisier.txt'
	INTO TABLE Tabela_veche
    FIELDS TERMINATED BY ';'
    ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    (data, ora, nume, prenume, tip_op, suma, sucursala);


CALL rapoarte();