/****** Script for SelectTopNRows command from SSMS  ******/
Declare @Season varchar(4) = '2021';

Select @Season as Season
,	(Select top 1 StartDate from SeasonInfo Where Season = @Season and SubSeason = '1-Reg' order by StartDate)
	as 'Reg Start Date'
, (Select top 1 EndDate from SeasonInfo Where Season = @Season and SubSeason = '1-Reg' order by StartDate desc)
	as 'Reg End Date'

SELECT
		DATEPART(YEAR, gameDate) as 'Year'
	 , convert(Date,DATEADD(wk, DATEDIFF(wk, 6, '1/1/' + CAST(DATEPART(YY, GameDate) AS CHAR(4))) + (DATEPART(WEEK, gameDate)-1), 6)) AS StartOfWeek
	 , DATEPART(WEEK, gameDate) as week
	 , Round(Avg([LineDiffResultReg]), 1) as [LineDiffResultReg]
	 , sum(UnderWin+OverWin)  as Wins
	 , sum(UnderLoss+OverLoss)  as Losss



	 , sum(UnderWin)  as UnderWin
	 , sum(OverWin)  as OverWin


	 , sum(UnderLoss)  as UnderLoss
	 , sum(OverLoss)  as OverLoss


  FROM [00TTI_LeagueScores].[dbo].[TodaysMatchupsResults]
   where Season = @Season
	 and PlayResult is not null
	group by  DATEPART(YEAR, gameDate), DATEPART(WEEK, gameDate)	
	order by  DATEPART(YEAR, gameDate), DATEPART(WEEK, gameDate)

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
		[GameDate]
		, DATEPART(WEEK, gameDate) as week


      ,[OurTotalLine]

      ,[TotalLine]

      ,Round([PlayDiff], 1) as [PlayDiff]
      ,Round([LineDiffResultReg], 1) as [LineDiffResultReg]


      ,[Play]
      ,[PlayResult]
      ,[UnderWin]
      ,[UnderLoss]
      ,[OverWin]
      ,[OverLoss]
      ,[TotalDirection]
      ,[TotalDirectionReg]
      ,[TeamWinning]
      ,[TeamLosing]

      ,[MinutesPlayed]
      ,[OtPeriods]
      ,[ScoreReg]
      ,[ScoreOT]
      ,[ScoreRegHome]
      ,[ScoreRegAway]
      ,[VolatilityAway]
      ,[VolatilityHome]
      ,[VolatilityGame]
      ,[BxScLinePct]
      ,[TmStrAdjPct]
      ,[GB1]
      ,[GB2]
      ,[GB3]
      ,[WeightGB1]
      ,[WeightGB2]
      ,[WeightGB3]
      ,[AwayGB1]
      ,[AwayGB2]
      ,[AwayGB3]
      ,[HomeGB1]
      ,[HomeGB2]
      ,[HomeGB3]
      ,[TS]
  FROM [00TTI_LeagueScores].[dbo].[TodaysMatchupsResults]
   where Season = '2122'
	 and PlayResult is not null