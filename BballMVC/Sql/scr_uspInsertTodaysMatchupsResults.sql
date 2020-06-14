USE [00TTI_LeagueScores]
GO
/****** Object:  StoredProcedure [dbo].[uspInsertTodaysMatchupsResults]    Script Date: 6/13/2020 7:16:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================
-- Author:                 Keith Doran
-- Create date:            01/19/2020
-- Description:            Insert into TodaysMatchupsResults any rows NOT IN TodaysMatchups - Usually Yesterdays TMs
-- ==================================================================
-- Change History
-- ==================================================================
-- 06/13/2020 Keith Doran		Changed Table Name & this SP to TodaysMatchupsResults
-- 06/13/2020 Keith Doran		Added Un/Ov Wins & Losses
-- ==================================================================
-- EXEC uspInsertMatchupResults 'Test', 'NBA'
ALTER PROCEDURE [dbo].[uspInsertTodaysMatchupsResults] (  @UserName	varchar(10), @LeagueName varchar(8)  )
AS
	SET NOCOUNT ON;
              
	BEGIN  

Declare @AdjOt int = 0
	, @Over  as char(4) = 'Over'
	, @Under as char(5) = 'Under'
	, @Win   as char(4) = 'Win'
	, @Loss  as char(4) = 'Loss'
	, @Push  as char(4) = 'Push'

;


--/ *
Insert Into TodaysMatchupsResults 
( -- 1/6 fields
	[UserName]	,[LeagueName]	,[GameDate]	,[RotNum]	,[TeamAway]	,[TeamHome]
	-- 2/7
	,[OurTotalLine]	,[SideLine]	,[TotalLine]	,[OpenTotalLine]	,[PlayDiff]	,[OpenPlayDiff]	,[Play]
	-- 3a/4
	,[UnderWin] ,[UnderLoss] ,[OverWin] ,[OverLoss] 
	 -- 3/4     
			,[PlayResult]			,[TotalDirection]			,[TotalDirectionReg]			,[LineDiffResultReg]
	-- 4/6      
	,[MinutesPlayed]	,[OtPeriods]	,[ScoreReg]	,[ScoreOT]	,[ScoreRegHome]	,[ScoreRegAway]
	--5 /3
	,VolatilityAway	,VolatilityHome	,VolatilityGame
	--6 / 14
	,[BxScLinePct]	,[TmStrAdjPct]
	,[GB1]	,[GB2]	,[GB3]
	,[WeightGB1]	,[WeightGB2]	,[WeightGB3]
	,[AwayGB1]	,[AwayGB2]	,[AwayGB3]
	,[HomeGB1]	,[HomeGB2]	,[HomeGB3]
)
--*/
-- Declare  @LeagueName varchar(8) = 'NBA'	, @Over  as char(4) = 'Over'	, @Under as char(4) = 'Under'	, @Win   as char(4) = 'Win'	, @Loss  as char(4) = 'Loss'	, @Push  as char(4) = 'Push'
Select --1/6
	 tm.UserName	, tm.LeagueName	, tm.GameDate	, tm.RotNum	, tm.TeamAway	, tm.TeamHome
	-- 2/7
	, tm.OurTotalLine	, tm.SideLine	, tm.TotalLine	, tm.OpenTotalLine	, tm.PlayDiff	, tm.OpenPlayDiff	, tm.Play
	--3a/4
	, CASE 
			WHEN tm.Play IS NULL THEN 0
			WHEN tm.Play = @Under AND b.ScoreOT < tm.TotalLine THEN 1
			ELSE 0
	  END AS UnderWin

	, CASE 
			WHEN tm.Play IS NULL THEN 0
			WHEN tm.Play = @Under AND b.ScoreOT > tm.TotalLine THEN 1
			ELSE 0
	  END AS UnderLoss

	, CASE 
			WHEN tm.Play IS NULL THEN 0
			WHEN tm.Play = @Over AND b.ScoreOT > tm.TotalLine THEN 1
			ELSE 0
	  END AS OverWin

	, CASE 
			WHEN tm.Play IS NULL THEN 0
			WHEN tm.Play = @Over AND b.ScoreOT < tm.TotalLine THEN 1
			ELSE 0
	  END AS OverLoss

	--3/ 4
	, CASE 
		WHEN tm.Play IS NULL THEN NULL
		WHEN tm.Play = ''		THEN NULL
		--ELSE
		--	CASE	
			WHEN b.ScoreOT > tm.TotalLine
				THEN -- @Over
				CASE 
					WHEN tm.Play = @Over	THEN @Win
					ELSE @Loss
				END

			WHEN b.ScoreOT < tm.TotalLine 
				THEN --@Under
				CASE 
					WHEN tm.Play = @Under	THEN @Win
					ELSE @Loss
				END

			ELSE @Push
--			END
		END AS PlayResult


	, CASE 
			WHEN b.ScoreOT > tm.TotalLine THEN @Over
			WHEN b.ScoreOT < tm.TotalLine THEN @Under
			ELSE @Push
		END AS TotalDirection
	, CASE 
			WHEN b.ScoreReg > tm.TotalLine THEN @Over
			WHEN b.ScoreReg < tm.TotalLine THEN @Under
			ELSE @Push
		END AS TotalDirectionReg
	, ABS(b.ScoreReg - tm.TotalLine) - ABS(b.ScoreReg - tm.OurTotalLine) AS LineDiffResultReg
	--20
	, b.MinutesPlayed
	, b.OtPeriods
	, b.ScoreReg
	, b.ScoreOT
	, b.ScoreRegUs
	, b.ScoreRegOp

	, ABS( ((tm.TotalLine + tm.SideLine) / 2) - b.ScoreRegOp)
	, ABS( ((tm.TotalLine - tm.SideLine) / 2) - b.ScoreRegUs)
	, ABS(tm.TotalLine - b.ScoreReg)

	, tm.BxScLinePct
	, tm.TmStrAdjPct
	, tm.GB1
	, tm.GB2
	, tm.GB3
	, tm.WeightGB1
	, tm.WeightGB2
	, tm.WeightGB3
	, tm.AwayGB1
	, tm.AwayGB2
	, tm.AwayGB3
	, tm.HomeGB1
	, tm.HomeGB2
	, tm.HomeGB3

  From TodaysMatchups tm 
  JOIN BoxScores b ON b.GameDate = tm.GameDate AND b.RotNum = tm.RotNum
  LEFT JOIN TodaysMatchupsResults mr ON mr.GameDate = tm.GameDate AND mr.LeagueName = tm.LeagueName 
 Where	-- tm.GameDate = @GameDate	 AND 
	tm.LeagueName = @LeagueName
   AND mr.GameDate is Null

	END	-- USP
