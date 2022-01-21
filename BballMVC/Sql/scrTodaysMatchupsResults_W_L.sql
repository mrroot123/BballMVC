use [00TTI_LeagueScores]
Declare @ScriptName varchar(25) = 'scrTodaysMatchupsResults_W_L';
Declare @StartDate date = '10/19/2021'
		, @EndDate date --  = '10/31/2021'

SELECT @ScriptName as ScriptName, Min(Gamedate) as StartDate, Max(Gamedate) as EndDate
  , Left(Convert(char(44),Round(
	 (
			  ( ( sum(UnderWin)+sum(OverWin) ) * 1.0 ) 
			/ ((  sum(UnderWin)+sum(OverWin)+sum(UnderLoss)+sum(OverLoss) ) * 1.0 )
		) * 100.0
	, 1)),4) as WinPct

		, Round( AVG(PlayDiff),2) as ResultPlayDiff
      ,sum(UnderWin)   as  UnderWin    ,sum(UnderLoss)  as  UnderLoss
		,sum(OverWin)   as  OverWin		,sum(OverLoss)  as  OverLoss
  FROM [TodaysMatchupsResults] t
  Where Season = '2122' 
    and GameDate between @StartDate and isnull(@EndDate, Getdate())
	-- and abs(PlayDiff) < 15

	Select PlayDiff, *
	 FROM [TodaysMatchupsResults] t
  Where Season = '2122' 
    and GameDate between @StartDate and isnull(@EndDate, Getdate())
	 and abs(PlayDiff) > 9.9
	 order by abs(PlayDiff) desc
