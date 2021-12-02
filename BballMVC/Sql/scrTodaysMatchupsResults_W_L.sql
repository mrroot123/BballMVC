/****** Script for SelectTopNRows command from SSMS  ******/

Declare @StartDate date = '11/1/2021'

SELECT Min(Gamedate) as StartDate
  ,Round(
	 (
			  ( ( sum(UnderWin)+sum(OverWin) ) * 1.0 ) 
			/ ((  sum(UnderWin)+sum(OverWin)+sum(UnderLoss)+sum(OverLoss) ) * 1.0 )
		) * 100.0
	, 1) as WinPct

		, AVG(PlayDiff) as ResultPlayDiff
      ,sum(UnderWin)   as  UnderWin    ,sum(UnderLoss)  as  UnderLoss
		,sum(OverWin)   as  OverWin		,sum(OverLoss)  as  OverLoss
  FROM [TodaysMatchupsResults] t
  Where Season = '2122' 
    and GameDate >= @StartDate
	-- and abs(PlayDiff) < 15
