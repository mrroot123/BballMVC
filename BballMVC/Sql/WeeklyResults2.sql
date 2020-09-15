/****** Script for SelectTopNRows command from SSMS  ******/
Declare @monday date , @days int
IF  DATEPART(dw, Getdate()) = 1
	Set @days = 6
ELSE
	Set @days = DATEPART(dw, Getdate() - 2)   
Set @monday = DATEADD(d, -(@days),  Convert(Date,Getdate()) )


--Select @monday;	return;

SELECT LeagueName
      ,Sum( [UnderWin]+[OverWin]) as Win
     ,Sum([UnderLoss]+[OverLoss]) as [Loss]

     , Sum( [UnderWin]) as UnderWin
     ,Sum([UnderLoss]) as [UnderLoss]
     ,Sum([OverWin]) as [OverWin]
     ,Sum([OverLoss]) as [OverLoss]
  FROM [00TTI_LeagueScores].[dbo].[TodaysMatchupsResults]
  where GameDate >= @Monday
   and PlayResult is not null
	Group by LeagueName

SELECT
      Sum( [UnderWin]+[OverWin]) as Win
     ,Sum([UnderLoss]+[OverLoss]) as [Loss]

     , Sum( [UnderWin]) as UnderWin
     ,Sum([UnderLoss]) as [UnderLoss]
     ,Sum([OverWin]) as [OverWin]
     ,Sum([OverLoss]) as [OverLoss]
  FROM [00TTI_LeagueScores].[dbo].[TodaysMatchupsResults]
  where GameDate >= @Monday
   and PlayResult is not null

SELECT
[LeagueName]
      ,[GameDate], DATENAME(dw,GameDate)
--      ,[RotNum]
      ,[TeamAway]
      ,[TeamHome]
 --     ,[OurTotalLine]
      ,[TotalLine]
     -- ,[OpenTotalLine]
 --     ,[PlayDiff]
      ,[Play]
      ,[PlayResult]
		      ,[ScoreReg]
      ,[ScoreOT]
      ,[UnderWin]
      ,[UnderLoss]
      ,[OverWin]
      ,[OverLoss]
      ,[TotalDirection]
      ,[TotalDirectionReg]
      ,[LineDiffResultReg]
      ,[MinutesPlayed]
      ,[OtPeriods]

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
  where GameDate >= @Monday
   and PlayResult is not null
  order by Gamedate, RotNum