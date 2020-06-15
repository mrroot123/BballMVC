--/****** Script for SelectTopNRows command from SSMS  ******/

--Select *, (wins*10000) / (wins+Losses) as WinPct
--From (
--SELECT count(*) as MUPs

--      ,round(avg([LineDiff]), 2) as LineDiff
--      ,round(avg([LineDiffResultReg]), 2) as LineDiffResultReg

--		, Sum( Case
--			When PlayResult = 'Win' THEN 1
--			ELSE 0
--		  END) as Wins
		  
--		, Sum( Case
--			When PlayResult = 'Loss' THEN 1
--			ELSE 0
--		  END) as Losses

-- --     ,[PlayResult]

 Select Sum(tmr.UnderWin)  as UnderWin
 , sum(tmr.UnderLoss) as UnderLoss
 , sum( OverWin) as OverWin
 , sum (OverLoss) as OverLoss
  FROM [00TTI_LeagueScores].[dbo].[TodaysMatchupsResults] tmr
--  ) x