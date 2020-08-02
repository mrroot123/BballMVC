/****** Script for SelectTopNRows command from SSMS  ******/
Declare @LeagueName varchar(10) = 'WNBA';

SELECT  distinct -- 'Team',
 [TeamNameInDatabase]
  FROM [00TTI_LeagueScores].[dbo].[Team]
  where enddate is null and LeagueName = @LeagueName


