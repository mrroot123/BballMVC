
USE [00TTI_LeagueScores]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[uspInsertMatchupResults]') AND type in (N'P', N'PC'))
       DROP PROCEDURE [dbo].[uspInsertMatchupResults]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================
-- Author:                 Keith Doran
-- Create date:            01/19/2020
-- Description:            Insert into MatchupResults any rows NOT IN TodaysMatchups - Usually Yesterdays TMs
-- ==================================================================
-- Change History
-- ==================================================================
-- 
-- ==================================================================
CREATE PROCEDURE [dbo].[uspInsertMatchupResults] (  @UserName	varchar(10), @LeagueName varchar(8)  )
AS
	SET NOCOUNT ON;
              
	BEGIN  

Declare @x int
	, @Over  as char(4) = 'Over'
	, @Under as char(4) = 'Under'
	, @Win  as char(4) = 'Win'
	, @Loss as char(4) = 'Loss'
	, @Push as char(4) = 'Push'

;


--/ *
Insert Into TodaysMatchupsResults 
( -- 6
[UserName]
,[LeagueName]
,[GameDate]
,[RotNum]
,[TeamAway]
,[TeamHome]
-- 7
,[OurTotalLine]
,[SideLine]
,[TotalLine]
,[OpenTotalLine]
      ,[LineDiff]
      ,[OpenLineDiff]
      ,[Play]
 --4     
      ,[PlayResult]
      ,[TotalDirection]
      ,[TotalDirectionReg]
      ,[LineDiffResultReg]
--20      
,[MinutesPlayed]
,[OtPeriods]
,[ScoreReg]
,[ScoreOT]
,[ScoreRegHome]
,[ScoreRegAway]
,[BxScLinePct]
,[TmStrAdjPct]
,[GB1]
,[GB2]
,[GB3]
,[WeightGB1]
,[WeightGB2]
,[WeightGB3]
,[AwayGB1]
,[AwayGB2]
,[AwayGB3]
,[HomeGB1]
,[HomeGB2]
,[HomeGB3]
)
--*/
Select --6
 tm.UserName
, tm.LeagueName
, tm.GameDate
, tm.RotNum
, tm.TeamAway
, tm.TeamHome
-- 5
, tm.OurTotalLine
, tm.SideLine
, tm.TotalLine
, tm.OpenTotalLine
, tm.LineDiff
, tm.OpenLineDiff
, tm.Play
--4
	, CASE 
		WHEN tm.Play IS NULL THEN NULL
		WHEN tm.Play = ''		THEN NULL
		ELSE
			CASE	
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
			END
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
GO

