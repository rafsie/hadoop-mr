CREATE DATABASE covid19;

CREATE TABLE IF NOT EXISTS covid19.zakposzczep_csv(
  data_rap_zakazenia DATE,
  teryt_woj STRING,
  teryt_pow STRING,
  plec STRING,
  wiek FLOAT,
  kat_wiek STRING,
  producent STRING,
  dawka_ost STRING,
  obniz_odpornosc INT,
  liczba_rap_zakazonych INT)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count" = "1");

CREATE TABLE IF NOT EXISTS covid19.zgonposzczep_csv(
  data_rap_zgonu DATE,
  teryt_woj STRING,
  teryt_pow STRING,
  plec STRING,
  wiek FLOAT,
  kat_wiek STRING,
  czy_wspolistniejace INT,
  producent STRING,
  dawka_ost STRING,
  obniz_odpornosc INT,
  liczba_rap_zgonow INT)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count" = "1");

CREATE TABLE zakazenia_orc STORED AS ORC AS SELECT * FROM zakposzczep_csv;
CREATE TABLE zgony_orc STORED AS ORC AS SELECT * FROM zgonposzczep_csv;