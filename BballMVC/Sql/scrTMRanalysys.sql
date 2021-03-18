/****** Script for SelectTopNRows command from SSMS  ******/
Select WeekNum
	, Min(GameDate) as 'Date'
	, count(*) as Games
	, Round(Avg(OurTotalLine),1) as OurTotalLine
	, Round(Avg(TotalLine),1) as TotalLine
	, Round(Avg(ScoreReg+1.2),1) as LgAvg_w_OT
	, Round(Avg(abs(PlayDiff)),1) as PlayDiff
	, Round(Avg(LineDiffResultReg),1) as LineDiffResultReg
		, '|' '*'
	, Sum(q1.Underwin+q1.OverWin- ((q1.UnderLoss+q1.OverLoss)*1.1)) as WL_Result_w_Juice
	, Sum(q1.Underwin+q1.OverWin- (q1.UnderLoss+q1.OverLoss)) as WL_Result
	, '|' '*'
	, Sum(q1.Underwin+q1.OverWin) as Wins
	, Sum(q1.UnderLoss+q1.OverLoss) as Losses
	, '|' '*'
	, Sum(q1.Underwin) as Underwin
	, Sum(q1.UnderLoss) as UnderLoss
		, '|' '*'
	, Sum(q1.OverWin) as OverWin
	, Sum(q1.OverLoss) as OverLoss
From (

		SELECT TOP (1000) [MatchupsResultsID]
				,[UserName]
				,[LeagueName]
				,[GameDate]
				, DATEPART(wk, GameDate) as WeekNum
				,[Season]
				,[SubSeason]
				,[RotNum]
				,[TeamAway]
				,[TeamHome]
				,[OurTotalLine]
				,[SideLine]
				,[TotalLine]
				,[OpenTotalLine]
				,[PlayDiff]
				,[OpenPlayDiff]
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
				,[LineDiffResultReg]
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
			where gamedate >= '1/1/2021' and Play > ''
  ) q1
	Group by q1.WeekNum
	order by q1.WeekNum