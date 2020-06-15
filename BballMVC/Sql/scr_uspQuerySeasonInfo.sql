
USE [00TTI_LeagueScores]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[uspQuerySeasonInfo]') AND type in (N'P', N'PC'))
       DROP PROCEDURE [dbo].[uspQuerySeasonInfo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================
-- Author:                 Keith Doran
-- Create date:            06/14/2020
-- Description:            Query SeasonInfo row by LeagueName & GameDate
-- ==================================================================
-- Change History
-- ==================================================================
-- 
-- ==================================================================
-- EXEC uspQuerySeasonInfo '7/1/2018', 'NBA'
CREATE PROCEDURE [dbo].[uspQuerySeasonInfo] ( @GameDate Date, @LeagueName varchar(10) )
AS
	SET NOCOUNT ON;
              
	BEGIN  
		SELECT
				 [StartDate]   ,[EndDate]
				,[Season]      ,[SubSeason]
				,[Bypass]
				,[IncludePre]	,[IncludePost]
				,[BoxscoreSource]
		  FROM [00TTI_LeagueScores].[dbo].[SeasonInfo] si
		  Where si.LeagueName = @LeagueName AND @GameDate BETWEEN si.StartDate and si.EndDate
	END
GO
