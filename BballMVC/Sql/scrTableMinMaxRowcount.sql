 use [db_a791d7_leaguescores]
  SELECT 'NBA' as League, 'Adjustments' As 'Table',  Count(*) as Rows, min(StartDate) as StartDate , max(StartDate) as EndDate  from Adjustments where LeagueName = 'NBA'
Union  SELECT 'ALL'  as League, 'AdjustmentsCodes' As 'Table',  Count(*) as Rows, null, null  from AdjustmentsCodes
Union  SELECT 'NBA' as League, 'BoxScores' As 'Table',  Count(*) as Rows, min(GameDate) as StartDate , max(GameDate) as EndDate  from BoxScores where LeagueName = 'NBA'
Union  SELECT 'NBA' as League, 'BoxScoresLast5Min' As 'Table',  Count(*) as Rows, min(GameDate) as StartDate , max(GameDate) as EndDate  from BoxScoresLast5Min where LeagueName = 'NBA'
Union  SELECT 'NBA' as League, 'DailySummary' As 'Table',  Count(*) as Rows, min(GameDate) as StartDate , max(GameDate) as EndDate  from DailySummary where LeagueName = 'NBA'
Union  SELECT 'ALL'  as League, 'LeagueInfo' As 'Table',  Count(*) as Rows, null, null  from LeagueInfo
Union  SELECT 'NBA' as League, 'Lines' As 'Table',  Count(*) as Rows, min(GameDate) as StartDate , max(GameDate) as EndDate  from Lines where LeagueName = 'NBA'
Union  SELECT 'ALL'  as League, 'ParmTable' As 'Table',  Count(*) as Rows, null, null  from ParmTable
Union  SELECT 'NBA' as League, 'Rotation' As 'Table',  Count(*) as Rows, min(GameDate) as StartDate , max(GameDate) as EndDate  from Rotation where LeagueName = 'NBA'
Union  SELECT 'ALL'  as League, 'SeasonInfo' As 'Table',  Count(*) as Rows, null, null  from SeasonInfo
Union  SELECT 'ALL'  as League, 'Team' As 'Table',  Count(*) as Rows, null, null  from Team
Union  SELECT 'NBA' as League, 'TeamStatsAverages' As 'Table',  Count(*) as Rows, min(GameDate) as StartDate , max(GameDate) as EndDate  from TeamStatsAverages where LeagueName = 'NBA'
Union  SELECT 'NBA' as League, 'TeamStrength' As 'Table',  Count(*) as Rows, min(GameDate) as StartDate , max(GameDate) as EndDate  from TeamStrength where LeagueName = 'NBA'
Union  SELECT 'NBA' as League, 'TodaysMatchups' As 'Table',  Count(*) as Rows, min(GameDate) as StartDate , max(GameDate) as EndDate  from TodaysMatchups where LeagueName = 'NBA'
Union  SELECT 'NBA' as League, 'TodaysMatchupsResults' As 'Table',  Count(*) as Rows, min(GameDate) as StartDate , max(GameDate) as EndDate  from TodaysMatchupsResults where LeagueName = 'NBA'
Union  SELECT 'NBA' as League, 'TodaysPlays' As 'Table',  Count(*) as Rows, min(GameDate) as StartDate , max(GameDate) as EndDate  from TodaysPlays where LeagueName = 'NBA'
Union  SELECT 'ALL'  as League, 'UserLeagueParms' As 'Table',  Count(*) as Rows, null, null  from UserLeagueParms
Union  SELECT 'ALL'  as League, 'Users' As 'Table',  Count(*) as Rows, null, null  from Users
order by 1 , 2

