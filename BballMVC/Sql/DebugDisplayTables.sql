use [00TTI_LeagueScores]

Declare @LeagueName char(4) = 'WNBA', @GameDate  Date = '8/2/2020'

/****** Script for SelectTopNRows command from SSMS  ******/
IF 1=1
BEGIN
	SELECT @LeagueName, 'Rotation' as 'Table', Max(GameDate) as MaxGD, Count (*)   FROM Rotation  where LeagueName = @LeagueName and  gamedate = (Select max(Gamedate) from Rotation   where LeagueName = @LeagueName) 	
	
	SELECT @LeagueName, 'BoxScores' as 'Table', Max(GameDate) as MaxGD, Count (*)   FROM BoxScores  where LeagueName = @LeagueName and  gamedate = (Select max(Gamedate) from BoxScores   where LeagueName = @LeagueName) 	
	SELECT @LeagueName, 'TodaysMatchups' as 'Table', Max(GameDate) as MaxGD, Count (*)   FROM TodaysMatchups  where LeagueName = @LeagueName and  gamedate = (Select max(Gamedate) from TodaysMatchups   where LeagueName = @LeagueName) 	
	SELECT @LeagueName, 'TodaysMatchupsResults' as 'Table', Max(GameDate) as MaxGD, Count (*)   FROM TodaysMatchupsResults  where LeagueName = @LeagueName and  gamedate = (Select max(Gamedate) from TodaysMatchups   where LeagueName = @LeagueName) 	
	SELECT @LeagueName, 'DailySummary' as 'Table', Max(GameDate) as MaxGD, Count (*)   FROM DailySummary  where LeagueName = @LeagueName and  gamedate = (Select max(Gamedate) from DailySummary   where LeagueName = @LeagueName) 	
	SELECT @LeagueName, 'TeamStrength' as 'Table', Max(GameDate) as MaxGD, Count (*)   FROM TeamStrength  where LeagueName = @LeagueName and  gamedate = (Select max(Gamedate) from TeamStrength   where LeagueName = @LeagueName) 	
	SELECT @LeagueName, 'TeamStatsAverages' as 'Table', Max(GameDate) as MaxGD, Count (*)   FROM TeamStatsAverages  where LeagueName = @LeagueName and  gamedate = (Select max(Gamedate) from TeamStatsAverages   where LeagueName = @LeagueName) 	
END
------------------------------------
Select @LeagueName, @GameDate, 'Rotation',			Count(*) FROM Rotation				Where LeagueName = @LeagueName AND GameDate = @GameDate
Select @LeagueName, @GameDate, 'Boxscores',			Count(*) FROM Boxscores				Where LeagueName = @LeagueName AND GameDate = @GameDate
Select @LeagueName, @GameDate, 'TodaysMatchups',	Count(*) FROM TodaysMatchups		Where LeagueName = @LeagueName AND GameDate = @GameDate
Select @LeagueName, @GameDate, 'TodaysMatchupsResults',	Count(*) FROM TodaysMatchupsResults		Where LeagueName = @LeagueName AND GameDate = @GameDate
Select @LeagueName, @GameDate, 'TeamStatsAverages',Count(*) FROM TeamStatsAverages	Where LeagueName = @LeagueName AND GameDate = @GameDate
Select @LeagueName, @GameDate, 'DailySummary',		Count(*) FROM DailySummary			Where LeagueName = @LeagueName AND GameDate = @GameDate

return

SELECT top 1 *
  FROM [00TTI_LeagueScores].[dbo].TeamStatsAverages
   where gamedate > '7/25/2020' 	order by GameDate desc
	
SELECT top 1000 *
--	Delete
  FROM [00TTI_LeagueScores].[dbo].[Boxscores]
   where gamedate > '7/31/2020' 
		order by GameDate desc

SELECT top 1 *
  FROM [00TTI_LeagueScores].[dbo].TodaysMatchups
   where gamedate > '7/25/2020' 	order by GameDate desc
SELECT top 1 *
  FROM [00TTI_LeagueScores].[dbo].TodaysMatchupsResults
   where gamedate > '7/25/2020' 	order by GameDate desc
SELECT top 1 *
  FROM [00TTI_LeagueScores].[dbo].DailySummary
   where gamedate > '7/25/2020' 	order by GameDate desc

	
SELECT LeagueName, GameDate, count(*)
  FROM [00TTI_LeagueScores].[dbo].TodaysMatchupsResults
   where gamedate > '8/1/2020' 
	Group By LeagueName, GameDate
		order by LeagueName, GameDate
