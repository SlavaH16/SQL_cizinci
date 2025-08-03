--- Pocet cizincu celkem v CR ---

SELECT count(idhod) AS pocet_cizincu_v_CR
FROM ciz24 c 
WHERE c.kraj_kod IS NOT NULL;

--- Pocty cizincu v CR v jednotlivych krajich za jednotlive roky ---

CREATE TABLE Pocet_ciz_v_krajich_2024 AS
SELECT kraj, count(idhod) AS pocet_cizincu
FROM ciz24 c
WHERE c.kraj_kod IS NOT NULL
GROUP BY kraj
ORDER BY count(idhod) DESC;

CREATE TABLE Pocet_ciz_v_krajich_2023 AS
SELECT kraj_txt, count(idhod) AS pocet_cizincu
FROM ciz23 c
WHERE c.kraj_kod IS NOT NULL
GROUP BY kraj_txt
ORDER BY count(idhod) DESC;

--- Pocty cizincu v CR, dle kraju - srovnani 2023 a 2024 ---

SELECT 
pc23.kraj_txt AS KRAJ,
pc23.pocet_cizincu AS POCET_CIZINCU_2023,
pc24.pocet_cizincu AS POCET_CIZINCU_2024
FROM Pocet_ciz_v_krajich_2023 pc23
	LEFT JOIN pocet_ciz_v_krajich_2024 pc24
	ON pc23.kraj_txt = pc24.kraj;

--- 20 nejcastejsich narodnosti cizincu v CR v roce 2024 ---

SELECT 
c.stobcan AS NARODNOST,
COUNT(c.idhod) AS POCET_CIZINCU
FROM ciz24 c
WHERE c.stobcan <> ''
GROUP BY narodnost 
ORDER BY pocet_cizincu DESC
LIMIT 20;

--- Pocty cizincu v okresech - 30 nejvetsich ----

SELECT 
c.vuzemi AS OKRES,
count(idhod) AS POCET_CIZINCU
FROM ciz24 c
WHERE c.vuzemi_kod != 19 AND 9999
GROUP BY c.vuzemi 
ORDER BY count(idhod) DESC
LIMIT 30;

--- Narodnosti cizincu v nejvetsim okrese (Praha) ---

SELECT 
c.stobcan AS NARODNOST,
count(idhod) AS POCET_CIZINCU
FROM ciz24 c
WHERE c.vuzemi_kod = 40924 AND c.stobcan <> ''
GROUP BY narodnost 
ORDER BY count(idhod) DESC, narodnost;

--- Podpurne tabulky pro srovnani 3 nejcetnejsich narodnosti a jejich zastoupeni dle kraju ---

CREATE TABLE Ukrajina_kraj AS 
SELECT
c.kraj AS KRAJ,
COUNT(c.idhod) AS UKRAJINA
FROM ciz24 c
WHERE c.stobcan = "Ukrajina" AND c.kraj  <> ''
GROUP BY c.kraj
ORDER BY count(c.idhod) DESC;

CREATE TABLE Slovensko_kraj AS 
SELECT
c.kraj AS KRAJ,
COUNT(c.idhod) AS SLOVENSKO
FROM ciz24 c
WHERE c.stobcan = "Slovensko" AND c.kraj  <> ''
GROUP BY c.kraj
ORDER BY count(c.idhod) DESC;

CREATE TABLE Vietnam_kraj AS 
SELECT
c.kraj AS KRAJ,
COUNT(c.idhod) AS VIETNAM
FROM ciz24 c
WHERE c.stobcan = "Vietnam" AND c.kraj  <> ''
GROUP BY c.kraj
ORDER BY count(c.idhod) DESC;
 
--- Srovnani 3 nejcetnejsich narodnosti a jejich zastoupeni dle kraju ---

SELECT
uk.KRAJ AS KRAJ,
uk.UKRAJINA AS UKRAJINA,
sk.SLOVENSKO AS SLOVENSKO,
vk.VIETNAM AS VIETNAM
FROM ukrajina_kraj uk 
	LEFT JOIN slovensko_kraj sk 
	ON uk.KRAJ = sk.KRAJ 
	LEFT JOIN vietnam_kraj vk 
	ON uk.KRAJ = vk.KRAJ;

