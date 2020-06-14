
USE [00TTI_LeagueScores]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[uspQueryAdjustmentsByTeamTotal]') AND type in (N'P', N'PC'))
       DROP PROCEDURE [dbo].[uspQueryAdjustmentsByTeamTotal]
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
-- EXEC uspQueryAdjustmentsByTeamTotal '3/6/2020', 'NBA'
CREATE PROCEDURE [dbo].[uspQueryAdjustmentsByTeamTotal] (@GameDate Date, @LeagueName varchar(10))
AS
	SET NOCOUNT ON;
              
	BEGIN  

	Declare @LeagueAdj float;
	 Select @LeagueAdj = sum(a.AdjustmentAmount)
		FROM Adjustments a 
	  Where a.LeagueName = @LeagueName AND ( a.EndDate is null or a.EndDate = @GameDate)
	  and a.AdjustmentType = 'L'
   
		--Select @LeagueAdj

	SELECT 
		a.Team, Sum(a.AdjustmentAmount) + @LeagueAdj as adjDB
	  FROM Adjustments a --on a.LeagueName = r.LeagueName and a.Team = r.Team
	  Where a.LeagueName = @LeagueName AND ( a.EndDate is null or a.EndDate = @GameDate)
	  Group by a.Team
	  order by team
	END
GO
