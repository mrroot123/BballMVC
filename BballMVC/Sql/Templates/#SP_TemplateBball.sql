find all ~
USE [00TTI_LeagueScores]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[~~USPname]') AND type in (N'P', N'PC'))
       DROP PROCEDURE [dbo].[~~USPname]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================
-- Author:                 Keith Doran
-- Create date:            ~~
-- Description:            ~~
-- ==================================================================
-- Change History
-- ==================================================================
-- Date			Developer		Prod Date	Description

-- 
-- ==================================================================
-- EXEC ~~USPname  'NBA', '1920', 'Test'
create PROCEDURE [dbo].[~~USPname] 
(
 @GameDate Date, 	@LeagueName varchar(4), @UserName varchar(25)
)
AS
	SET NOCOUNT ON;
              
	BEGIN  -- USP



	END	-- USP
GO
