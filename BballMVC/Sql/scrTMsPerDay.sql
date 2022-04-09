/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (10)[GameDate], count(*) as Games
  FROM [00TTI_LeagueScores].[dbo].[TodaysMatchups]
  group by GameDate
  order by GameDate desc

  SELECT TOP (10 ) r.[GameDate], count(*)/2 as Games
  FROM Rotation r
  group by r.GameDate
  order by r.GameDate desc

