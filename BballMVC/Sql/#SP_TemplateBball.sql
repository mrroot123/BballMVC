Find ALL TILDAs ~
USE [00TTI_LeagueScores]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[~usp_NAME]') AND type in (N'P', N'PC'))
       DROP PROCEDURE [dbo].[~usp_NAME]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================
-- Author:                 Keith Doran
-- Create date:            ~DATE
-- Description:            ~DESC
-- ==================================================================
-- Change History
-- ==================================================================
-- 
-- ==================================================================
-- EXEC ~usp_NAME Parms...
CREATE PROCEDURE [dbo].[~usp_NAME] ( ~@parmNaem ParmType [OUTPUT] )
AS
	SET NOCOUNT ON;
              
	BEGIN  
			SELECT ~~~
	END
GO
