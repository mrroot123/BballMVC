/****** Script for SelectTopNRows command from SSMS  ******/
SELECT ''  -- dbo.udfCalcResultLineDiff(OurTotalLine, TotalLine, ScoreReg , 0)
      , Round(Avg([LineDiffResultReg]), 1) as LineDiffResult
      , Round(Avg([OurTotalLine]), 1) as [OurTotalLine]
      , Round(Avg(TotalLine), 1) as TotalLine
      , Round(Avg(ScoreReg), 1) as ScoreReg

      , Sum(UnderWin)+sum(UnderLoss) as Unders
      , Sum(UnderWin) as UnderWin
      , Sum(UnderLoss) as UnderLoss
		, Round( (Sum(UnderWin)*100.0) / ( Sum(UnderWin)+Sum(UnderLoss)),1) as UnderPct

      , Sum(OverWin)+Sum(OverLoss) as Overs
      , Sum(OverWin) as OverWin
      , Sum(OverLoss) as OverLoss
		, Round( (Sum(OverWin)*100.0) / ( Sum(OverWin)+Sum(OverLoss)),1) as OverPct
  FROM [00TTI_LeagueScores].[dbo].[TodaysMatchupsResults] tmr
   Where Season = '2021'
	  AND Play > ''