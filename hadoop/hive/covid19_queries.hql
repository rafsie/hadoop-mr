-- a) liczba zakazonych w poszczegolnych kategoriach wiekowych w 2021 roku
SELECT kat_wiek, SUM(liczba_rap_zakazonych) AS liczba_zakazonych FROM zakazenia_orc
WHERE data_rap_zakazenia >= '2021-01-01' AND data_rap_zakazenia <= '2021-12-31'
GROUP BY kat_wiek
ORDER BY liczba_zakazonych DESC;

-- b) liczba zgonow w poszczegolnych kategoriach wiekowych w 2021 roku
SELECT kat_wiek, SUM(liczba_rap_zgonow) AS liczba_zgonow FROM zgony_orc
WHERE data_rap_zgonu >= '2021-01-01' AND data_rap_zgonu <= '2021-12-31'
GROUP BY kat_wiek
ORDER BY liczba_zgonow DESC;

-- c) liczba zakazonych wsrod w pe³ni zaszczepionych w poszczegolnych kategoriach wiekowych w 2021 roku
SELECT kat_wiek, SUM(liczba_rap_zakazonych) AS liczba_zakazonych FROM zakazenia_orc
WHERE dawka_ost = 'pelna_dawka' OR dawka_ost = 'przypominajaca' OR dawka_ost = 'uzupe³niaj¹ca'
AND data_rap_zakazenia >= '2021-01-01' AND data_rap_zakazenia <= '2021-12-31'
GROUP BY kat_wiek
ORDER BY liczba_zakazonych DESC;

-- d) liczba zgonow wsrod w pe³ni zaszczepionych w poszczegolnych kategoriach wiekowych w 2021 roku
SELECT kat_wiek, SUM(liczba_rap_zgonow) AS liczba_zgonow FROM zgony_orc
WHERE dawka_ost = 'pelna_dawka' OR dawka_ost = 'przypominajaca' OR dawka_ost = 'uzupe³niaj¹ca'
AND data_rap_zgonu >= '2021-01-01' AND data_rap_zgonu <= '2021-12-31'
GROUP BY kat_wiek
ORDER BY liczba_zgonow DESC;

-- e) liczba zgonow wsrod niezaszczepionych w poszczegolnych kategoriach wiekowych w 2021 roku
SELECT kat_wiek, SUM(liczba_rap_zgonow) AS liczba_zgonow FROM zgony_orc
WHERE dawka_ost = '' AND data_rap_zgonu >= '2021-01-01' AND data_rap_zgonu <= '2021-12-31'
GROUP BY kat_wiek
ORDER BY liczba_zgonow DESC;

-- f) liczba zgonow wsrod w pe³ni zaszczepionych w poszczegolnych kategoriach wiekowych w 2021 roku z uwzglednieniem producenta i dawki
SELECT kat_wiek, producent, dawka_ost, SUM(liczba_rap_zgonow) AS liczba_zgonow FROM zgony_orc
WHERE dawka_ost = 'pelna_dawka' OR dawka_ost = 'przypominajaca' OR dawka_ost = 'uzupe³niaj¹ca'
AND data_rap_zgonu >= '2021-01-01' AND data_rap_zgonu <= '2021-12-31'
GROUP BY kat_wiek, producent, dawka_ost
ORDER BY liczba_zgonow DESC;

-- g) liczba zakazen w poszczegolnych miesiacach (dane za 2022-02 niepelne!)
SELECT date_format(data_rap_zakazenia,'yyyy-MM') AS rok_miesiac, SUM(liczba_rap_zakazonych) AS liczba_zakazonych
FROM zakazenia_orc
GROUP BY date_format(data_rap_zakazenia,'yyyy-MM')
ORDER BY rok_miesiac;

-- h) liczba zgonow w poszczegolnych miesiacach (dane za 2022-02 niepelne!)
SELECT date_format(data_rap_zgonu,'yyyy-MM') AS rok_miesiac, SUM(liczba_rap_zgonow) AS liczba_zgonow
FROM zgony_orc
GROUP BY date_format(data_rap_zgonu,'yyyy-MM')
ORDER BY rok_miesiac;

-- i) liczba zgonow w poszczegolnych miesiacach z uwzglednieniem plci (dane za 2022-02 niepelne!)
SELECT date_format(data_rap_zgonu,'yyyy-MM') AS rok_miesiac, plec, SUM(liczba_rap_zgonow) AS liczba_zgonow
FROM zgony_orc
GROUP BY date_format(data_rap_zgonu,'yyyy-MM'), plec
ORDER BY rok_miesiac, liczba_zgonow DESC;

-- j) ilosc zachorowan z podzialem na wojewodztwa w 2021 roku
SELECT CASE WHEN teryt_woj = '02' THEN 'dolnoslaskie'
WHEN teryt_woj = '04' THEN 'kujawsko-pomorskie'
WHEN teryt_woj = '06' THEN 'lubelskie'
WHEN teryt_woj = '08' THEN 'lubuskie'
WHEN teryt_woj = '10' THEN 'lodzkie'
WHEN teryt_woj = '12' THEN 'malopolskie'
WHEN teryt_woj = '14' THEN 'mazowieckie'
WHEN teryt_woj = '16' THEN 'opolskie'
WHEN teryt_woj = '18' THEN 'podkarpackie'
WHEN teryt_woj = '20' THEN 'podlaskie'
WHEN teryt_woj = '22' THEN 'pomorskie'
WHEN teryt_woj = '24' THEN 'slaskie'
WHEN teryt_woj = '26' THEN 'swietokrzyskie'
WHEN teryt_woj = '28' THEN 'warminsko-mazurskie'
WHEN teryt_woj = '30' THEN 'wielkopolskie'
WHEN teryt_woj = '32' THEN 'zachodniopomorskie' 
ELSE 'nieznane'
END AS wojewodztwo, SUM(liczba_rap_zakazonych) AS liczba_zakazonych
FROM zakazenia_orc
WHERE data_rap_zakazenia >= '2021-01-01' AND data_rap_zakazenia <= '2021-12-31'
GROUP BY teryt_woj
ORDER BY liczba_zakazonych DESC;

-- k) ilosc zgonow i mediana wieku a ilosc przyjetych dawek szczepionki
SELECT IF(LENGTH(TRIM(dawka_ost)) = 0,'brak', dawka_ost) AS dawka, (PERCENTILE(CAST((wiek*1000000) AS BIGINT), 0.5))/1000000 AS med_wieku, 
SUM(liczba_rap_zgonow) AS liczba_zgonow 
FROM zgony_orc
GROUP BY dawka_ost
ORDER BY liczba_zgonow DESC;

-- l) wplyw obnizonej odpornosci na zakazenie
SELECT CASE WHEN obniz_odpornosc = '0' THEN 'nie'
WHEN obniz_odpornosc = '1' THEN 'tak'
END AS obniz_odpornosc, SUM(liczba_rap_zakazonych) AS liczba_zakazonych FROM zakazenia_orc
GROUP BY obniz_odpornosc
ORDER BY liczba_zakazonych DESC;

-- m) wplyw chorob wspolistniejacych i obnizonej odpornosci na zgon
SELECT obniz_odpornosc, czy_wspolistniejace, sum(liczba_rap_zgonow) AS liczba_zgonow FROM zgony_orc
GROUP BY obniz_odpornosc, czy_wspolistniejace
ORDER BY liczba_zgonow DESC;

-- n) dawka, obnizona odpornosc, choroby wspolistniejace, mediana wieku a liczba zgonow
SELECT IF(LENGTH(TRIM(dawka_ost)) = 0,'brak', dawka_ost) AS dawka, obniz_odpornosc, czy_wspolistniejace, 
(PERCENTILE(CAST((wiek*1000000) AS BIGINT), 0.5))/1000000 AS med_wieku, 
SUM(liczba_rap_zgonow) AS liczba_zgonow 
FROM zgony_orc
GROUP BY dawka_ost, obniz_odpornosc, czy_wspolistniejace
ORDER BY liczba_zgonow DESC;