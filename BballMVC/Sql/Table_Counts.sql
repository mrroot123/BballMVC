  use [00TTI_LeagueScores]


			SElect '1' as Seq, 'DailySummary' as TableName, Min(GameDate) as StartGameDate, Max(GameDate) as GameDate, Count(*) as Rows, 'Tomorrow' as MaxDate, '.net ' as Creation	From DailySummary 
UNION		SElect '2' as Seq, 'Rotation' as TableName, Min(GameDate) as StartGameDate, Max(GameDate) as GameDate, Count(*) as Rows		, 'Tomorrow' as MaxDate, '.net ' as Description From Rotation 
UNION		SElect '2n' as Seq, 'Rotation_NEW' as TableName, Min(GameDate) as StartGameDate, Max(GameDate) as GameDate, Count(*) as Rows		, 'Tomorrow' as MaxDate, 'scrCreateRotationFromSchedule' as Description From Rotation_NEW
UNION		SElect '3' as Seq, 'TodaysMatchups' as TableName, Min(GameDate) as StartGameDate, Max(GameDate) as GameDate, Count(*) as Rows, 'Today' as MaxDate, 'uspCalcTMs ' as Description From TodaysMatchups 
UNION		SElect '4' as Seq, 'BoxScores' as TableName, Min(GameDate) as StartGameDate, Max(GameDate) as GameDate, Count(*) as Rows, 'Yesterday' as MaxDate, '.net ' as Description From BoxScores 
UNION		SElect '4n' as Seq, 'BoxScores_NEW' as TableName, Min(GameDate) as StartGameDate, Max(GameDate) as GameDate, Count(*) as Rows, 'Yesterday' as MaxDate, 'scrCreateBoxScoresFromV1' as Description From BoxScores_NEW
UNION		SElect '5' as Seq, 'TodaysMatchupsResults' as TableName, Min(GameDate) as StartGameDate, Max(GameDate) as GameDate, Count(*) as Rows, 'Yesterday' as MaxDate, 'uspInsertMatchupResults ' as Description From TodaysMatchupsResults 

UNION		SElect '6' as Seq, 'TeamStrength' as TableName, Min(GameDate) as StartGameDate, Max(GameDate) as GameDate, Count(*) as Rows, 'Yesterday' as MaxDate, 'uspTeamStrength ' as Description From TeamStrength 
UNION		SElect '7' as Seq, 'TeamStatsAverages' as TableName, Min(GameDate) as StartGameDate,  Max(GameDate) as GameDate, Count(*) as Rows, 'Tomorrow' as MaxDate, '.uspCalcTMs ' as Description From TeamStatsAverages 
UNION		SElect '8' as Seq, 'BoxScoresLast5Min' as TableName, Min(GameDate) as StartGameDate, Max(GameDate) as GameDate, Count(*) as Rows, 'Yesterday' as MaxDate, '.net ' as Description From BoxScoresLast5Min 
UNION		SElect '9' as Seq, 'Adjustments' as TableName, Min(StartDate) as StartGameDate, Max(StartDate) as GameDate, Count(*) as Rows, 'Tomorrow' as MaxDate, 'Adj Entry ' as Description From Adjustments 
UNION		SElect '9n' as Seq, 'Adjustments_NEW' as TableName, Min(StartDate) as StartGameDate, Max(StartDate) as GameDate, Count(*) as Rows, 'Tomorrow' as MaxDate, 'scrCreateNewAdjustments' as Description From Adjustments_NEW
order by 2

return

Declare @GameDate date = '1/12/2020';

SELECT distinct 'BoxScores',   [GameDate] as 'BoxScores'
  FROM [00TTI_LeagueScores].[dbo].BoxScores
  where GameDate > @GameDate

  SELECT distinct  'TodaysMatchupsResults', [GameDate] as 'TodaysMatchupsResults'
  FROM [00TTI_LeagueScores].[dbo].TodaysMatchupsResults
  where GameDate > @GameDate

  SELECT distinct 'TodaysMatchups',  [GameDate] as 'TodaysMatchups'
  FROM [00TTI_LeagueScores].[dbo].TodaysMatchups
  where GameDate > @GameDate