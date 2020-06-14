/****** Script for SelectTopNRows command from SSMS  ******/
SELECT round(Avg([LgAvgScoreAway] + [LgAvgScoreHome]), 1) LgAvg
  FROM [00TTI_LeagueScores].[dbo].[DailySummary]
  where gameDate > '11/1/2019'


  SELECT 
	LeagueName,	Season, GameType, Round(Avg(ScReg+ScRegOpp),1) as AvgSc
	FROM [00TTI_LeagueScores].[dbo].[V1_BoxScores]
	where GameType in ('1-Reg', '2-Post')
   Group By LeagueName, Season, GameType
   Order By LeagueName, Season, GameType
