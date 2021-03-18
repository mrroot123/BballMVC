  use [00TTI_LeagueScores]

  Declare @LeagueName varchar(10) = 'NBA'
		, @AllLeagues bit = 0

If @AllLeagues = 1
	Select @@SERVERNAME, 'All Leagues Selected'
ELSE
	Select @@SERVERNAME, @LeagueName + ' Selected'


  SElect '9' as Seq, 'Adjustments' as TableName, Min(StartDate) as StartGameDate, Max(StartDate) as MaxStartDate, Count(*) as Rows, 'Tomorrow' as MaxDate, 'Adj Entry ' as Description From Adjustments   Where LeagueName = @LeagueName or @AllLeagues = 1
  UNION  SElect '9A' as Seq, 'Adjustments_8_20' as TableName, Min(StartDate) as StartGameDate, Max(StartDate) as MaxStartDate, Count(*) as Rows, 'Tomorrow' as MaxDate, 'Adj Entry ' as Description 
								 From Adjustments_8_20   Where LeagueName = @LeagueName or @AllLeagues = 1
  UNION  SElect '9A' as Seq, 'xAdjustments_NBA' as TableName, Min(StartDate) as StartGameDate, Max(StartDate) as MaxStartDate, Count(*) as Rows, 'Tomorrow' as MaxDate, 'Adj Entry ' as Description 
								 From xAdjustments_NBA   Where LeagueName = @LeagueName or @AllLeagues = 1
  UNION  SElect '9A' as Seq, 'xAdjustments_orig' as TableName, Min(StartDate) as StartGameDate, Max(StartDate) as MaxStartDate, Count(*) as Rows, 'Tomorrow' as MaxDate, 'Adj Entry ' as Description 
								 From xAdjustments_orig   Where LeagueName = @LeagueName or @AllLeagues = 1
  UNION  SElect '9A' as Seq, 'xAdjustments_WNBA' as TableName, Min(StartDate) as StartGameDate, Max(StartDate) as MaxStartDate, Count(*) as Rows, 'Tomorrow' as MaxDate, 'Adj Entry ' as Description 
								 From xAdjustments_WNBA   Where LeagueName = @LeagueName or @AllLeagues = 1
 -- UNION  SElect '9n' as Seq, 'Adjustments_NEW' as TableName, Min(StartDate) as StartGameDate, Max(StartDate) as GameDate, Count(*) as Rows, 'Tomorrow' as MaxDate, 'scrCreateNewAdjustments' as Description From Adjustments_NEW  Where LeagueName = @LeagueName or @AllLeagues = 1
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