-- Neste exemplo tive que complicar para praticar com datas e cast,deixei tudo explicito
WITH PerfMensal AS
(
	SELECT 
		P.COD_DIA,
		P.COD_MES,
		MONTH(CAST (P.COD_DIA AS Date)) AS MES,
		YEAR(CAST (P.COD_DIA AS Date)) AS ANO,
		P.COD_SUBLINEA,
		(24 * P.UTDISPONIBLESTD * P.UTNETASTD)/10000 AS TnetoProg,
		P.PRODORIGINAL * 24 AS ProdProg
	FROM FactProdPerf AS P
	WHERE P.COD_SUBLINEA = 'B72'
),
PnetaMensal AS
(
	SELECT
		PM.COD_MES,
		SUM(PM.ProdProg)/SUM(PM.TnetoProg) AS PnetaProg
	FROM PerfMensal PM
	GROUP BY PM.COD_MES
),
PerfDem AS
(
	SELECT 
		D.COD_MES,
		D.DES_SUBCONCEPTO,
		D.HRSREALMENSUAL,
		PM.PnetaProg
	FROM FactDemoras D
		LEFT JOIN PnetaMensal PM ON (D.COD_MES = PM.COD_MES)
	WHERE D.COD_SUBLINEA = 'B72'
)
SELECT
	PD.COD_MES,
	PD.DES_SUBCONCEPTO,
	PD.HRSREALMENSUAL,
	SUM(PD.HRSREALMENSUAL) OVER (PARTITION BY PD.COD_MES ORDER BY PD.HRSREALMENSUAL DESC) AS CumDemora,
	PD.PnetaProg
FROM PerfDem PD
WHERE PD.HRSREALMENSUAL > 0
;








--- RASCUNHOS

SELECT * FROM PnetaMensal;


SELECT MONTH(CAST ('20210701' AS Date)) AS Mes;


SELECT CAST (D.COD_DIA AS Date) AS DIA FROM FactDemoras D;

SELECT ISDATE (P.COD_DIA) FROM FactProdPerf P;

SELECT * FROM FactDemoras;