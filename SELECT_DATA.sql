-- от простого к сложному

USE MyCompany;

-- SELECT заптросы

SELECT * FROM company WHERE status LIKE 'Подряд%'; -- поиск
SELECT company_name FROM company WHERE status LIKE 'Подряд%';
SELECT company_name, usrle FROM company WHERE status LIKE 'Пос%'; -- поиск поставщиков
SELECT * FROM state s -- список всех сотрудников компаний
SELECT * FROM state WHERE profession_state LIKE 'ст%'; -- поиск по профессии 
SELECT * FROM state WHERE name_state LIKE 'Р%'; -- поиск по имени
SELECT * FROM company c WHERE id IN (1,2,3,4); -- вывод компании с извесными первичными ключами
SELECT SUM(sumprice_content_account) FROM content_account; -- сумма всех счетов
SELECT * FROM content_account ca ORDER BY name_content_account; -- сортировка по наименованию материалов 

DELETE FROM state WHERE status_state = 'Уволен'; -- удаление частичное в данном случае тот, кто уволен
DELETE FROM state WHERE status_state = 'Уволен' LIMIT 1; -- удаление с лимитом т.е. одного из уволенных.

SELECT id FROM company WHERE company_name = '"КЛАВА"'; -- поиск первичного ключа компании.
SELECT
	MAX(unitpricematerials_content_contract),
	MIN(unitpricematerials_content_contract) 
FROM content_contract
WHERE unitpricematerials_content_contract > 0; -- мак и мин. цена за материал по контракту

SELECT
	MAX(unitpricework_content_contract),
	MIN(unitpricework_content_contract) 
FROM content_contract
WHERE unitpricework_content_contract > 0; -- мак и мин. цены за работы 

SELECT CURRENT_DATE(); 


-- группировки 
SELECT status, company_name FROM company c ; -- выборка всех компаний и их статуса 
SELECT DISTINCT status FROM company c ; -- вывод уникальных значений статуса
SELECT status, status % 3 FROM  company c ORDER BY status % 3;
SELECT status, company_name FROM company c GROUP BY status, company_name;
SELECT status, company_name FROM company c GROUP BY status, company_name ORDER BY status;


-- Вложенные запросы. Какие контракты у компании "КЛАВА"?
SELECT 
id, name_contract, contract_id -- выводимые колонки
FROM contract c2 
WHERE contract_id IN
	(SELECT id FROM company WHERE company_name = '"КЛАВА"'); 


SELECT 
name_contract,
(SELECT id FROM company WHERE id = contract_id) AS 'rez'
FROM
contract c ; -- вывод id компаний которые связаны с котрактом

-- SELECT DAYOFYEAR(SELECT CURRENT_DATE());
SELECT DAYOFYEAR('2018-05-25');


-- Сложные запросы с использованием JOIN
SELECT * FROM state, company WHERE state.state_id = company.id;

-- вывод инф. о работников по профессий, фамилий и принадлежность к компаниям.
SELECT profession_state, surname_state, company.company_name 
FROM state, company 
WHERE state.state_id = company.id
ORDER BY profession_state, surname_state ;


-- представления (минимум 2);

CREATE OR REPLACE VIEW  account_v AS SELECT volume_content_account, unitprice_content_account, volume_content_account*unitprice_content_account AS sumprice FROM content_account;

SELECT * FROM account_v;

DROP VIEW IF EXISTS account_v;

CREATE OR REPLACE VIEW state_v AS SELECT profession_state, surname_state FROM state s2 
WHERE `status_state` = 'Работает'
WITH CHECK OPTION;

SELECT * FROM state_v;

DROP VIEW IF EXISTS state_v;






