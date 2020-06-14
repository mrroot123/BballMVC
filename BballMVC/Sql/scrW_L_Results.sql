/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	Count(*) as Plays
		, Sum( Case
			When PlayResult = 'Win' THEN 1
			ELSE 0
		  END) as Wins
		  
		, Sum( Case
			When PlayResult = 'Loss' THEN 1
			ELSE 0
		  END) as Losses
  FROM [00TTI_LeagueScores].[dbo].[TodaysTodaysMatchupsResults]
   where PlayResult is not null