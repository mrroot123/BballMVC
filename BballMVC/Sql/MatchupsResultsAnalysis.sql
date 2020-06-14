/****** Script for SelectTopNRows command from SSMS  ******/

Select *, (wins*10000) / (wins+Losses) as WinPct
From (
SELECT count(*) as MUPs

      ,round(avg([LineDiff]), 2) as LineDiff
      ,round(avg([LineDiffResultReg]), 2) as LineDiffResultReg

		, Sum( Case
			When PlayResult = 'Win' THEN 1
			ELSE 0
		  END) as Wins
		  
		, Sum( Case
			When PlayResult = 'Loss' THEN 1
			ELSE 0
		  END) as Losses

 --     ,[PlayResult]
  FROM [00TTI_LeagueScores].[dbo].[TodaysTodaysMatchupsResults]
  ) x