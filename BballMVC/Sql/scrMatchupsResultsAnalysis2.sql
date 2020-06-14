Select *, (wins*100) / (convert( float,wins)+Losses) * 1.0 as WinPct
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

		, Sum( Case
			When mr.Play = 'Under' THEN 1
			ELSE 0
		  END) as Unders

		, Sum( Case
			When mr.Play = 'Over' THEN 1
			ELSE 0
		  END) as Overs

		, Sum( Case
			When mr.Play = 'Under'  AND mr.PlayResult = 'Win' THEN 1
			ELSE 0
		  END) as UnderWins

		, Sum( Case
			When mr.Play = 'Under'  AND mr.PlayResult = 'Loss' THEN 1
			ELSE 0
		  END) as UnderLosses

		, Sum( Case
			When mr.Play = 'Over'  AND mr.PlayResult = 'Win' THEN 1
			ELSE 0
		  END) as OverWins
		, Sum( Case
			When mr.Play = 'Over'  AND mr.PlayResult = 'Loss' THEN 1
			ELSE 0
		  END) as OverLosses

 --     ,[PlayResult]
  FROM [00TTI_LeagueScores].[dbo].[TodaysMatchupsResults] mr
   Where mr.Play = 'Over'
  ) x