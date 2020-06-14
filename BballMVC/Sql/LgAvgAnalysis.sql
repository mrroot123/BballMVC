/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
min(GameDate) as StartDate, count(*) as Games
     , Round(Avg(ScoreReg), 2) as ScoreReg
     ,Round(Avg([ScoreOT]), 2) as ScoreFinal
  FROM
   (Select top 50 * from  [00TTI_LeagueScores].[dbo].[BoxScores]
   order by GameDate desc) x
union
	SELECT 
min(GameDate) as StartDate, count(*) as Games
     , Round(Avg(ScoreReg), 2) as ScoreReg
     ,Round(Avg([ScoreOT]), 2) as ScoreFinal
  FROM
   (Select top 100 * from  [00TTI_LeagueScores].[dbo].[BoxScores]
   order by GameDate desc) x
union

SELECT 
	min(GameDate) as StartDate, count(*) as Games
     , Round(Avg(ScoreReg), 2) as ScoreReg
     ,Round(Avg([ScoreOT]), 2) as ScoreFinal
  FROM
   (Select top 200 * from  [00TTI_LeagueScores].[dbo].[BoxScores]
   order by GameDate desc) x
union

SELECT 
	min(GameDate) as StartDate, count(*) as Games
     , Round(Avg(ScoreReg), 2) as ScoreReg
     ,Round(Avg([ScoreOT]), 2) as ScoreFinal
  FROM
   (Select top 300 * from  [00TTI_LeagueScores].[dbo].[BoxScores]
   order by GameDate desc) x
