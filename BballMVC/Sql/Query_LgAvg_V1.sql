SELECT TOP 300 Count(*) as RC
	, (avg(ScReg + ScRegOpp) / avg(ScOT + ScOTOpp)) AS OTfactor
	,    avg(FGM2PT) AS Avg2PT
	, avg(FGM2PTopp) AS Avg2PTOpp
	,    avg(FGM3PT) AS Avg3PT
	, avg(FGM3PTopp) AS Avg3PTOpp
	,     avg(FTM) AS AvgFTM
	, avg(FTMopp) AS AvgFTMOpp
	,    avg(FGA2PT) AS Avg2PTa
	, avg(FGA2PTopp) AS Avg2PTaOpp
	,    avg(FGA3PT) AS Avg3PTa
	, avg(FGA3PTopp) AS Avg3PTaOpp
	,     avg(FTA) AS AvgFTa
	, avg(FTAopp) AS AvgFTaOpp   
	, Min(Date) AS StartDate  
	, Max(Date) AS EndDate  
	, avg(ScReg + ScRegOpp) as AvgScore  
	, avg(ScOT + ScOTOpp) as AvgFinal 
	FROM (
	SELECT TOP 300 * 
	 FROM V1_BoxScores  
WHERE LeagueName = 'NBA'  
	AND H_A = 'Away'  
	AND [Date] < '1/1/2019'
	AND  GameType = '1-Reg'
	Order by [Date] desc
	) x

/*
 FROM V1_BoxScores  
WHERE LeagueName = 'NBA'  
	AND H_A = 'Away'  
	AND [Date] > '1/1/2019'
	AND  GameType = '1-Reg'
	Order by [Date] desc


	SELECT TOP 300 * 
	 FROM V1_BoxScores  
WHERE LeagueName = 'NBA'  
	AND H_A = 'Away'  
	AND [Date] < '1/1/2019'
	AND  GameType = '1-Reg'
	Order by [Date] desc

	*/