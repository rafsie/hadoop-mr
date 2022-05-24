CREATE DATABASE bank;

CREATE TABLE IF NOT EXISTS bank.bank_full_train_csv(
	age INT,
	job STRING,
	marital STRING,
	education STRING,
	default STRING,
	balance INT,
	housing STRING,
	loan STRING,
	contact STRING,
	day INT,
	month STRING,
	duration INT,
	campaign INT,
	pdays INT,
	previous INT, 
	poutcome STRING,
	term_deposit STRING)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count" = "1");

CREATE TABLE IF NOT EXISTS bank.bank_test_csv(
	age INT,
	job STRING,
	marital STRING,
	education STRING,
	default STRING,
	balance INT,
	housing STRING,
	loan STRING,
	contact STRING,
	day INT,
	month STRING,
	duration INT,
	campaign INT,
	pdays INT,
	previous INT, 
	poutcome STRING,
	term_deposit STRING)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count" = "1");

CREATE TABLE train_orc STORED AS ORC
AS SELECT ROW_NUMBER() OVER() AS id, age, job, marital, education, default, balance, 
housing, loan, contact, day, month, duration, campaign, pdays, previous, poutcome, 
CAST(CASE WHEN term_deposit = 'yes' THEN 1 ELSE 0 END AS INT) AS term_deposit
FROM bank_full_train_csv;

CREATE TABLE test_orc STORED AS ORC
AS SELECT ROW_NUMBER() OVER() AS id, age, job, marital, education, default, balance, 
housing, loan, contact, day, month, duration, campaign, pdays, previous, poutcome, 
CAST(CASE WHEN term_deposit = 'yes' THEN 1 ELSE 0 END AS INT) AS term_deposit
FROM bank_test_csv;