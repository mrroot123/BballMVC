/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (20)  GameDate
      ,NumOfMatchups
      ,LgAvgGamesBackActual
      ,Round(LgAvgScoreAway,1) as LgAvgScoreAway
      ,Round(LgAvgScoreHome,1) as LgAvgScoreHome
      ,Round(LgAvgScoreAway+LgAvgScoreHome,1) as LgAvgScoreReg
      ,Round(LgAvgScoreFinal,1) as LgAvgScoreFinal
      ,Round(LgAvgTotalLine,1) as LgAvgTotalLine
/*
      ,LgAvgScoreFinal
      ,LgAvgTotalLine
      ,LgAvgShotsMadeAwayPt1
      ,LgAvgShotsMadeAwayPt2
      ,LgAvgShotsMadeAwayPt3
      ,LgAvgShotsMadeHomePt1
      ,LgAvgShotsMadeHomePt2
      ,LgAvgShotsMadeHomePt3
      ,LgAvgLastMinPts
      ,LgAvgLastMinPt1
      ,LgAvgLastMinPt2
      ,LgAvgLastMinPt3
      ,LgAvgTurnOversAway
      ,LgAvgTurnOversHome
      ,LgAvgOffRBAway
      ,LgAvgOffRBHome
      ,LgAvgAssistsAway
      ,LgAvgAssistsHome
      ,LgAvgPace
      ,LgAvgVolatilityTeam
      ,LgAvgVolatilityGame
      ,AdjRecentLeagueHistory
      ,TS */
  FROM [00TTI_LeagueScores].dbo.DailySummary
   order by GameDate desc