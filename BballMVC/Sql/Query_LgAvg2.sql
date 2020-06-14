/****** Script for SelectTopNRows command from SSMS  ******/
SELECT -- 'Lg Avgs'
      [GameDate]
      ,[LgAvgStartDate]
      ,[LgAvgGamesBack]
      ,Round([LgAvgScoreFinal], 1) as LgAvg
     ,Round([LgAvgScoreAway] + [LgAvgScoreHome],1) as LgAvgReg
     ,Round([LgAvgScoreAway],1) as AwayReg
      ,Round([LgAvgScoreHome],1) as HomeReg

  FROM [00TTI_LeagueScores].[dbo].[DailySummary]
  where GameDate between '1/1/2019' and '4/1/2019' -- Getdate()