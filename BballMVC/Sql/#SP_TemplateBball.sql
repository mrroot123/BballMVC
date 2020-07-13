
USE [00TTI_LeagueScores]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[uspQueryAnalysisResults]') AND type in (N'P', N'PC'))
       DROP PROCEDURE [dbo].[uspQueryAnalysisResults]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================
-- Author:                 Keith Doran
-- Create date:            06/27/2020
-- Description:            Display AnalysisResults for a perticular RunID
-- ==================================================================
-- Change History
-- ==================================================================
-- 
-- ==================================================================
-- EXEC uspQueryAnalysisResults '20200627-1'
create PROCEDURE [dbo].[uspQueryAnalysisResults] (@RunID nchar)
AS
	SET NOCOUNT ON;
              
	BEGIN  

Select StartDate, EndDate
      ,[Games]      ,[Plays]
      ,[Wins]      ,[Losses]
	, round(ar.AvgLineDiffResultReg,2) as LineDiffResultReg

	,round(ar.WLPct,2) as WinPct
	,round(ar.UnderPct,2) as UnderPct
	,round(ar.OverPct,2) as OverPct
--	,round(ar.WLPct,2) as WLPctx

	, round(ar.AvgOurTotalLine,2) as OurTL
	, round(ar.AvgScoreRegwOT,2) as RegwOT
	, round(ar.AvgTotalLine,2) as TL
	,BothHome_Away as HA
      ,[GB1]      ,[GB2]      ,[GB3]
		, Threshold
		, '====', * 
	From AnalysisResults ar  
	where RunID = @RunID	-- TS > Convert(Date, Getdate()) 
		--and ar.BothHome_Away >= 0
	 order by AvgLineDiffResultReg desc
		-- WLPct desc

	END
GO
