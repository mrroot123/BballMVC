/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      t.[GameDate]
      ,t.[RotNum]
      ,t.[TeamAway]
      ,t.[TeamHome]
      ,round(t.[OurTotalLine], 1) as OurTL
      ,t.[TotalLine]
		,t.[ScoreReg]

      ,round(t.[PlayDiff], 1) as PlayDiff
		,round(t.[PlayDiff] - (tm.AdjTeamAway + tm.AdjTeamHome), 1) as AdjPlayDiff
		, tm.AdjTeamAway, tm.AdjTeamHome

      ,t.[Play]
      ,isnull(PlayResult, '') as Play_WL_Result
		,[TotalDirection] as Un_Ov
      ,round([LineDiffResultReg], 1) as ResultDiff

      ,[UnderWin]
      ,[UnderLoss]
      ,[OverWin]
      ,[OverLoss]
      
      ,[TotalDirectionReg]
      ,[TeamWinning]
      ,[TeamLosing]
      ,[MinutesPlayed]
      ,[OtPeriods]
      
      ,[ScoreOT]
      ,[ScoreRegHome]
      ,[ScoreRegAway]

  FROM [TodaysMatchupsResults] t
   Join TodaysMatchups tm on tm.GameDate = t.GameDate and tm.RotNum = t.RotNum
  Where t.Season = '2122' 
	and t.Play > ''
  --and abs(t.PlayDiff) > 25
	and t.GameDate >= '10/21/2021'
  -- and not (TeamAway = 'was' or TeamHome = 'was')
  order by
   GameDate desc
	--abs(t.PlayDiff) desc,
	---- totalLine,
	-- GameDate, RotNum

	 return;

SELECT  Round(
			(  ( (sum(UnderWin) + sum(UnderLoss)) *1.10) 
			   /  ( (sum(UnderWin) + sum(UnderLoss) + sum(OverWin) + sum(OverLoss)) *1.10) ) * 100
				, 1) as Pct
      ,sum(UnderWin)   as  UnderWin    ,sum(UnderLoss)  as  UnderLoss
		,sum(OverWin)   as  OverWin		,sum(OverLoss)  as  OverLoss
  FROM [TodaysMatchupsResults] t
  Where Season = '2122' 
    and GameDate >= '1/1/2021'
--	 and abs(PlayDiff) < 15
