CREATE 
	ALGORITHM = MERGE
VIEW Old_table(datav, orav, numev, prenumev, tip_ov, sumv, sucv) AS
	SELECT DATE(data_ora), TIME(data_ora), nume, prenume, tip_op, suma, sucursala
    FROM sucursale JOIN operatiuni ON ids = id_suc
				   JOIN clienti ON id_cl = idc
                   JOIN tipul_operatiunii ON id_tipop = idto;
                   

