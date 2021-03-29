/****** Script for SelectTopNRows command from SSMS  ******/

Declare @StartDate date = '1/1/2021'

SELECT @StartDate as StartDate
  ,Round(
	 (
			  ( ( sum(UnderWin)+sum(OverWin) ) * 1.0 ) 
			/ ((  sum(UnderWin)+sum(OverWin)+sum(UnderLoss)+sum(OverLoss) ) * 1.0 )
		) * 100.0
	, 1) as WinPct
      ,sum(UnderWin)   as  UnderWin    ,sum(UnderLoss)  as  UnderLoss
		,sum(OverWin)   as  OverWin		,sum(OverLoss)  as  OverLoss
  FROM [00TTI_LeagueScores].[dbo].[TodaysMatchupsResults] t
  Where Season = '2021' 
    and GameDate >= @StartDate
	-- and abs(PlayDiff) < 15
