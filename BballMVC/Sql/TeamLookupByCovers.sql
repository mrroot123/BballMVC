USE [00TTI_LeagueScores]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TeamLookupByCovers]') AND type in (N'P', N'PC'))
       DROP PROCEDURE [dbo].[TeamLookupByCovers]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================
-- Author:                 Keith Doran
-- Create date:            10/28/2019
-- Description:            TeamLookupByCovers
-- ==================================================================
-- Change History
-- ==================================================================
-- 
-- ==================================================================
CREATE PROCEDURE [dbo].[TeamLookupByCovers] (       
		@LeagueName char(8)
	,	@GameDate Date
	,	@TeamSearchArg char(25)
   )
AS
   SET NOCOUNT ON;
              
   BEGIN  
       SELECT *
		  FROM [00TTI_LeagueScores].[dbo].[Teams] t
		  Where t.LeagueName = @LeagueName
			 AND @GameDate  between t.StartDate and isnull(t.EndDate, @GameDate)
			 AND t.TeamID_Covers = @TeamSearchArg
   END
GO