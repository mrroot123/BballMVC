/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
 [LeagueName]
      ,[Season]
		, count(*) as Games
  FROM [00TTI_LeagueScores].[dbo].[xxxV1_BoxScores]
  Group by  [LeagueName]  ,[Season]
  Order by  [LeagueName]  ,[Season]