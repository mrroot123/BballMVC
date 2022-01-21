/****** Script for SelectTopNRows command from SSMS  ******/
use  [00TTI_LeagueScores]
use  [00TTI_LeagueScores_HISTORY]
SELECT TOP (1000) t.[name]

      ,[create_date]
      ,[modify_date]
		, (	select count(*)
			  FROM [INFORMATION_SCHEMA].[COLUMNS] c
			  where c.TABLE_NAME = t.name
			  ) as Columns
  FROM [sys].[tables] t
  Where t.Name in (
  '_UpdatedObjects'
, 'Adjustments'
, 'AdjustmentsCodes'
, 'AnalysisResults'
, 'BoxScores'
, 'BoxScoresLast5Min'
, 'DailySummary'
, 'LeagueInfo'
, 'Lines'
, 'ParmTable'
, 'Rotation'
, 'SeasonInfo'
, 'Team'
, 'TeamStatsAverages'
, 'TeamStrength'
, 'TodaysMatchups'
, 'TodaysMatchupsResults'
, 'UserLeagueParms'
, 'Users'

  )
  order by 
	Name,
	 modify_date desc