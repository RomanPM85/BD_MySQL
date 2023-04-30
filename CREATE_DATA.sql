/*Требования проекту:
+ Составить общее текстовое описание БД и решаемых ею задач;
+ минимальное количество таблиц - 10;
+ скрипты создания структуры БД (с первичными ключами, индексами, внешними ключами);
+ создать ERDiagram для БД;
+ скрипты наполнения БД данными;
+ скрипты характерных выборок (включающие группировки, JOIN'ы, +вложенные таблицы);
+ представления (минимум 2);
хранимые процедуры / триггеры;
*/


DROP DATABASE IF EXISTS MyCompany;
CREATE DATABASE MyCompany;
USE MyCompany;

DROP TABLE IF EXISTS company;
CREATE TABLE company (
    id SERIAL, 
    status ENUM('Инвестор', 'Заказчик', 'Ген.Подрядчик', 'Ген.проектировщик', 'Подрядчик', 'Субподрядчик', 'Поставщик'),
    legformcomp ENUM('ИП', 'ООО', 'ЗАО', 'ОАО', 'АО' ), -- legal form of the company    
    company_name VARCHAR(50)COMMENT 'Наименование компании',
    taxidnum BIGINT UNSIGNED  COMMENT 'ИНН', -- taxpayer identification number
    usrle BIGINT UNSIGNED  COMMENT 'ЕГРЮЛ' -- Unified state register of legal entities
	
) COMMENT 'компании';

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
    id SERIAL,
	-- profiles_id bigint unsigned NOT NULL,
    Regdate DATE,
    actual_address VARCHAR(200),
    legal_address VARCHAR(200),
    authorized_capital BIGINT UNSIGNED,
    
	CONSTRAINT `profiles_idfk` FOREIGN KEY (`id`) REFERENCES `company` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) COMMENT 'Карточка компании';

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL,
	from_company_id BIGINT UNSIGNED NOT NULL,
	to_company_id BIGINT UNSIGNED NOT NULL,
	reference_number VARCHAR(10),
	title_messages VARCHAR(50),
	Regdate DATE,
	Message_note VARCHAR(50),
	
	FOREIGN KEY (from_company_id) REFERENCES `company` (`id`),
    FOREIGN KEY (to_company_id) REFERENCES `company` (`id`),
	CHECK (from_company_id <> to_company_id)
    
) COMMENT 'исх.письма, передача документов и т.д.';

DROP TABLE IF EXISTS messages_body;
CREATE TABLE messages_body (
	id SERIAL,
	-- messages_body_id BIGINT UNSIGNED NOT NULL,
	body TEXT,
	
	-- FOREIGN KEY (messages_body_id) REFERENCES `messages` (`id`)
	FOREIGN KEY (`id`) REFERENCES `messages` (`id`)
) COMMENT 'содержание письма, документа';


DROP TABLE IF EXISTS state;
CREATE TABLE state (
	-- id SERIAL,
	state_id BIGINT UNSIGNED NOT NULL,
	profession_state VARCHAR(100),
	surname_state VARCHAR(50),
	name_state VARCHAR(50),
    patronymic_state VARCHAR(50),
	email_state VARCHAR(100) UNIQUE,
    phone_state VARCHAR(50) UNIQUE,
    status_state ENUM('Работает', 'Уволен'),
    
    CONSTRAINT `state_idfk` FOREIGN KEY (`state_id`) REFERENCES `company` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
    
    INDEX state_idx(surname_state, name_state, patronymic_state, profession_state, status_state)
) COMMENT 'сотрудники компании';


    
DROP TABLE IF EXISTS constructions;
CREATE TABLE constructions (
	id SERIAL,
	-- constructions_id BIGINT UNSIGNED NOT NULL,
	status_constructions ENUM('Строится', 'Проект', 'Завершен') COMMENT 'стадия строительства', 
	num_constructions VARCHAR(100) COMMENT 'шифр объекта',
	name_constructions VARCHAR(100) NOT NULL COMMENT 'наименование объекта',
	address_constructions VARCHAR(100),
	
	CONSTRAINT `constructions_idfk` FOREIGN KEY (`id`) REFERENCES `company` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
	
	INDEX constructions_idx(status_constructions, num_constructions, name_constructions)
) COMMENT 'объекты строительства';

DROP TABLE IF EXISTS materials;
CREATE TABLE materials (
	id SERIAL,
	materials_id BIGINT UNSIGNED NOT NULL,
	name_materials VARCHAR(100),
	article_materials VARCHAR(100),
	unit_materials VARCHAR(100),
	volume_materials DECIMAL(10,2),
	
	CONSTRAINT `materials_idfk` FOREIGN KEY (`materials_id`) REFERENCES constructions(`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
	-- CONSTRAINT `materials__constructions_idfk` FOREIGN KEY (`id`) REFERENCES constructions(`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
	INDEX materials_idx(name_materials, article_materials)
);

DROP TABLE IF EXISTS contract;
CREATE TABLE contract (
	id SERIAL,
	contract_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
	constructions_id BIGINT UNSIGNED NOT NULL,
	status_contract ENUM('КП', 'Подписан', 'Завершен') NOT NULL, -- смета
	Regdate DATE NOT NULL,
	num_contract VARCHAR(100),
	name_contract VARCHAR(100) NOT NULL,
	system_section VARCHAR(100) NOT NULL,
	
	CONSTRAINT `contract_idfk_1` FOREIGN KEY (`contract_id`) REFERENCES company(`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT `contract_idfk_2` FOREIGN KEY (`constructions_id`) REFERENCES constructions(`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
	INDEX contract_idx(status_contract, Regdate, num_contract, name_contract, system_section)
	) COMMENT 'сметы';

DROP TABLE IF EXISTS content_contract;
CREATE TABLE content_contract (
	id SERIAL,
	content_contract_id BIGINT UNSIGNED NOT NULL,
	name_content_contract VARCHAR(100) NOT NULL,
	article_content_contract VARCHAR(100),
	unit_content_contract VARCHAR(100) NOT NULL,
	volume_content_contract DECIMAL(10,2) NOT NULL,
	unitpricework_content_contract DECIMAL(10,2),
	unitpricematerials_content_contract DECIMAL(10,2),
	
	CONSTRAINT `contract_idfk` FOREIGN KEY (`content_contract_id`) REFERENCES contract(`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
	INDEX content_contract_idx(name_content_contract, article_content_contract)
	
) COMMENT 'содержание смет';

/*
DROP TABLE IF EXISTS executioncontract;
CREATE TABLE executioncontract (
	id SERIAL,
	executioncontract_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
	name_executioncontract VARCHAR(100) NOT NULL,
	article_executioncontract VARCHAR(100),
	unit_executioncontract VARCHAR(100) NOT NULL,
	volume_executioncontract DECIMAL(10,2) NOT NULL	
	
	CONSTRAINT `contract_idfk` FOREIGN KEY (`executioncontract_id`) REFERENCES contract(`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
	INDEX content_contract_idx(name_content_contract, article_content_contract)
	
);
*/

DROP TABLE IF EXISTS account;
CREATE TABLE account (
	id SERIAL,
	account_id BIGINT UNSIGNED NOT NULL,
	from_company_account_id BIGINT UNSIGNED NOT NULL,
	to_company_account_id BIGINT UNSIGNED NOT NULL,
	reference_number VARCHAR(30),
	Regdate DATE NOT NULL,
	status_contract ENUM('Оплачен', 'Неоплачен') NOT NULL, -- статус счета
	
	CONSTRAINT `account_idfk_1` FOREIGN KEY (`account_id`) REFERENCES contract(`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (from_company_account_id) REFERENCES `company` (`id`),
    FOREIGN KEY (to_company_account_id) REFERENCES `company` (`id`),
    
	INDEX account_idx(reference_number, status_contract)

) COMMENT 'реестр счетов';

DROP TABLE IF EXISTS content_account;
CREATE TABLE content_account (
	id SERIAL,
	content_account_id BIGINT UNSIGNED NOT NULL,
	name_content_account VARCHAR(100) NOT NULL,
	article_content_account VARCHAR(100),
	unit_content_account VARCHAR(100) NOT NULL,
	volume_content_account DECIMAL(10,2) NOT NULL,	
	unitprice_content_account DECIMAL(10,2) NOT NULL,
	sumprice_content_account DECIMAL(10,2) NOT NULL,
	
	CONSTRAINT `content_account_id_idfk_1` FOREIGN KEY (`content_account_id`) REFERENCES account(`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
	INDEX content_account_idx(name_content_account, unitprice_content_account)
	
) COMMENT 'содержание счета';


