 Find ALL TILDAs ~
USE [00TTI_LeagueScores]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udfCalcPointPercentages]') AND type in (N'TF'))
       DROP FUNCTION [dbo].[udfCalcPointPercentages]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================
-- Author:                 Keith Doran
-- Create date:            06/06/2020
-- Description:            Calc Pct of Pts scored for Team - Pct of pts scored from 1, 2 & 3PTers
-- ==================================================================
-- Change History
-- ==================================================================
-- 
-- ==================================================================
-- EXEC udfCalcPointPercentages Parms...

CREATE FUNCTION [dbo].[udfCalcPointPercentages] (
	@CalcType varchar(10), @Score int
	, @LeagueName varchar(10), @TeamName varchar(10), @Venue varchar(10)
	, @Pt1 float, @Pt2 float, @Pt3 float
)

RETURNS @Pts Table
(
	PtOut1 float, PtOut2 float, PtOut3 float
)
AS
BEGIN

    RETURN
END

