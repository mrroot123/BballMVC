/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [GameDate]
      
	   , Round(OurTotalLine,1) as  OurTotalLine

      ,[SideLine]
      ,[TotalLine]
      ,Round(LineDiff,1) as  LineDiff
      ,[Play]
      ,[PlayResult]
      ,[TotalDirection]
      ,[TotalDirectionReg]
      , Round(LineDiffResultReg,1) as  LineDiffResultReg
      ,[OtPeriods]
      ,[ScoreReg]
      ,[ScoreOT]
      ,[ScoreRegHome]
      ,[ScoreRegAway]

  FROM [00TTI_LeagueScores].[dbo].[TodaysTodaysMatchupsResults]
  where PlayResult is not null and OtPeriods > 0
    and ( ScoreReg < TotalLine and ScoreOT > TotalLine)
  order by Play, PlayResult