use [00TTI_LeagueScores]

Declare @LeagueName char(4) = 'NBA'

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT @LeagueName, 'Rotation' as 'Table', Max(GameDate), Count (*)   FROM Rotation  where LeagueName = @LeagueName and  gamedate = (Select max(Gamedate) from Rotation   where LeagueName = @LeagueName) 	
	
SELECT @LeagueName, 'BoxScores' as 'Table', Max(GameDate), Count (*)   FROM BoxScores  where LeagueName = @LeagueName and  gamedate = (Select max(Gamedate) from BoxScores   where LeagueName = @LeagueName) 	
SELECT @LeagueName, 'TodaysMatchups' as 'Table', Max(GameDate), Count (*)   FROM TodaysMatchups  where LeagueName = @LeagueName and  gamedate = (Select max(Gamedate) from TodaysMatchups   where LeagueName = @LeagueName) 	
SELECT @LeagueName, 'TodaysMatchupsResults' as 'Table', Max(GameDate), Count (*)   FROM TodaysMatchupsResults  where LeagueName = @LeagueName and  gamedate = (Select max(Gamedate) from TodaysMatchups   where LeagueName = @LeagueName) 	
SELECT @LeagueName, 'DailySummary' as 'Table', Max(GameDate), Count (*)   FROM DailySummary  where LeagueName = @LeagueName and  gamedate = (Select max(Gamedate) from DailySummary   where LeagueName = @LeagueName) 	
SELECT @LeagueName, 'TeamStrength' as 'Table', Max(GameDate), Count (*)   FROM TeamStrength  where LeagueName = @LeagueName and  gamedate = (Select max(Gamedate) from TeamStrength   where LeagueName = @LeagueName) 	
SELECT @LeagueName, 'TeamStatsAverages' as 'Table', Max(GameDate), Count (*)   FROM TeamStatsAverages  where LeagueName = @LeagueName and  gamedate = (Select max(Gamedate) from TeamStatsAverages   where LeagueName = @LeagueName) 	

	return
------------------------------------

SELECT top 1 *
  FROM [00TTI_LeagueScores].[dbo].TeamStatsAverages
   where gamedate > '7/25/2020' 	order by GameDate desc
	
SELECT top 1 *
  FROM [00TTI_LeagueScores].[dbo].[Boxscores]
   where gamedate > '7/25/2020' 	order by GameDate desc

SELECT top 1 *
  FROM [00TTI_LeagueScores].[dbo].TodaysMatchups
   where gamedate > '7/25/2020' 	order by GameDate desc
SELECT top 1 *
  FROM [00TTI_LeagueScores].[dbo].DailySummary
   where gamedate > '7/25/2020' 	order by GameDate desc

