
USE [00TTI_LeagueScores]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[udfQueryAdjustmentsByTeamTotal]') AND type in (N'TF'))
       DROP FUNCTION [dbo].[udfQueryAdjustmentsByTeamTotal]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================

USE [00TTI_LeagueScores]
GO
-- ==================================================================
-- Change History
-- ==================================================================
-- 
-- ==================================================================
-- EXEC udfQueryAdjustmentsByTeamTotal Parms...

CREATE FUNCTION [dbo].[udfQueryAdjustmentsByTeamTotal] (@GameDate Date, @LeagueName varchar(10))

RETURNS @TeamAdjSums TABLE
(
	Team varChar(4), TeamAdjSum float
)
AS
BEGIN

	Declare @LeagueAdj float;
	 Select @LeagueAdj = sum(a.AdjustmentAmount)
		FROM Adjustments a 
	  Where a.LeagueName = @LeagueName AND ( a.EndDate is null or a.EndDate = @GameDate)
	  and a.AdjustmentType = 'L'
   
		--Select @LeagueAdj
	Insert into @TeamAdjSums
	SELECT 
		a.Team, Sum(a.AdjustmentAmount) + @LeagueAdj as adjDB
	  FROM Adjustments a --on a.LeagueName = r.LeagueName and a.Team = r.Team
	  Where a.LeagueName = @LeagueName AND ( a.EndDate is null or a.EndDate = @GameDate)
	  Group by a.Team
	  order by team

    RETURN
END

