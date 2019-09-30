DELIMITER %

CREATE FUNCTION format_data(ziua TEXT, ora TEXT)
    RETURNS DATETIME
    DETERMINISTIC
COMMENT 'Functia asigura faptul ca ca data returnata nu depaseste data curenta (str_to_date simplu ar fi convertit 31 la 2031, de exemplu)'
BEGIN

DECLARE var DATE;

SELECT str_to_date(ziua, '%y:%m:%d') INTO var;

IF YEAR(var) > YEAR(curdate()) THEN
	SET var = var - INTERVAL 100 YEAR;
END IF; 

RETURN concat(var, ' ', str_to_date(ora, '%H.%i.%S'));

END %

DELIMITER ;