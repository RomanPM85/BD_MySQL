-- хранимые процедуры / триггеры;
USE MyCompany;

DROP PROCEDURE IF EXISTS my_version;

DELIMITER //
CREATE PROCEDURE my_version ()
BEGIN
  SELECT VERSION();
END

DELIMITER //
CREATE PROCEDURE state_v_proc ()
BEGIN
  SELECT * FROM state_v;
END


CALL my_version();
CALL state_v_proc();

SHOW PROCEDURE STATUS LIKE 'my%';
SHOW PROCEDURE STATUS LIKE 's%';



-- функции 
DELIMITER //
CREATE FUNCTION get_version ()
RETURNS TEXT DETERMINISTIC
BEGIN
	RETURN VERSION ();
END

SELECT get_version();

DELIMITER //
CREATE PROCEDURE set_x (IN value INT)
BEGIN
	SET @x = value;
END//

CALL set_x(100);
SELECT @x;


-- триггеры
DELIMITER //
CREATE TRIGGER constructions_count AFTER INSERT ON constructions
FOR EACH ROW 
BEGIN 
	SELECT COUNT(*) INTO @total FROM constructions; 
END

INSERT IGNORE constructions (status_constructions, num_constructions, name_constructions, address_constructions)
VALUES 
('Проект', '555', 'Триггер1', 'Москва');

SELECT * FROM constructions;
SELECT @total;
SHOW TRIGGERS;
