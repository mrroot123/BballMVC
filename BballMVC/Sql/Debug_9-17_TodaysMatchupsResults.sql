USE [00TTI_LeagueScores]
GO
/****** Object:  StoredProcedure [dbo].[uspInsertAnalysisResults]    Script Date: 9/16/2020 6:34:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================
-- Author:                 Keith Doran
-- Create date:            07/10/2020
-- Description:            Insert AnalysisResults for a perticular RunID
-- ==================================================================
-- Change History
-- ==================================================================
-- 
-- ==================================================================
-- EXEC uspInsertAnalysisResults '20200627-1'
Declare  @LeagueName varchar(10) = 'nba'
, @UserName varchar(10)	= 'test'
	, @StartDate Date = '12/1/2017'
	, @EndDate Date	= '4/1/2018'
	, @GameDefaultOTamt float = .6



	/*

			Select 
				GETDATE(),   Games, Plays	-- 1/5
				,@LeagueName, @StartDate, @EndDate	,(@GameDefaultOTamt / 2)		-- 2/4
				,u.[GB1]      ,u.[GB2]      ,u.[GB3]										-- 3/3
				,u.[WeightGB1]      ,u.[WeightGB2]      ,u.[WeightGB3]				-- 4/3
				,u.[Threshold]      ,u.[BxScLinePct]      ,u.[BxScTmStrPct]      ,u.[TmStrAdjPct]	-- 5/4
				,u.[BothHome_Away]	-- 6.1
				, (overWins+UnderWins) as Wins, (overLosses+UnderLosses) as Losses	-- 6/2-3
				, dbo.udfDivide( OverWins+UnderWins, OverWins+UnderWins + overLosses+UnderLosses) * 100.0 as WLPct -- 6.4
				, Unders, Overs	--7/2
				, UnderWins, UnderLosses, dbo.udfDivide( UnderWins, UnderLosses+UnderWins) * 100.0 as UnderPct -- 8/3
				, OverWins,  OverLosses,  dbo.udfDivide( OverWins,  OverLosses + OverWins) * 100.0 as OverPct	-- 9/3
				, '' as 'Description'	-- 10/1
				, AvgScoreReg, AvgScoreRegwOT, AvgTotalLine	-- 11/3
				, AvgOurTotalLine, AvgLineDiffResultReg		-- 12/2
			From [UserLeagueParms] u
			 Join (
				Select 
	 				count(*) as Games
				  , Sum(
						CASE When tmr.Play > ' ' THEN 1
						ELSE 0
						END
						) as Plays
				  ,avg(ScoreReg) as AvgScoreReg
				  ,avg(ScoreReg) + @GameDefaultOTamt as 'AvgScoreRegwOT'
				  ,avg(TotalLine) as AvgTotalLine
				  ,avg(OurTotalLine) as AvgOurTotalLine
				  ,avg([LineDiffResultReg]) as AvgLineDiffResultReg

					, Sum(tmr.UnderWin) + Sum(tmr.UnderLoss) as Unders		
					, Sum(tmr.OverWin) + Sum(tmr.OverLoss) as Overs
					, Sum(tmr.UnderWin) as UnderWins		, Sum(tmr.UnderLoss) as UnderLosses
					, Sum(tmr.OverWin) as OverWins		, Sum(tmr.OverLoss) as OverLosses */
		select *
				 From [TodaysMatchupsResults] tmr 
				  Where tmr.LeagueName = @LeagueName  
				   AND  tmr.GameDate Between @StartDate and @EndDate
					AND tmr.Play > ' '
					/*
				 ) mr on 1 = 1
				Where u.UserName = @UserName
				*/
