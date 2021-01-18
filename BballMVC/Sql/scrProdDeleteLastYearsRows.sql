/****** Script for SelectTopNRows command from SSMS  ******/
Declare @StartDate date = '12/01/2020'
	, @DeleteFlag bit = 0
;

SELECT 'Boxscores', Count(*) 
  FROM [00TTI_LeagueScores].[dbo].[BoxScores]
  where GameDate < @StartDate
If @DeleteFlag = 1
BEGIN
	DELETE
		FROM [00TTI_LeagueScores].[dbo].[BoxScores]
		where GameDate < @StartDate
END

SELECT '[BoxScoresLast5Min]', Count(*) 
  FROM [00TTI_LeagueScores].[dbo].[BoxScoresLast5Min]
  where GameDate < @StartDate
If @DeleteFlag = 1
BEGIN
	DELETE
		FROM [00TTI_LeagueScores].[dbo].[BoxScoresLast5Min]
		where GameDate < @StartDate
END


SELECT '[DailySummary]', Count(*) 
  FROM [00TTI_LeagueScores].[dbo].DailySummary
  where GameDate < @StartDate
If @DeleteFlag = 1
BEGIN
	DELETE
		FROM [00TTI_LeagueScores].[dbo].DailySummary
		where GameDate < @StartDate
END

SELECT '[Lines]', Count(*) 
  FROM [00TTI_LeagueScores].[dbo].Lines
  where GameDate < @StartDate
If @DeleteFlag = 1
BEGIN
	DELETE
		FROM [00TTI_LeagueScores].[dbo].Lines
		where GameDate < @StartDate
END


SELECT '[Rotation]', Count(*) 
  FROM [00TTI_LeagueScores].[dbo].Rotation
  where GameDate < @StartDate
If @DeleteFlag = 1
BEGIN
	DELETE
		FROM [00TTI_LeagueScores].[dbo].Rotation
		where GameDate < @StartDate
END


SELECT '[[TeamStatsAverages]]', Count(*) 
  FROM [00TTI_LeagueScores].[dbo].[TeamStatsAverages]
  where GameDate < @StartDate
If @DeleteFlag = 1
BEGIN
	DELETE
		FROM [00TTI_LeagueScores].[dbo].[TeamStatsAverages]
		where GameDate < @StartDate
END


SELECT '[TeamStrength]', Count(*) 
  FROM [00TTI_LeagueScores].[dbo].TeamStrength
  where GameDate < @StartDate
If @DeleteFlag = 1
BEGIN
	DELETE
		FROM [00TTI_LeagueScores].[dbo].TeamStrength
		where GameDate < @StartDate
END


SELECT '[TodaysMatchups]', Count(*) 
  FROM [00TTI_LeagueScores].[dbo].TodaysMatchups
  where GameDate < @StartDate
If @DeleteFlag = 1
BEGIN
	DELETE
		FROM [00TTI_LeagueScores].[dbo].TodaysMatchups
		where GameDate < @StartDate
END

SELECT '[TodaysMatchupsResults]', Count(*) 
  FROM [00TTI_LeagueScores].[dbo].TodaysMatchupsResults
  where GameDate < @StartDate
If @DeleteFlag = 1
BEGIN
	DELETE
		
		FROM [00TTI_LeagueScores].[dbo].TodaysMatchupsResults

		where GameDate < @StartDate
END

