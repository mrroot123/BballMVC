 Find ALL TILDAs ~
USE [00TTI_LeagueScores]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[~udf_NAME]') AND type in (N'TF'))
       DROP FUNCTION [dbo].[~udf_NAME]
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
-- Select dbo.~udf_NAME Parms...

CREATE FUNCTION [dbo].[~udf_NAME] (~~ @UserName varchar(10), @GameDate Date, @LeagueName varchar(10))

RETURNS ~~var type
(
)
AS
BEGIN
~~
    RETURN
END

