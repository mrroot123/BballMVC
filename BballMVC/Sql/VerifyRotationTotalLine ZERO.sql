/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TotalLine, OpenTotalLine, SideLine, *
  FROM [00TTI_LeagueScores].[dbo].[Rotation]
  where TotalLine < 100 AND GameDate < GetDate() and GameDate > '7/1/2020' and Canceled = 0 
  order by LeagueName, gamedate desc