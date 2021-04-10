/****** Script for SelectTopNRows command from SSMS  ******/

--> TodaysMatchupsResults Sums & AVGs - ResultLD OurTL TL Score


Declare @LeagueName Varchar(4) = 'NBA', @StartDate date = '12/22/2020', @EndDate date = GetDate(), @OTamt as float = 1.2
If @LeagueName = 'WNBA' Set @OTamt = 1.6
Set @StartDate = '3/10/2021'	-- '1/1/2021'

SELECT 'All' as 'Criteria '  -- dbo.udfCalcResultLineDiff(OurTotalLine, TotalLine, ScoreReg , 0)
		, min(GameDate) as Start, max(GameDate) as EndDate, count(*) as Games
      , Round(Avg([LineDiffResultReg]), 1) as ResultLineDiff
      , Round(Avg([OurTotalLine]), 1) as [OurTotalLine]
      , Round(Avg(TotalLine), 1) as TotalLine
      , Round(Avg(ScoreReg), 1) + @OTamt as ScoreRegwOT
      , Round(Avg(ScoreOT), 1)  as ScoreFinal
		,'|' as '|'
      , Sum(UnderWin+UnderLoss+OverWin+OverLoss) as Plays
      , Sum(UnderWin+OverWin) as Wins
      , Sum(UnderLoss+OverLoss) as Losses
		, Cast( (Sum(UnderWin+OverWin)*100.0) / ( Sum(UnderWin+UnderLoss+OverWin+OverLoss)) as decimal (4,1)) as WinPct
		,'|' as '|'

      , Sum(UnderWin)+sum(UnderLoss) as Unders
      , Sum(UnderWin) as UnderWin
      , Sum(UnderLoss) as UnderLoss
		, Cast( (Sum(UnderWin)*100.0) / ( Sum(UnderWin)+Sum(UnderLoss)) as decimal (4,1)) as UnderPct
		,'|' as '|'

      , Sum(OverWin+OverLoss) as Overs
      , Sum(OverWin) as OverWin
      , Sum(OverLoss) as OverLoss
		, Cast( (Sum(OverWin)*100.0) / ( Sum(OverWin)+Sum(OverLoss)) as decimal (4,1)) as OverPct

  FROM [00TTI_LeagueScores].[dbo].[TodaysMatchupsResults] tmr
   Where Season = '2021' And LeagueName = @LeagueName and GameDate between @StartDate and @EndDate
		  AND Play > ''
	--  AND abs(PlayDiff)  < 10
Union

SELECT '< 10' as 'Criteria '  -- dbo.udfCalcResultLineDiff(OurTotalLine, TotalLine, ScoreReg , 0)
		, min(GameDate) as Start, max(GameDate) as EndDate, count(*) as Games
      , Round(Avg([LineDiffResultReg]), 1) as ResultLineDiff
      , Round(Avg([OurTotalLine]), 1) as [OurTotalLine]
      , Round(Avg(TotalLine), 1) as TotalLine
      , Round(Avg(ScoreReg), 1) + @OTamt as ScoreRegwOT
      , Round(Avg(ScoreOT), 1)  as ScoreFinal
		,'|' as '|'
      , Sum(UnderWin+UnderLoss+OverWin+OverLoss) as Plays
      , Sum(UnderWin+OverWin) as Wins
      , Sum(UnderLoss+OverLoss) as Losses
		, Cast( (Sum(UnderWin+OverWin)*100.0) / ( Sum(UnderWin+UnderLoss+OverWin+OverLoss)) as decimal (4,1)) as WinPct
		,'|' as '|'

      , Sum(UnderWin)+sum(UnderLoss) as Unders
      , Sum(UnderWin) as UnderWin
      , Sum(UnderLoss) as UnderLoss
		, Cast( (Sum(UnderWin)*100.0) / ( Sum(UnderWin)+Sum(UnderLoss)) as decimal (4,1)) as UnderPct
		,'|' as '|'

      , Sum(OverWin+OverLoss) as Overs
      , Sum(OverWin) as OverWin
      , Sum(OverLoss) as OverLoss
		, Cast( (Sum(OverWin)*100.0) / ( Sum(OverWin)+Sum(OverLoss)) as decimal (4,1)) as OverPct

  FROM [00TTI_LeagueScores].[dbo].[TodaysMatchupsResults] tmr
   Where Season = '2021' And LeagueName = @LeagueName and GameDate between @StartDate and @EndDate
		  AND Play > ''
	  AND abs(PlayDiff)  < 10